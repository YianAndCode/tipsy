package create

import (
	"fmt"

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
			// TODO: 实现项目创建逻辑
		},
	}
}
