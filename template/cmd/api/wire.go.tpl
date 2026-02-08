//go:build wireinject
// +build wireinject

package main

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/controller"
	"{{ .ProjectName }}/internal/data"
	"{{ .ProjectName }}/internal/log"
	"{{ .ProjectName }}/internal/middleware"
	"{{ .ProjectName }}/internal/repo"
	"{{ .ProjectName }}/internal/router"
	"{{ .ProjectName }}/internal/server"
	"{{ .ProjectName }}/internal/service"

	"github.com/google/wire"
)

func initAPIServer() (*Application, func(), error) {
	// Naming provider sets with suffixes like "Config" or "Log" aids debugging.
	// If an error occurs, the provider set's name will appear in the error message,
	// making it easier to quickly identify the source of the problem.
	panic(wire.Build(
		appProviderSet,
		config.ProviderSetConfig,
		log.ProviderSetLog,
		data.ProviderSetData,
		server.ProviderSetServer,
		controller.ProviderSetController,
		application.ProviderSet,
		repo.ProviderSetRepo,
		service.ProviderSetService,
		router.ProviderSetRouter,
		middleware.ProviderSetMiddleware,
	))
}
