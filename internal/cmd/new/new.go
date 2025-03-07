package new

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	tplEng "github.com/YianAndCode/tipsy/internal/template"
	"github.com/YianAndCode/tipsy/internal/utils"
	tplFs "github.com/YianAndCode/tipsy/template"

	"github.com/spf13/cobra"
)

// NewCommand 创建 new 命令
func NewCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "new [type] [name]",
		Short: "Create a new component",
		Long: `Create a new component for your Gin project.
	Supported types: entity, repo, controller, middleware, service
	For example:
	  tipsy new entity User
	  tipsy new repo User
	  tipsy new controller UserController
	  tipsy new middleware Auth
	  tipsy new service UserService`,
		Args: cobra.ExactArgs(2),
		Run: func(cmd *cobra.Command, args []string) {
			firtstLetterUpper := func(s string) string {
				return strings.ToUpper(s[:1]) + s[1:]
			}
			componentType := args[0]
			componentName := firtstLetterUpper(args[1]) // 确保首字母大写

			// 【说明】
			// 目前支持五类组件：entity、repo、controller、middleware、service
			// 根据组件类型创建对应的文件夹和文件：
			// entity: 参数：Name 模板：internal/entity/base.tpl -> internal/entity/{name}.go
			// repo: 参数：RepoName 模板：internal/repo/base.tpl -> internal/repo/{name}/{name}_repo.go
			// controller: ControllerName 模板：internal/controller/base.tpl -> internal/controller/{name}/{name}_controller.go
			// middleware: MiddlewareName 模板：internal/middleware/base.tpl -> internal/middleware/{name}/{name}_middleware.go
			// service: ServiceName 模板：internal/service/base.tpl -> internal/service/{name}/{name}_service.go
			//
			// 它们都有一个共同的参数 ProjectName，通过读取 $(pwd)/.tipsy.env 中的 TIPSY_PROJECT_NAME 变量获取
			// repo/controller/middleware/service 都需要生成 provider，即在 internal/{component}/provider.go 文件中注册组件，
			// 需要增加 import 项和在 wire.NewSet() 的最后一个参数追加 New 函数
			//
			// controller 需要在 internal/controller/dto/ 下新增一个 {name}.go 文件

			// 验证组件类型是否合法
			validTypes := map[string]bool{
				"entity":     true,
				"repo":       true,
				"controller": true,
				"middleware": true,
				"service":    true,
			}
			if !validTypes[componentType] {
				fmt.Printf("Error: unsupported component type '%s'. Supported types are: entity, repo, controller, middleware, service\n", componentType)
				return
			}

			fmt.Printf("Creating a new %s named %s\n", componentType, componentName)

			// 获取当前工作目录
			cwd, err := os.Getwd()
			if err != nil {
				fmt.Printf("Error getting current working directory: %v\n", err)
				return
			}

			// 读取 .tipsy.env 文件获取项目名
			envContent, err := os.ReadFile(filepath.Join(cwd, ".tipsy.env"))
			if err != nil {
				fmt.Printf("Error reading .tipsy.env file: %v\n", err)
				return
			}
			envLines := strings.Split(string(envContent), "\n")
			projectName := ""
			for _, line := range envLines {
				if strings.HasPrefix(line, "TIPSY_PROJECT_NAME=") {
					projectName = strings.TrimPrefix(line, "TIPSY_PROJECT_NAME=")
					break
				}
			}
			if projectName == "" {
				fmt.Println("Error: TIPSY_PROJECT_NAME not found in .tipsy.env")
				return
			}

			// 初始化模板引擎
			tpl := tplEng.New(tplFs.TemplateFS)
			if err := tpl.LoadTemplates(); err != nil {
				fmt.Printf("Error loading templates: %v\n", err)
				return
			}

			// 获取所有模板
			templates := tpl.GetTemplates()

			// 根据组件类型查找对应的模板
			var matchedTemplates []string
			for tplPath := range templates {
				if strings.Contains(tplPath, fmt.Sprintf("internal/%s", componentType)) {
					matchedTemplates = append(matchedTemplates, tplPath)
				}
			}

			if len(matchedTemplates) == 0 {
				fmt.Printf("No templates found for component type: %s\n", componentType)
				return
			}

			// 准备模板数据
			data := map[string]string{
				"ProjectName": projectName,
			}

			// 根据组件类型设置特定参数
			switch componentType {
			case "entity":
				data["Name"] = componentName
			case "repo":
				data["RepoName"] = componentName
			case "controller":
				data["ControllerName"] = componentName
			case "middleware":
				data["MiddlewareName"] = componentName
			case "service":
				data["ServiceName"] = componentName
			}

			// 渲染并保存组件文件
			for _, tplPath := range matchedTemplates {
				if !strings.HasSuffix(tplPath, "base.tpl") {
					continue
				}

				// 计算目标文件路径
				var targetPath string
				switch componentType {
				case "entity":
					targetPath = filepath.Join(cwd, "internal", "entity", utils.ToSnakeCase(componentName)+".go")
				case "repo":
					targetPath = filepath.Join(cwd, "internal", "repo", utils.ToSnakeCase(componentName), utils.ToSnakeCase(componentName)+"_repo.go")
				case "controller":
					targetPath = filepath.Join(cwd, "internal", "controller", utils.ToSnakeCase(componentName), utils.ToSnakeCase(componentName)+"_controller.go")
				case "middleware":
					targetPath = filepath.Join(cwd, "internal", "middleware", utils.ToSnakeCase(componentName), utils.ToSnakeCase(componentName)+"_middleware.go")
				case "service":
					targetPath = filepath.Join(cwd, "internal", "service", utils.ToSnakeCase(componentName), utils.ToSnakeCase(componentName)+"_service.go")
				}

				// 检查文件是否已存在
				if _, err := os.Stat(targetPath); err == nil {
					fmt.Printf("Error: %s already exists\n", targetPath)
					return
				} else if !os.IsNotExist(err) {
					fmt.Printf("Error checking file %s: %v\n", targetPath, err)
					return
				}

				// 创建目标文件所在的目录
				targetDir := filepath.Dir(targetPath)
				if err := os.MkdirAll(targetDir, 0755); err != nil {
					fmt.Printf("Error creating directory for %s: %v\n", targetPath, err)
					continue
				}

				result, err := tpl.Execute(tplPath, data)
				if err != nil {
					fmt.Printf("Error executing template %s: %v\n", tplPath, err)
					continue
				}

				// 写入文件
				if err := os.WriteFile(targetPath, []byte(result), 0644); err != nil {
					fmt.Printf("Error writing file %s: %v\n", targetPath, err)
					continue
				}

				fmt.Printf("Generated file: %s\n", targetPath)

				// 更新 provider.go
				if componentType != "entity" {
					providerPath := filepath.Join(cwd, "internal", componentType, "provider.go")
					providerContent, err := os.ReadFile(providerPath)
					if err != nil {
						fmt.Printf("Error reading provider file: %v\n", err)
						continue
					}

					// 更新 provider.go 文件内容
					lines := strings.Split(string(providerContent), "\n")

					// 在 import 块中添加新组件的导入
					importPath := fmt.Sprintf("\t\"%s/internal/%s/%s\"\n", projectName, componentType, utils.ToSnakeCase(componentName))
					importAdded := false
					for i, line := range lines {
						if strings.Contains(line, "import (") {
							// 找到 import 块的结束位置
							for j := i + 1; j < len(lines); j++ {
								if lines[j] == ")" {
									// 在 import 块的末尾添加新的导入
									lines = append(lines[:j], append([]string{importPath}, lines[j:]...)...)
									importAdded = true
									break
								}
							}
							break
						}
					}

					if !importAdded {
						fmt.Printf("Error: could not find import block in provider file\n")
						continue
					}

					// 在 wire.NewSet 的最后添加新组件
					for i, line := range lines {
						if strings.Contains(line, "wire.NewSet(") {
							// 找到最后一个参数
							for j := i + 1; j < len(lines); j++ {
								if strings.Contains(lines[j], ")") {
									// 在最后一个参数后添加新组件
									newProvider := fmt.Sprintf("\t%s.New%s%s,", utils.ToSnakeCase(componentName), componentName, firtstLetterUpper(componentType))
									lines = append(lines[:j], append([]string{newProvider}, lines[j:]...)...)
									break
								}
							}
							break
						}
					}

					// 写入更新后的 provider.go
					if err := os.WriteFile(providerPath, []byte(strings.Join(lines, "\n")), 0644); err != nil {
						fmt.Printf("Error updating provider file: %v\n", err)
					}
				}

				// 新增 dto
				if componentType == "controller" {
					dtoPath := filepath.Join(cwd, "internal", "controller", "dto", fmt.Sprintf("%s.go", componentName))
					// 检查文件是否已存在
					if _, err := os.Stat(dtoPath); err == nil {
						fmt.Printf("Error: %s already exists\n", dtoPath)
						return
					} else if !os.IsNotExist(err) {
						fmt.Printf("Error checking file %s: %v\n", dtoPath, err)
						return
					}
					// 创建目标文件所在的目录
					targetDir := filepath.Dir(dtoPath)
					if err := os.MkdirAll(targetDir, 0755); err != nil {
						fmt.Printf("Error creating directory for %s: %v\n", dtoPath, err)
						continue
					}
					result, err := tpl.Execute("internal/controller/dto/base.tpl", data)
					if err != nil {
						fmt.Printf("Error executing template %s: %v\n", "internal/controller/dto/base.tpl", err)
						continue
					}
					// 写入文件
					if err := os.WriteFile(dtoPath, []byte(result), 0644); err != nil {
						fmt.Printf("Error writing file %s: %v\n", dtoPath, err)
						continue
					}
				}
			}
		},
	}

	return cmd
}
