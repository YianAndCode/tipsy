package create

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	tplEng "github.com/YianAndCode/tipsy/internal/template"
	tplFs "github.com/YianAndCode/tipsy/template"

	"github.com/spf13/cobra"
)

// NewCreateCommand 创建 create 命令
func NewCreateCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "create [project-name]",
		Short: "Create a new Gin project",
		Long: `Create a new Gin project with a standard directory structure and necessary files.
	For example:
	  tipsy create my-gin-app`,
		Args: cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			projectName := args[0]
			fmt.Printf("Creating new Gin project: %s\n", projectName)

			// 获取当前工作目录
			cwd, err := os.Getwd()
			if err != nil {
				fmt.Printf("Error getting current working directory: %v\n", err)
				return
			}

			// 创建项目目录
			projectDir := filepath.Join(cwd, projectName)
			if err := os.MkdirAll(projectDir, 0755); err != nil {
				fmt.Printf("Error creating project directory: %v\n", err)
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

			// 遍历并渲染所有模板
			// 获取当前运行环境的 Go 版本
			goVersionCmd := exec.Command("go", "version")
			goVersionOutput, err := goVersionCmd.Output()
			if err != nil {
				fmt.Printf("Error getting Go version: %v\n", err)
				return
			}
			// 解析 Go 版本输出，格式类似 "go version go1.20.3 darwin/amd64"
			versionStr := string(goVersionOutput)
			versionParts := strings.Split(versionStr, " ")
			goVersion := ""
			if len(versionParts) >= 3 {
				goVersion = strings.TrimPrefix(versionParts[2], "go")
			}

			data := map[string]string{
				"ProjectName": projectName,
				"GoVersion":   goVersion,
			}

			for tplPath := range templates {
				// 如果模板文件名是 base.tpl 则跳过，这是用于 new 命令的
				if strings.HasSuffix(tplPath, "base.tpl") {
					continue
				}

				// 渲染模板
				result, err := tpl.Execute(tplPath, data)
				if err != nil {
					fmt.Printf("Error executing template %s: %v\n", tplPath, err)
					continue
				}

				// 计算目标文件路径
				targetPath := strings.TrimSuffix(tplPath, ".tpl")
				targetPath = filepath.Join(projectDir, targetPath)

				// 创建目标文件所在的目录
				targetDir := filepath.Dir(targetPath)
				if err := os.MkdirAll(targetDir, 0755); err != nil {
					fmt.Printf("Error creating directory for %s: %v\n", targetPath, err)
					continue
				}

				// 写入文件
				if err := os.WriteFile(targetPath, []byte(result), 0644); err != nil {
					fmt.Printf("Error writing file %s: %v\n", targetPath, err)
					continue
				}

				fmt.Printf("Generated file: %s\n", targetPath)
			}

			fmt.Printf("\nProject %s created successfully!\nDon't forget to exec: cd %s && go mod tidy\n", projectName, projectName)
		},
	}
}
