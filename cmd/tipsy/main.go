package main

import (
	"fmt"
	"os"
)

// 编译时通过 ldflags 注入
var Version = "dev"

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
