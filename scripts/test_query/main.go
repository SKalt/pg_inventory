package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"regexp"
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
	if c.segments[len(c.segments)-3] != "tests" {
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

var bareVar = regexp.MustCompile(":[a-z]+") // watch out! can match ::type cast syntax
var stringVar = regexp.MustCompile(":'[a-z]+'")

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
	interpolated = bareVar.ReplaceAllStringFunc(query, func(name string) string {
		val, ok := params[strings.Trim(name, ":")]
		if !ok {
			msg := fmt.Sprintf("<unknown variable %s>", name)
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
			return builder.String()
		default:
			return fmt.Sprintf("%v", val)
		}
	})
	interpolated = stringVar.ReplaceAllStringFunc(interpolated, func(name string) string {
		name = strings.TrimPrefix(name, ":'")
		name = strings.TrimSuffix(name, "':")
		val, ok := params[name]
		if !ok {
			return fmt.Sprintf("<unknown variable %s>", name)
		}
		switch real := val.(type) {
		case int:
		case string:
			return fmt.Sprintf("'%s'", real)
		default:
			msg := fmt.Sprintf("<variable %s is of an invalid type: %v>", name, real)
			err = fmt.Errorf(msg)
			return msg
		}
		return ""
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

func runTest(c *testCase, pool *dbServicePool, accept bool) error {
	params := getParams(c.testDir)
	blob, err := os.ReadFile(c.queryFile())
	if err != nil {
		return err
	}
	query, err := interpolatePsqlVars(string(blob), params)
	if err != nil {
		return err
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
		// println(c.targetTsvPath())
		// println("expected", string(expected))
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
		testCase, err := newTestCase(args[0])
		crashIfErrNotNil(err)
		repoRoot := filepath.Clean(filepath.Join(testCase.testDir, "../../../../../../.."))
		servicePool := newDbServicePool(repoRoot)
		dsn, err := servicePool.getDsn(testCase.dbName())
		crashIfErrNotNil(err)
		if dryRun {
			fmt.Printf("query file: %s\n", testCase.queryFile())
			fmt.Printf("compare to: %s\n", testCase.targetTsvPath())
			fmt.Printf(" target db: %s\n", dsn)
			fmt.Printf("    accept: %v\n", accept)
			return
		}
		err = runTest(testCase, servicePool, accept)
		crashIfErrNotNil(err)
	},
}

func init() {
	flags := rootCmd.Flags()
	flags.Bool("dry-run", false, "print the commands that would be run")
	flags.BoolP("accept", "a", false, "accept the new input")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
