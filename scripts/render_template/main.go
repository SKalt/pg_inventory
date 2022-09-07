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
	"text/template/parse"

	"github.com/BurntSushi/toml"
	"github.com/spf13/cobra"
)

// TODO: extract constants

func crashIf(err error) {
	if err != nil {
		log.Panic(err)
	}
}

// func endsWith(suffix string, str string) bool {
// 	if len(str) < len(suffix) {
// 		return false
// 	}
// 	return str[len(str)-len(suffix):] == suffix
// }
func startsWith(prefix string, str string) bool {
	if len(str) < len(prefix) {
		return false
	}
	return str[:len(prefix)] == prefix
}

func walk(node parse.Node, callback func(n parse.Node) error) (err error) {
	err = callback(node)
	if err != nil {
		return
	}
	switch concrete := node.(type) {
	case *parse.BoolNode:
	case *parse.BreakNode:
	case *parse.ChainNode:
	case *parse.CommentNode:
	case *parse.ContinueNode:
	case *parse.DotNode:
	case *parse.FieldNode:
	case *parse.IdentifierNode:
	case *parse.NilNode:
	case *parse.NumberNode:
	case *parse.StringNode:
	case *parse.TextNode:
	case *parse.VariableNode:
		return nil
	case *parse.ListNode:
		if concrete == nil {
			return
		}
		for _, n := range concrete.Nodes {
			err = walk(n, callback)
			if err != nil {
				return
			}
		}
		return
	case *parse.ActionNode:
		return walk(concrete.Pipe, callback)
	case *parse.BranchNode:
		err = walk(concrete.List, callback)
		if err != nil {
			return
		}
		err = walk(concrete.ElseList, callback)
		if err != nil {
			return
		}
		err = walk(concrete.Pipe, callback)
		return
	case *parse.CommandNode:
		for _, n := range concrete.Args {
			err = walk(n, callback)
			if err != nil {
				return
			}
		}
		return
	case *parse.IfNode:
		return walk(&concrete.BranchNode, callback)
	case *parse.PipeNode:
		for _, n := range concrete.Cmds {
			err = walk(n, callback)
			if err != nil {
				return
			}
		}
		return
	case *parse.RangeNode:
		return walk(&concrete.BranchNode, callback)
	case *parse.TemplateNode:
		return walk(concrete.Pipe, callback)
	case *parse.WithNode:
		return walk(&concrete.BranchNode, callback)
	default:
		return
	}
	return
}

// TODO: cache io?
// TODO: use file:// protocol?
func include(ctx map[string]string, relativePath string) (string, error) {
	dir := ctx["dir"]
	relativePath = strings.TrimPrefix(relativePath, "file://")
	blob, err := ioutil.ReadFile(filepath.Clean(filepath.Join(dir, relativePath)))
	if err != nil {
		return "", err
	}
	return string(blob), err
}

// func listInclude(ctx map[string]string, relativePath string) (string, error) {
// 	dir := ctx["dir"]
// 	relativePath = strings.TrimPrefix(relativePath, "file://")
// 	relativePath = filepath.Clean(filepath.Join(dir, relativePath))
// 	fmt.Println(relativePath)
// 	return "", nil
// }

func indent(n int, str string) string {
	return strings.ReplaceAll(str, "\n", "\n"+strings.Repeat("  ", n))
}

var rootCmd = &cobra.Command{
	Use: "render_template",
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		dryRun, err := flags.GetBool("dry-run")
		crashIf(err)
		shouldList, err := flags.GetBool("debug")
		crashIf(err)
		shouldGatherIncludes, err := flags.GetBool("list-includes")
		crashIf(err)

		templatePath, err := flags.GetString("tpl")
		crashIf(err)
		if shouldList {
			fmt.Println("dry-run=", dryRun)
			fmt.Printf("tpl=%s\n", templatePath)
			fmt.Printf("%+v\n", templatePath)
			return
		}
		blob, err := ioutil.ReadFile(templatePath)
		crashIf(err)
		tpl, err := template.
			New("tpl").
			Funcs(template.FuncMap{"include": include, "indent": indent}).
			Parse(string(blob))
		crashIf(err)
		dir, templateFileName := path.Split(templatePath)
		printInclude := func(node parse.Node) (err error) {
			switch concrete := node.(type) {
			case *parse.CommandNode:
				if len(concrete.Args) == 3 { // && strings.HasPrefix(concrete.Args[1], "file://")
					if concrete.Args[0].String() == "include" {
						rel := strings.TrimPrefix(concrete.Args[2].String(), "\"file://")
						rel = strings.TrimSuffix(rel, "\"")
						rel = path.Join(dir, rel)
						rel = path.Clean(rel)
						fmt.Println(rel)
					}
				}
			}
			return
		}
		if shouldGatherIncludes {
			walk(tpl.Root, printInclude)
			return
		}

		templateName := strings.TrimSuffix(templateFileName, ".sql.tpl")
		paramsPath := path.Join(dir, fmt.Sprintf("%s.params.toml", templateName))
		blob, err = ioutil.ReadFile(paramsPath)
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
			if shouldList || dryRun {
				fmt.Println("-- name: ", name)
			}
			var file io.Writer
			if dryRun {
				file = os.Stdout
			} else {
				targetDir := filepath.Join(dir, "queries", name)
				err = os.MkdirAll(targetDir, os.ModePerm)
				crashIf(err)
				targetFile := filepath.Join(targetDir, "query.sql")
				file, err = os.Create(targetFile)
				crashIf(err)
				fmt.Println(targetFile)
			}
			err = tpl.Execute(file, params[name])
			crashIf(err)
		}
	},
}

func init() {
	rootCmd.Flags().StringP("tpl", "t", "", "Path to template-file to render")
	rootCmd.Flags().StringArrayP("query", "q", []string{}, "the template target to render if there are many (default 'all')")
	rootCmd.Flags().BoolP("list-includes", "l", false, "print each of the included files")
	rootCmd.Flags().BoolP("debug", "d", false, "print CLI configuration")
	rootCmd.Flags().Bool("dry-run", false, "print what would happen rather than executing it")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
