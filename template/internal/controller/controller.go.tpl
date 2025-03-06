package controller

import (
	"errors"
	"net/http"
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/contract/constant/errcode"
	apperr "{{ .ProjectName }}/internal/contract/error"

	"github.com/gin-gonic/gin"
)

type ControllerFunc func(*gin.Context) (any, error)

func Controller(log contract.Logger, controllerFunc ControllerFunc) func(*gin.Context) {
	return func(ctx *gin.Context) {
		resp, err := controllerFunc(ctx)
		if err != nil {
			var appErr *apperr.AppError
			errCode := 0
			errMsg := ""
			if errors.As(err, &appErr) {
				errCode = appErr.Code
				errMsg = appErr.Msg
			} else {
				errCode = errcode.Other
				errMsg = "Something wrong happened"
			}

			// TODO: 如果 errMsg 为空，则根据 errCode 获取 i18n 文本

			finalResp := Fail(errCode, errMsg)
			extraErr := errors.Unwrap(err)
			log.Errorf("%s, extra err: %v", err.Error(), extraErr)
			ctx.JSON(
				http.StatusOK,
				finalResp,
			)
			return
		}

		ctx.JSON(http.StatusOK, Succ(resp))
	}
}

// 响应结构
type Reponse struct {
	Code int    `json:"code"`
	Msg  string `json:"msg"`
	Data any    `json:"data"`
}

func Succ(data any) *Reponse {
	return &Reponse{
		Code: 0,
		Msg:  "ok",
		Data: data,
	}
}

func Fail(code int, msg string) *Reponse {
	return &Reponse{
		Code: code,
		Msg:  msg,
		Data: nil,
	}
}
