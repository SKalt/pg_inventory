package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"text/template"

	"github.com/BurntSushi/toml"
	"github.com/spf13/cobra"
)

// TODO: extract constants

func crashIf(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

// func endsWith(suffix string, str string) bool {
// 	if len(str) < len(suffix) {
// 		return false
// 	}
// 	return str[len(str)-len(suffix):] == suffix
// }

func stripSuffix(suffix string, str string) string {
	if len(str) < len(suffix) {
		return str
	}
	return str[:len(str)-len(suffix)]
}

// TODO: cache io?
// TODO: use file:// protocol?
func include(ctx map[string]string, relativePath string) (string, error) {
	dir := ctx["dir"]
	blob, err := ioutil.ReadFile(filepath.Clean(filepath.Join(dir, relativePath)))
	if err != nil {
		return "", err
	}
	return string(blob), err
}

func indent(n int, str string) string {
	return strings.ReplaceAll(str, "\n", "\n"+strings.Repeat("  ", n))
}

var rootCmd = &cobra.Command{
	Use: "render_template",
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		shouldList, _ := flags.GetBool("list")

		templatePath, err := flags.GetString("tpl")
		crashIf(err)
		tpl, err := template.ParseFiles(templatePath)
		crashIf(err)
		tpl.Funcs(template.FuncMap{"include": include, "indent": indent})
		if shouldList {
			fmt.Printf("tpl=%s\n", templatePath)
			fmt.Printf("%+v\n", tpl)
		}

		dir, templateFileName := path.Split(templatePath)
		templateName := stripSuffix(".sql.tpl", templateFileName)
		paramsPath := path.Join(dir, fmt.Sprintf("%s.params.toml", templateName))
		blob, err := ioutil.ReadFile(paramsPath)
		crashIf(err)

		params := make(map[string]map[string]interface{}, 1)
		// ^ need to initialize map pointer with some capacity, else Decode() does nothing
		_, err = toml.Decode(string(blob), &params)
		crashIf(err)
		for _, val := range params {
			val["dir"] = dir
		}
		if shouldList {
			fmt.Printf("params=\n%+v\n", params)
		}
		targetDir := filepath.Join(dir, fmt.Sprintf("queries/%s", templateName))
		err = os.MkdirAll(targetDir, os.ModePerm)
		crashIf(err)
		names, err := cmd.Flags().GetStringArray("query")
		crashIf(err)
		if len(names) == 0 {
			names = make([]string, 0, len(params))
			for name := range params {
				names = append(names, name)
			}
		}
		sort.Strings(names)

		for _, name := range names {
			if _, ok := params[name]; !ok {
				log.Fatalf("%s missing key %s", paramsPath, name)
			}
		}

		for _, name := range names {
			fmt.Println("-- name: ", name)
			var file io.Writer
			if shouldList {
				file = os.Stdout
			} else {
				file, err = os.Create(filepath.Join(targetDir, "query.sql"))
				crashIf(err)
			}
			err = tpl.Execute(file, params[name])
			crashIf(err)
		}
	},
}

func init() {
	rootCmd.Flags().StringP("tpl", "t", "", "Path to template-file to render")
	rootCmd.Flags().StringArrayP("query", "q", []string{}, "the template target to render if there are many (default 'all')")
	rootCmd.Flags().StringP("includes", "i", "./", "a directory to search for sql files for includes")
	rootCmd.Flags().BoolP("list", "l", false, "whether to list found config/not")
	rootCmd.Flags().Bool("dry-run", false, "print what would happen rather than executing it")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
