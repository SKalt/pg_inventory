package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/spf13/cobra"
)

var dsns = map[string]string{
	"empty":   "user=postgres host=127.0.0.1 port=50000 dbname=postgres",
	"sakila":  "user=postgres host=127.0.0.1 port=50001 dbname=postgres",
	"omnibus": "user=postgres host=127.0.0.1 port=50002 dbname=postgres",
}

func crashIf(err error) {
	if err != nil {
		log.Panic(err)
	}
}

func waitFor(dsn string, retries int) {
	ticker := time.NewTicker(time.Second)
	// psql, err := exec.LookPath("psql")
	// crashIf(err)
	args := []string{dsn, "-c", "select 1"}
	cmd := exec.Command("psql", dsn, "-c", "select 1")
	for i := 0; i <= retries; i++ {
		<-ticker.C // wait for a tick
		// 	Path:  psql,
		// 	Args:  args,
		// 	Stdin: strings.NewReader(""),
		// }
		err := cmd.Run()
		if err == nil {
			if i > 0 {
				fmt.Println()
			}
			return
		} else {
			fmt.Printf(".")
		}
	}
	log.Fatalf(
		"%v timed out after %d seconds",
		fmt.Sprintf("%s '%s' '%s' '%s'", cmd, args[0], args[1], args[2]),
		retries,
	)
}

var rootCmd = &cobra.Command{
	Use: "test_query",
	Args: func(cmd *cobra.Command, args []string) error {
		err := cobra.ExactArgs(1)(cmd, args)
		if err != nil {
			return err
		}
		dir, err := os.Stat(args[0])
		if err != nil || !dir.IsDir() {
			return fmt.Errorf("%s is not a directory", args[0])
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		testDir := args[0]
		flags := cmd.Flags()
		dryRun, err := flags.GetBool("dry-run")
		crashIf(err)
		accept, err := flags.GetBool("accept")
		crashIf(err)
		testDir = strings.TrimRight(testDir, "/")
		segments := strings.Split(testDir, string(os.PathSeparator))
		if segments[len(segments)-3] != "tests" {
			log.Fatalf("%s is not a test-case", testDir)
		}
		dbName := segments[len(segments)-2]
		dsn, ok := dsns[dbName]
		if !ok {
			log.Fatalf("%s is not a known db service", dbName)
		}

		params := make(map[string]interface{}, 1)
		paramFile := path.Join(testDir, "params.toml")
		_, err = os.Stat(paramFile)
		if err == nil {
			blob, err := os.ReadFile(paramFile)
			crashIf(err)
			toml.Decode(string(blob), &params)
		}

		subCmdArgs := make([]string, 0, len(params))
		subCmdArgs = append(subCmdArgs, dsn, "--set=ON_ERROR_STOP=on")
		for key, value := range params {
			subCmdArgs = append(subCmdArgs, fmt.Sprintf("--set=%s=%s", key, value))
		}
		sort.Strings(subCmdArgs)
		queryFile := filepath.Clean(filepath.Join(testDir, "../../../query.sql"))
		queryName := filepath.Base(filepath.Dir(queryFile))
		blob, err := os.ReadFile(queryFile)
		crashIf(err)
		query := fmt.Sprintf("COPY (\n%s\n)\nTO STDOUT WITH (FORMAT csv, DELIMITER '\t', HEADER on);", string(blob))
		targetTsvPath := filepath.Join(testDir, "results.tsv")

		subCmd := exec.Command("psql", subCmdArgs...)
		// dbName
		if dryRun {
			fmt.Printf("%+v\n", subCmd)
			fmt.Printf("--query:\n%s\n", query)
			fmt.Printf(">%s\n", targetTsvPath)
			return
		}
		tempFile, err := os.CreateTemp("", fmt.Sprintf("%s--%s*", dbName, queryName))
		crashIf(err)
		waitFor(dsn, 5)
		subCmd.Stdout = tempFile
		subCmd.Stderr = os.Stderr
		subCmd.Stdin = strings.NewReader(query)
		err = subCmd.Run()
		crashIf(err)
		if _, err = os.Stat(targetTsvPath); err != nil {
			// the file doesn't exist: write the output to it
			accept = true
		}
		targetTsv, err := os.OpenFile(targetTsvPath, os.O_CREATE|os.O_RDWR, 0666)
		crashIf(err)

		diff := exec.Command("diff", "-u", targetTsv.Name(), tempFile.Name())
		diff.Stdout = os.Stdout
		diff.Stderr = os.Stderr
		err = diff.Run()
		if accept {
			result, err := os.ReadFile(tempFile.Name())
			crashIf(err)
			_, err = targetTsv.Write(result)
			crashIf(err)
		} else {
			if err != nil {
				os.Exit(diff.ProcessState.ExitCode())
			} else {
				fmt.Printf("%s: ok\n", testDir)
			}
		}
	},
}

func init() {
	flags := rootCmd.Flags()
	flags.Bool("dry-run", false, "print the commands that would be run")
	flags.Bool("accept", false, "accept the new input")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
