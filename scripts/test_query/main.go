package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"

	// TODO: use pg driver
	_ "github.com/lib/pq"
	// _ "github.com/docker/cli/cli/compose/types"
)

func crashIfErrNotNil(err error) {
	if err != nil {
		log.Panic(err)
	}
}

func getDockerComposeSpec(repoRoot string) map[string]interface{} {
	data, err := os.ReadFile(filepath.Join(repoRoot, "docker-compose.yaml"))
	crashIfErrNotNil(err)
	raw := make(map[string]interface{})
	crashIfErrNotNil(yaml.Unmarshal(data, &raw))
	return raw
}

func getPgPort(composeSpec map[string]interface{}, serviceName string) (string, error) {
	ports := composeSpec["services"].(map[string]interface{})[serviceName].(map[string]interface{})["ports"].([]interface{})
	for _, mapping := range ports {
		parts := strings.Split(mapping.(string), ":")
		if parts[1] == "5432" {
			return parts[0], nil
		}
	}
	return "", fmt.Errorf("unable to find postgres port for %s", serviceName)
}

func makeDsn(port string) string {
	return fmt.Sprintf(
		"user=postgres host=127.0.0.1 port=%s dbname=postgres sslmode=disable", port)
}

// cache, reuse connections to db servers
type dbServicePool struct {
	cache       map[string]*sql.DB
	composeSpec map[string]interface{}
}

func newDbServicePool(repoRoot string) *dbServicePool {
	return &dbServicePool{
		cache:       make(map[string]*sql.DB),
		composeSpec: getDockerComposeSpec(repoRoot),
	}
}
func (pool *dbServicePool) ensure(serviceName string) (db *sql.DB) {
	db = pool.get(serviceName)
	if db != nil {
		return db
	}
	var err error
	db, err = pool.waitFor(serviceName)
	crashIfErrNotNil(err)
	return db
}

func (pool *dbServicePool) get(name string) (db *sql.DB) {
	db, ok := pool.cache[name]
	if ok {
		return db
	} else {
		return nil
	}
}
func (pool *dbServicePool) getDsn(serviceName string) (dsn string, err error) {
	var port string
	port, err = getPgPort(pool.composeSpec, serviceName)
	if err != nil {
		return
	}
	dsn = makeDsn(port)
	return
}
func (pool *dbServicePool) cleanup() {
	for _, db := range pool.cache {
		if db != nil {
			db.Close() // don't report errors closing the db
		}
	}
}
func (pool *dbServicePool) waitFor(serviceName string) (db *sql.DB, err error) {
	db = pool.get(serviceName)
	if db != nil {
		return
	}
	cmd := exec.Command("docker", "compose", "up", "--wait", serviceName)
	err = cmd.Run()
	if err != nil {
		e := err.(*exec.ExitError)
		e.ExitCode()

		err = fmt.Errorf("`%v` exited %v", cmd.Args, e.ExitCode())
		return
	}
	var dsn string
	dsn, err = pool.getDsn(serviceName)
	if err != nil {
		return
	}
	db, err = waitFor(dsn, 15)
	return
}

func waitFor(dsn string, retries int) (db *sql.DB, err error) {
	ticker := time.NewTicker(time.Second)
	for i := 0; i <= retries; i++ {
		<-ticker.C // wait for a tick
		if db, err = sql.Open("postgres", dsn); err == nil {
			if err = db.Ping(); err == nil {
				if i > 0 {
					fmt.Println()
				}
				return
			} else {
				fmt.Printf(".")
			}
		} else {
			fmt.Printf(".")
		}
	}
	return
}

type testCase struct {
	testDir  string
	segments []string
}

func newTestCase(path string) (*testCase, error) {
	c := testCase{
		testDir: strings.TrimRight(strings.TrimSuffix(path, "results.tsv"), "/"),
	}
	c.segments = strings.Split(c.testDir, string(os.PathSeparator))
	err := c.validate()
	if err != nil {
		return nil, err
	}
	return &c, nil
}
func (c *testCase) testName() string {
	return c.segments[len(c.segments)-1]
}
func (c *testCase) dbName() string {
	return c.segments[len(c.segments)-2]
}
func (c *testCase) validate() (err error) {
	if len(c.segments) < 3 || c.segments[len(c.segments)-3] != "tests" {
		err = fmt.Errorf("%s is not a test-case", c.testDir)
	}
	return
}
func (c *testCase) queryName() string {
	return c.segments[len(c.segments)-4]
}
func (c *testCase) queryFile() string {
	return filepath.Clean(filepath.Join(c.testDir, "../../../query.sql"))
}
func (c *testCase) targetTsvPath() string {
	return filepath.Join(c.testDir, "results.tsv")
}
func getThisDir() string {
	_, file, _, _ := runtime.Caller(0)
	return filepath.Dir(file)
}
func getRepoRoot() string {
	return filepath.Clean(filepath.Join(getThisDir(), "../.."))
}
func findTestCases(absPath string) (result []*testCase, err error) {
	repoRoot := getRepoRoot()
	// kindsDir := filepath.Join(repoRoot, "db_object_kind")
	relPath, err := filepath.Rel(repoRoot, absPath)
	if err != nil {
		return
	}
	if strings.HasSuffix(relPath, "results.tsv") {
		tc, err := newTestCase(relPath)
		result = append(result, tc)
		if err != nil {
			return result, err
		}
	}
	err = filepath.WalkDir(relPath, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		var tc *testCase
		tc, err = newTestCase(path)
		if err == nil {
			result = append(result, tc)
		}
		return nil
	})
	return
}

var bareVar = regexp.MustCompile(":[a-z_]+") // watch out! can match ::type cast syntax
var stringVar = regexp.MustCompile(":'[a-z_]+'")

func findAllBarePsqlVarsIn(query string) []string {
	found := bareVar.FindAllString(query, -1)
	result := make([]string, len(found))
	for i, val := range found {
		result[i] = strings.Trim(val, ":")
	}
	return result
}

// detect psql-style variables, e.g. :foo or :'bar' but not :"baz"
func findAllVarsNamesIn(query string) []string {
	found := append(bareVar.FindAllString(query, -1), stringVar.FindAllString(query, -1)...)
	results := make([]string, len(found))
	for i, val := range found {
		results[i] = strings.TrimSuffix(strings.TrimPrefix(strings.TrimPrefix(val, "'"), ":"), "'")
	}
	return results
}

func interpolatePsqlVars(query string, params map[string]interface{}) (interpolated string, err error) {
	var msg string
	interpolated = bareVar.ReplaceAllStringFunc(query, func(name string) (result string) {
		val, ok := params[strings.Trim(name, ":")]
		if !ok {
			msg = fmt.Sprintf("<unknown variable %s>", name)
			err = fmt.Errorf(msg)
			return msg
		}
		switch real := val.(type) {
		case []interface{}:
			builder := strings.Builder{}
			builder.WriteString(fmt.Sprintf("(%v", real[0]))
			for _, el := range real[1:] {
				builder.WriteString(fmt.Sprintf(", %v", el))
			}
			builder.WriteRune(')')
			result = builder.String()
			return
		default:
			result = fmt.Sprintf("%v", val)
			return
		}
	})
	if err != nil {
		return
	}
	interpolated = stringVar.ReplaceAllStringFunc(interpolated, func(name string) (result string) {
		name = strings.TrimPrefix(name, ":'")
		name = strings.TrimSuffix(name, "'")
		val, ok := params[name]
		if !ok {
			msg := fmt.Sprintf("<unknown variable %s>", name)
			result = msg
			err = fmt.Errorf(msg)
			return
		}
		switch real := val.(type) {
		case int:
		case string:
			result = fmt.Sprintf("'%s'", real)
			return
		default:
			result = fmt.Sprintf("<variable %s is of an invalid type: %v>", name, real)
			err = fmt.Errorf(result)
			return
		}
		result = ""
		return
	})
	return interpolated, err
}

func rowsAsTsv(rows *sql.Rows) (string, error) {
	builder := strings.Builder{}
	tsv := csv.NewWriter(&builder)
	tsv.Comma = '\t'
	columnNames, err := rows.Columns()
	if err != nil {
		return "", err
	}
	tsv.Write(columnNames)
	intermediate := make([]*string, len(columnNames))
	row := make([]interface{}, len(columnNames))
	tsvRow := make([]string, len(columnNames))
	for rows.Next() {
		for i := range row {
			row[i] = &intermediate[i]
		}
		err = rows.Scan(row...)
		if err != nil {
			return "", err
		}
		for i, str := range intermediate {
			if str == nil {
				tsvRow[i] = ""
			} else {
				tsvRow[i] = *str
			}
		}
		tsv.Write(tsvRow)
	}
	tsv.Flush()
	return builder.String(), nil
}

type ioCache struct {
	cache map[string]string
}

func (f *ioCache) readFile(path string) (string, error) {
	str, ok := f.cache[path]
	if ok {
		return str, nil
	} else {
		blob, err := os.ReadFile(path)
		if err != nil {
			return "", err
		}
		str = string(blob)
		f.cache[path] = str
		return str, err
	}
}

func runTest(c *testCase, pool *dbServicePool, fileCache ioCache, accept bool, viewDiff bool) error {
	params := getParams(c.testDir)
	raw, err := fileCache.readFile(c.queryFile())
	if err != nil {
		return err
	}
	query, err := interpolatePsqlVars(raw, params)
	if err != nil {
		return err
	}
	if order, ok := params["order_by"]; ok {
		query += "\nORDER BY " + order.(string)
	}
	db, err := pool.waitFor(c.dbName())
	if err != nil {
		return err
	}
	rows, err := db.Query(query)
	if err != nil {
		return err
	}
	tsv, err := rowsAsTsv(rows)
	if err != nil {
		return err
	}
	var targetTsvFile *os.File
	_, missingErr := os.Stat(c.targetTsvPath())
	if missingErr != nil {
		accept = true
		targetTsvFile, err = os.Create(c.targetTsvPath())
		if err != nil {
			return err
		}
	} else {
		targetTsvFile, err = os.OpenFile(c.targetTsvPath(), os.O_RDWR, 0666)
		if err != nil {
			return err
		}
	}
	if accept {
		targetTsvFile.WriteString(tsv)
		return nil
	}
	expected, err := os.ReadFile(c.targetTsvPath())
	if err != nil {
		return err
	}

	if tsv != string(expected) {
		tempFile, err := os.CreateTemp("", fmt.Sprintf("%s--%s--%s?*", c.dbName(), c.queryName(), c.testName()))
		if err != nil {
			return err
		}
		tempFile.Truncate(0)
		_, err = tempFile.WriteString(tsv)
		if err != nil {
			return err
		}
		err = tempFile.Close()
		if err != nil {
			return err
		}
		if viewDiff {
			err = exec.Command("code", "--diff", c.targetTsvPath(), tempFile.Name()).Run()
			crashIfErrNotNil(err)
		}
		return fmt.Errorf("different: try running ```sh\ncode --diff %s %s\n```\nIf the change looks correct, run ```sh\nbin/test_query --accept %s\n```", c.targetTsvPath(), tempFile.Name(), c.targetTsvPath())
	} else {
		return nil
	}
}

func getParams(testDir string) map[string]interface{} {
	params := make(map[string]interface{}, 1)
	paramFile := path.Join(testDir, "params.toml")
	_, err := os.Stat(paramFile)
	if err == nil {
		blob, err := os.ReadFile(paramFile)
		crashIfErrNotNil(err)
		toml.Decode(string(blob), &params)
	}
	return params
}

var rootCmd = &cobra.Command{
	Use: "test_query",
	Args: func(cmd *cobra.Command, args []string) (err error) {
		err = cobra.ExactArgs(1)(cmd, args)
		return
	},
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		dryRun, err := flags.GetBool("dry-run")
		crashIfErrNotNil(err)
		accept, err := flags.GetBool("accept")
		crashIfErrNotNil(err)
		viewDiff, err := flags.GetBool("view-diff")
		crashIfErrNotNil(err)
		path := args[0]
		if !strings.HasPrefix(path, "/") {
			path, err = filepath.Abs(filepath.Join(".", path))
			crashIfErrNotNil(err)
		}
		testCases, err := findTestCases(path)
		crashIfErrNotNil(err)
		repoRoot := getRepoRoot()
		servicePool := newDbServicePool(repoRoot)
		dbUsage := map[string]uint8{}
		for _, tc := range testCases {
			db := tc.dbName()
			dbUsage[db]++
			_, err := servicePool.getDsn(db)
			crashIfErrNotNil(err)
		}
		if dryRun {
			fmt.Printf("db usage: %v", dbUsage)
		}
		cache := ioCache{cache: map[string]string{}}
		for _, tc := range testCases {
			if dryRun {
				fmt.Printf(
					"Would run %s using %s against %s",
					tc.testDir, tc.queryFile(), tc.dbName())
			} else {
				err = runTest(tc, servicePool, cache, accept, viewDiff)
				if err != nil {
					fmt.Printf(
						"failed to run %s using %s against %s",
						tc.testDir, tc.queryFile(), tc.dbName())
					log.Fatal(err)
				}
			}
		}
	},
}

func init() {
	flags := rootCmd.Flags()
	flags.Bool("dry-run", false, "print the commands that would be run")
	flags.BoolP("accept", "a", false, "accept the new input")
	flags.BoolP("view-diff", "v", false, "view the diff")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
