package server

import (
	"{{ .ProjectName }}/internal/middleware/auth"
	"{{ .ProjectName }}/internal/middleware/log"
	"{{ .ProjectName }}/internal/router"

	"github.com/gin-contrib/requestid"
	"github.com/gin-gonic/gin"
)

// API server
type APIServer struct {
	Handler *gin.Engine
}

// Public API server
func NewAPIHttpServer(
	apiRouter *router.APIRouter,
	authMiddleware *auth.AuthMiddleware,
	logMiddleware *log.LogMiddleware,
) *APIServer {
	r := gin.New()
	r.Use(requestid.New())
	r.Use(logMiddleware.Log)
	r.Use(gin.Recovery())
	r.GET("/healthz", func(ctx *gin.Context) { ctx.String(200, "OK") })

	apiRouter.RegisterUnauthorizedAPIRouter(r)
	apiRouter.RegisterAuthorizedAPIRouter(r, authMiddleware)

	return &APIServer{
		Handler: r,
	}
}
