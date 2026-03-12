package main

import (
	"fmt"
	"os"

	"strings"

	"github.com/YianAndCode/tipsy/internal/cmd/create"
	"github.com/YianAndCode/tipsy/internal/cmd/new"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "tipsy",
	Short: "Tipsy is a CLI tool for Go gin projects",
}

func init() {
	v := strings.TrimPrefix(Version, "v")
	rootCmd.Version = v
	rootCmd.SetVersionTemplate("{{.Version}}\n")
	rootCmd.Long = `Tipsy is a command line interface that helps you work with the gin framework.
	It can create new gin projects and generate various components like entities,
	repositories, controllers, middlewares, and services.`

	originalHelpTemplate := rootCmd.HelpTemplate()
	execPath, _ := os.Executable()
	rootCmd.SetHelpTemplate(originalHelpTemplate + fmt.Sprintf("\ntipsy@%s %s\n", v, execPath))

	// 添加 create 子命令
	rootCmd.AddCommand(create.NewCreateCommand())
	// 添加 new 子命令
	rootCmd.AddCommand(new.NewCommand())
}
