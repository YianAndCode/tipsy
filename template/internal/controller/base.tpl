package {{ .ControllerName | ToSnakeCase }}

import (
	"{{ .ProjectName }}/internal/contract/constant/errcode"
	apperr "{{ .ProjectName }}/internal/contract/error"
	"{{ .ProjectName }}/internal/controller/dto"

	"github.com/gin-gonic/gin"
)

type {{ .ControllerName }}Controller struct {
}

func New{{ .ControllerName }}Controller() *{{ .ControllerName }}Controller {
	return &{{ .ControllerName }}Controller{}
}

// SomeMethod
func (c {{ .ControllerName }}Controller) SomeMethod(ctx *gin.Context) (any, error) {
	return c.someMethod(ctx)
}

func (c {{ .ControllerName }}Controller) someMethod(ctx *gin.Context) (*dto.SomeMethodResponse, error) {
	var req dto.SomeMethodReqeust
	if err := ctx.ShouldBindJSON(&req); err != nil {
		return nil, apperr.New(errcode.InvalidParam)
	}

	// TODO

	return &dto.SomeMethodResponse{}, nil
}
