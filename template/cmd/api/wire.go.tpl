//go:build wireinject
// +build wireinject

package main

import (
	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/controller"
	"{{ .ProjectName }}/internal/middleware"
	"{{ .ProjectName }}/internal/repo"
	"{{ .ProjectName }}/internal/router"
	"{{ .ProjectName }}/internal/server"
	"{{ .ProjectName }}/internal/service"

	"github.com/google/wire"
)

func initAPIServer(log contract.Logger, cnf *config.Config) *server.APIServer {
	panic(wire.Build(
		server.ProviderSetServer,
		controller.ProviderSetController,
		repo.ProviderSetRepo,
		service.ProviderSetService,
		router.ProviderSetRouter,
		middleware.ProviderSetMiddleware,
	))
}
