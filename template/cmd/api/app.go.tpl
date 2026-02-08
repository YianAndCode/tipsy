package main

import (
	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/server"

	"github.com/google/wire"
)

// Application is the top-level struct for the application.
type Application struct {
	Server *server.APIServer
	Config *config.Config
	Logger contract.Logger
}

// NewApplication creates a new Application.
func NewApplication(
	apiServer *server.APIServer,
	config *config.Config,
	logger contract.Logger,
) *Application {
	return &Application{
		Server: apiServer,
		Config: config,
		Logger: logger,
	}
}

var appProviderSet = wire.NewSet(NewApplication)
