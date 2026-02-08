package {{ .ApplicationName | ToSnakeCase }}

import (
	"context"
	"{{ .ProjectName }}/internal/controller/dto"
	"{{ .ProjectName }}/internal/data"

	"xorm.io/xorm"
)

type {{ .ApplicationName }}App struct {
	engine *xorm.Engine
}

func New{{ .ApplicationName }}App(engine *xorm.Engine) *{{ .ApplicationName }}App {
	return &{{ .ApplicationName }}App{
		engine: engine,
	}
}

func (app *{{ .ApplicationName }}App) SomeMethod(ctx context.Context, in *dto.SomeMethodReqeust) (*dto.SomeMethodResponse, error) {
	var res *dto.SomeMethodResponse
	err := data.DoTransaction(ctx, app.engine, func(txCtx context.Context) error {
		// TODO

		res = &dto.SomeMethodResponse{}
		return nil
	})

	if err != nil {
		return nil, err
	}

	return res, nil
}
