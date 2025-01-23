package server

import (
	"{{ .ProjectName }}/internal/middleware/auth"
	"{{ .ProjectName }}/internal/router"

	"github.com/gin-gonic/gin"
)

// Public API server
func NewAPIHttpServer(
	apiRouter *router.APIRouter,
	authMiddleware *auth.AuthMiddleware,
) *APIServer {
	r := gin.New()
	r.Use(gin.Recovery())
	r.GET("/healthz", func(ctx *gin.Context) { ctx.String(200, "OK") })

	apiRouter.RegisterUnauthorizedAPIRouter(r)
	apiRouter.RegisterAuthorizedAPIRouter(r, authMiddleware)

	return &APIServer{
		Handler: r,
	}
}
