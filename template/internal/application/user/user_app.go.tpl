package user

import (
	"context"
	"{{ .ProjectName }}/internal/controller/dto"
	"{{ .ProjectName }}/internal/data"
	userSvc "{{ .ProjectName }}/internal/service/user"

	"xorm.io/xorm"
)

type UserApp struct {
	service *userSvc.UserService
	engine  *xorm.Engine
}

func NewUserApp(service *userSvc.UserService, engine *xorm.Engine) *UserApp {
	return &UserApp{
		service: service,
		engine:  engine,
	}
}

func (app *UserApp) Login(ctx context.Context, in *dto.UserLoginRequest) (*dto.UserLoginResponse, error) {
	user, err := app.service.Login(ctx, in.Username, in.Password)
	if err != nil {
		return nil, err
	}

	return &dto.UserLoginResponse{
		Nickname: user.Nickname,
	}, nil
}

func (app *UserApp) Register(ctx context.Context, in *dto.UserRegisterRequest) (*dto.UserRegisterResponse, error) {
	var res *dto.UserRegisterResponse
	err := data.DoTransaction(ctx, app.engine, func(txCtx context.Context) error {
		user, err := app.service.Register(txCtx, in.Username, in.Password, in.Nickname)
		if err != nil {
			return err
		}
		res = &dto.UserRegisterResponse{
			Nickname: user.Nickname,
		}
		return nil
	})

	if err != nil {
		return nil, err
	}

	return res, nil
}
