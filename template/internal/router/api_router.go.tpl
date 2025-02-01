package router

import (
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/controller"
	"{{ .ProjectName }}/internal/controller/user"
	"{{ .ProjectName }}/internal/middleware/auth"

	"github.com/gin-gonic/gin"
)

type APIRouter struct {
	log            contract.Logger
	userController *user.UserController
}

func NewAPIRouter(
	log contract.Logger,
	userController *user.UserController,
) *APIRouter {
	return &APIRouter{
		log:            log,
		userController: userController,
	}
}

func (a *APIRouter) RegisterUnauthorizedAPIRouter(r *gin.Engine) {
	user := r.Group("/user")
	{
		// 登录
		user.POST("/login", controller.Controller(a.log, a.userController.Login))
		// 注册
		user.POST("/register", controller.Controller(a.log, a.userController.Register))
	}
}

// 注册需要登录的路由
func (a *APIRouter) RegisterAuthorizedAPIRouter(r *gin.Engine, authMiddleware *auth.AuthMiddleware) {
	authorized := r.Group("")
	authorized.Use(authMiddleware.Auth)
	// TODO
}
