package main

import (
	"github.com/YianAndCode/tipsy/internal/cmd/create"
	"github.com/YianAndCode/tipsy/internal/cmd/new"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "tipsy",
	Short: "Tipsy is a CLI tool for Go gin projects",
	Long: `Tipsy is a command line interface that helps you work with the gin framework.
	It can create new gin projects and generate various components like entities,
	controllers, middlewares, and services.`,
}

func init() {
	// 添加 create 子命令
	rootCmd.AddCommand(create.NewCreateCommand())
	// 添加 new 子命令
	rootCmd.AddCommand(new.NewCommand())
}
