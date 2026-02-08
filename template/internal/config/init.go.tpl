package config

import (
	"os"
	"{{ .ProjectName }}/cmd/api/bootstrap"

	"github.com/google/wire"
	"gopkg.in/yaml.v3"
)

// NewConfig creates a new Config by reading from a yaml file.
// It is a wire provider that encapsulates flag parsing and file reading.
func NewConfig() (*Config, error) {
	// Get config file path from command-line flag
	flag := bootstrap.ParseFlag()

	// Read config file
	data, err := os.ReadFile(flag.Config)
	if err != nil {
		return nil, err
	}

	// Unmarshal yaml
	var cnf Config
	if err := yaml.Unmarshal(data, &cnf); err != nil {
		return nil, err
	}

	return &cnf, nil
}

var ProviderSetConfig = wire.NewSet(NewConfig)
