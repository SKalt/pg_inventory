package main

import (
	"fmt"
	"io/fs"
	"log"
	"os"

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

var rootCmd = &cobra.Command{
	Use: "render_template",
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		shouldList, _ := flags.GetBool("list")

		searchDir, _ := flags.GetString("dir")
		searchDirInfo, err := os.Stat(searchDir)
		crashIf(err)
		if !searchDirInfo.IsDir() {
			log.Fatalf("%s is not a directory", searchDir)
		}
		if endsWith("/", searchDir) {
			searchDir = searchDir[:len(searchDir)-1]
		}

		// available template/param pairs
		entries, err := fs.ReadDir(os.DirFS(searchDir), ".")
		crashIf(err)
		templates := []string{}
		for _, e := range entries {
			if e.Type().IsRegular() && endsWith(".sql.tpl", e.Name()) {
				templates = append(templates, stripSuffix(".sql.tpl", e.Name()))
			}
		}

		tpl, _ := flags.GetString("tpl")
		if tpl == "all" {
			// continue with all available templates to be rendered
		} else {
			if endsWith(".sql.tpl", tpl) {
				tpl = stripSuffix(".sql.tpl", tpl)
			}
			found := false
			for _, t := range templates {
				if tpl == t {
					found = true
					break
				}
			}
			if !found {
				log.Fatalf("unknown template %s. (available templates: %s)", tpl, templates)
			}
		}

		includeDir, _ := flags.GetString("includes")
		includeDirInfo, err := os.Stat(includeDir)
		crashIf(err)
		if !includeDirInfo.IsDir() {
			log.Fatalf("%s is not a directory", includeDir)
		}
		if endsWith("/", includeDir) {
			includeDir = includeDir[:len(includeDir)-1]
		}
		includes := gatherIncludes(includeDir)
		fmt.Println(includes)

		if shouldList {
			fmt.Printf("dir=%s\ntpl=%s\n", searchDir, tpl)
		}
	},
}

func init() {
	rootCmd.Flags().StringP("dir", "d", "./", "the directory in which to find the template")
	rootCmd.Flags().StringP("tpl", "t", "all", "the template to use if there are many (default all)")
	rootCmd.Flags().StringArrayP("query", "q", []string{}, "the template target to render if there are many (default 'all')")
	rootCmd.Flags().StringP("includes", "i", "./", "a directory to search for sql files for includes")
	rootCmd.Flags().BoolP("list", "l", false, "whether to list found config/not")
}

// type paramInfo = map[string]interface{}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
	// find dir
	// load params.toml
	// render templates, serialize to disk
}
