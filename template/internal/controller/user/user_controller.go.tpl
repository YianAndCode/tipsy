package user

import (
	"{{ .ProjectName }}/internal/contract/constant/errcode"
	apperr "{{ .ProjectName }}/internal/contract/error"
	"{{ .ProjectName }}/internal/controller/dto"
	"{{ .ProjectName }}/internal/service/user"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	service *user.UserService
}

func NewUserController(
	service *user.UserService,
) *UserController {
	return &UserController{
		service: service,
	}
}

// 登录
func (c UserController) Login(ctx *gin.Context) (any, error) {
	return c.login(ctx)
}

func (c UserController) login(ctx *gin.Context) (*dto.LoginResponse, error) {
	var req dto.LoginReqeust
	if err := ctx.ShouldBindJSON(&req); err != nil {
		return nil, apperr.New(errcode.InvalidParam)
	}

	user, err := c.service.Login(ctx, req.Username, req.Password)
	if err != nil {
		return nil, err
	}

	return &dto.LoginResponse{
		Nickname: user.Nickname,
	}, nil
}

// 注册
func (c UserController) Register(ctx *gin.Context) (any, error) {
	return c.register(ctx)
}

func (c UserController) register(ctx *gin.Context) (*dto.RegisterResponse, error) {
	var req dto.RegisterRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		return nil, apperr.New(errcode.InvalidParam)
	}

	user, err := c.service.Register(ctx, req.Username, req.Password, req.Nickname)
	if err != nil {
		return nil, err
	}

	return &dto.RegisterResponse{
		Nickname: user.Nickname,
	}, nil
}
