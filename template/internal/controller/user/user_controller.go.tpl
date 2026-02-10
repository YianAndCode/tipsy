package user

import (
	"{{ .ProjectName }}/internal/application/user"
	"{{ .ProjectName }}/internal/contract/constant/errcode"
	apperr "{{ .ProjectName }}/internal/contract/error"
	"{{ .ProjectName }}/internal/controller/dto"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	app *user.UserApp
}

func NewUserController(
	app *user.UserApp,
) *UserController {
	return &UserController{
		app: app,
	}
}

// 登录
func (c *UserController) Login(ctx *gin.Context) (any, error) {
	return c.login(ctx)
}

func (c *UserController) login(ctx *gin.Context) (*dto.UserLoginResponse, error) {
	var req dto.UserLoginRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		return nil, apperr.New(errcode.InvalidParam)
	}

	return c.app.Login(ctx, &req)
}

// 注册
func (c *UserController) Register(ctx *gin.Context) (any, error) {
	return c.register(ctx)
}

func (c *UserController) register(ctx *gin.Context) (*dto.UserRegisterResponse, error) {
	var req dto.UserRegisterRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		return nil, apperr.New(errcode.InvalidParam)
	}

	return c.app.Register(ctx, &req)
}
