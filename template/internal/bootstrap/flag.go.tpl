package bootstrap

import "flag"

type Flag struct {
	Config string
}

func ParseFlag() *Flag {
	var f Flag

	flag.StringVar(&f.Config, "config", "./config.yaml", "/path/to/config.yaml")
	flag.Parse()

	return &f
}
