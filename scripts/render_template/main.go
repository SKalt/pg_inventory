package main

import (
	"fmt"
	"io"
	"io/fs"
	"io/ioutil"
	"log"
	"os"
	"path"
	"path/filepath"
	"sort"
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

func endsWith(suffix string, str string) bool {
	if len(str) < len(suffix) {
		return false
	}
	return str[len(str)-len(suffix):] == suffix
}

func stripSuffix(suffix string, str string) string {
	if len(str) < len(suffix) {
		return str
	}
	return str[:len(str)-len(suffix)]
}

func gatherIncludes(dir string) []string {
	result := []string{}
	root := os.DirFS(dir)
	fs.WalkDir(root, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() || !endsWith(".sql", path) {
			return err
		}
		mode := d.Type()
		if mode.IsRegular() {
			result = append(result, path)
		}
		return err
	})
	return result
}

func findIncludesDir(dir string) (string, error) {
	var err error
	dir, err = filepath.Abs(dir)
	if err != nil {
		return dir, err
	}
	parts := filepath.SplitList(dir)
	i := 0
	for _, part := range parts {
		if part == "db_object_kind" {
			break
		}
		i++
	}
	dir = filepath.Join(parts[:i]...)
	// try and make it relative to cwd?
	cwd, err := filepath.Abs(".")
	if err != nil {
		return dir, err
	}
	if ok, err := filepath.Rel(cwd, dir); err == nil {
		return ok, err
	} else {
		return dir, nil
	}
}

// func render(tpl *template.Template, params interface{}, target string) error {
// 	os.Create(target)
// }

var rootCmd = &cobra.Command{
	Use: "render_template",
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		shouldList, _ := flags.GetBool("list")

		templatePath, err := flags.GetString("tpl")
		crashIf(err)
		tpl, err := template.ParseFiles(templatePath)
		crashIf(err)
		if shouldList {
			fmt.Printf("tpl=%s\n", templatePath)
			fmt.Printf("%+v\n", tpl)
		}

		dir, templateFileName := path.Split(templatePath)
		blob, err := ioutil.ReadFile(path.Join(dir, fmt.Sprintf("%s.params.toml", stripSuffix(".sql.tpl", templateFileName))))
		crashIf(err)

		params := make(map[string]interface{}, 1)
		// ^ need to initialize map pointer with some capacity, else Decode() does nothing
		_, err = toml.Decode(string(blob), &params)
		crashIf(err)
		if shouldList {
			fmt.Printf("params=\n%+v\n", params)
		}
		includesDir, err := findIncludesDir(dir)
		crashIf(err)
		if shouldList {
			fmt.Printf("includes dir = %s\n", includesDir)
		}
		includes := gatherIncludes(includesDir)
		if shouldList {
			fmt.Printf("includes = %s\n", includes)
		}
		targetDir := filepath.Join(dir, fmt.Sprintf("queries/%s", stripSuffix(".sql.tpl", templateFileName)))
		fmt.Println(templateFileName, targetDir)
		err = os.MkdirAll(targetDir, os.ModePerm)
		crashIf(err)
		names := make([]string, 0, len(params))
		for name := range params {
			names = append(names, name)
		}
		sort.Strings(names)
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
	// find dir
	// load params.toml
	// render templates, serialize to disk
}
