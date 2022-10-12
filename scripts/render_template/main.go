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
	"gonum.org/v1/gonum/stat/combin"
)

func crashIf(err error) {
	if err != nil {
		log.Panic(err)
	}
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
func include(ctx map[string]interface{}, relativePath string) (string, error) {
	thisDir := ctx["dir"].(string)
	relativePath = strings.TrimPrefix(relativePath, "file://")
	relativePath = filepath.Clean(filepath.Join(thisDir, relativePath))
	blob, err := os.ReadFile(relativePath)
	if err != nil {
		return "", err
	}
	str := string(blob)
	if strings.HasSuffix(relativePath, ".tpl") {
		thatDir := filepath.Dir(relativePath)
		cloned := make(map[string]interface{}, len(ctx))
		for key, value := range ctx {
			cloned[key] = value
		}
		cloned["dir"] = thatDir
		tpl, err := template.New("include").Parse(str)
		if err != nil {
			return "", err
		}
		return renderToStr(tpl, ctx)
	} else {
		return str, err
	}
}

func indent(n int, str string) string {
	return strings.ReplaceAll(str, "\n", "\n"+strings.Repeat("  ", n))
}

func renderToStr(tpl *template.Template, options any) (string, error) {
	builder := strings.Builder{}
	err := tpl.Execute(&builder, options)
	return builder.String(), err
}

// find each of the names to render, zipped with the parameters with which to render that name
func getParams(path string) ([]string, []map[string]interface{}) {
	blob, err := os.ReadFile(path)
	crashIf(err)
	params := make(map[string]interface{}, 1)
	// ^ need to initialize map pointer with some capacity, else Decode() does nothing
	_, err = toml.Decode(string(blob), &params)
	crashIf(err)
	dir := filepath.Dir(path)
	if namePattern, isOrthogonal := params["name_template"]; isOrthogonal {
		nameTpl := template.Must(template.New("name").Parse(namePattern.(string)))
		delete(params, "name_template")
		nExpected := 1
		keys := make([]string, 0, len(params))
		for key, values := range params {
			m := len(values.(map[string]interface{})) // maps option name => option value
			if m == 0 {
				delete(params, key)
			} else {
				nExpected = nExpected * m // name_component => value
				keys = append(keys, key)
			}
		}

		sort.Strings(keys)
		lens := make([]int, len(keys))
		groups := make([]map[string]interface{}, len(keys))
		optionKeys := make([][]string, len(keys))
		for i, key := range keys {
			options := params[key].(map[string]interface{})
			optKeys := make([]string, 0, len(options))
			for optName := range options {
				optKeys = append(optKeys, optName)
			}
			sort.Strings(optKeys)
			groups[i] = options
			optionKeys[i] = optKeys
			lens[i] = len(options)
		}
		// nameParams := make([]map[string]string, nExpected)
		queryParams := make([]map[string]interface{}, nExpected)
		queryNames := make([]string, nExpected)
		generator := combin.NewCartesianGenerator(lens)
		i := 0
		for generator.Next() {
			combo := generator.Product(make([]int, len(keys)))
			nameParamSet := make(map[string]string, len(keys))
			queryParamSet := make(map[string]interface{}, len(keys))
			queryParamSet["dir"] = dir
			for j, optIndex := range combo {
				key := keys[j]
				group := groups[j]
				optionKey := optionKeys[j][optIndex]
				optionValue := group[optionKey]
				nameParamSet[key] = optionKey
				queryParamSet[key] = optionValue
			}
			queryName, err := renderToStr(nameTpl, nameParamSet)
			crashIf(err)
			queryNames[i] = queryName
			queryParams[i] = queryParamSet
			i++
		}
		return queryNames, queryParams
	} else {
		queryNames := make([]string, 0, len(params))
		for name := range params {
			queryNames = append(queryNames, name)
		}
		sort.Strings(queryNames)
		queryParams := make([]map[string]interface{}, len(params))

		for i, name := range queryNames {
			queryParams[i] = params[name].(map[string]interface{})
			queryParams[i]["dir"] = dir
		}
		return queryNames, queryParams
	}
}

var rootCmd = &cobra.Command{
	Use: "render_template",
	Run: func(cmd *cobra.Command, args []string) {
		flags := cmd.Flags()
		dryRun, err := flags.GetBool("dry-run")
		crashIf(err)
		debug, err := flags.GetBool("debug")
		crashIf(err)
		shouldGatherIncludes, err := flags.GetBool("list-includes")
		crashIf(err)
		paramsPath, err := flags.GetString("params")
		crashIf(err)
		templatePath, err := flags.GetString("tpl")
		crashIf(err)

		if debug {
			fmt.Println("dry-run = ", dryRun)
			fmt.Println("tpl = ", templatePath)
			fmt.Printf("template path = %+v\n", templatePath)
		}
		blob, err := ioutil.ReadFile(templatePath)
		crashIf(err)
		tpl, err := template.
			New("tpl").
			Funcs(template.FuncMap{"include": include, "indent": indent}).
			Parse(string(blob))
		crashIf(err)
		dir, templateFileName := path.Split(templatePath)
		if shouldGatherIncludes {
			printInclude := func(node parse.Node) (err error) {
				switch concrete := node.(type) {
				case *parse.CommandNode:
					if len(concrete.Args) == 3 { // {{ include . "file://..."}}
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
			walk(tpl.Root, printInclude)
			return
		}

		templateName := strings.TrimSuffix(templateFileName, ".sql.tpl")
		if paramsPath == "" {
			paramsPath = path.Join(dir, fmt.Sprintf("%s.params.toml", templateName))
		}
		queryNames, queryParams := getParams(paramsPath)
		selectedQueryNames, err := cmd.Flags().GetStringArray("query")
		crashIf(err)
		sort.Strings(selectedQueryNames)
		if len(selectedQueryNames) == 0 {
			selectedQueryNames = queryNames
		} else {
			for _, name := range selectedQueryNames {
				found := false
				for _, queryName := range queryNames {
					if name == queryName {
						found = true
						break
					}
				}
				if !found {
					log.Fatalf(
						"unrecognized query name: %s\noptions are:\n  %v",
						name, strings.Join(queryNames, "\n  "),
					)
				}
			}
		}

		for i, name := range selectedQueryNames {
			p := queryParams[i]
			if debug || dryRun {
				fmt.Println("-- name: ", name)
			}
			targetDir := filepath.Join(dir, "queries", name)
			targetFile := filepath.Join(targetDir, "query.sql")
			var file io.Writer
			if dryRun {
				file = os.Stdout
			} else if debug {
				file, err = os.OpenFile(os.DevNull, os.O_RDWR, 0777)
				crashIf(err)
			} else {
				err = os.MkdirAll(targetDir, os.ModePerm)
				crashIf(err)
				file, err = os.Create(targetFile)
				crashIf(err)
			}
			// fmt.Println(targetFile)
			err = tpl.Execute(file, p)
			crashIf(err)
		}
	},
}

func init() {
	rootCmd.Flags().StringP("tpl", "t", "", "Path to template-file to render")
	rootCmd.Flags().StringP("params", "p", "", "Path to template parameters toml file")
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
