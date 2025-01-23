package new

import (
	"fmt"

	"github.com/spf13/cobra"
)

// NewCommand 创建 new 命令
func NewCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "new [type] [name]",
		Short: "Create a new component",
		Long: `Create a new component for your Gin project.
	Supported types: entity, controller, middleware, service
	For example:
	  tipsy new entity User
	  tipsy new controller UserController
	  tipsy new middleware Auth
	  tipsy new service UserService`,
		Args: cobra.ExactArgs(2),
		Run: func(cmd *cobra.Command, args []string) {
			componentType := args[0]
			componentName := args[1]
			fmt.Printf("Creating a new %s named %s\n", componentType, componentName)
			// TODO: 创建组件
		},
	}

	return cmd
}
