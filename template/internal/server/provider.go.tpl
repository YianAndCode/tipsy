package server

import (
	"github.com/gin-gonic/gin"
	"github.com/google/wire"
)

// API server
type APIServer struct {
	Handler *gin.Engine
}

var ProviderSetServer = wire.NewSet(
	NewAPIHttpServer,
)
