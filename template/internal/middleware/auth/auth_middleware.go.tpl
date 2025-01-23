package auth

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthMiddleware struct {
	//
}

func NewAuthMiddleware() *AuthMiddleware {
	return &AuthMiddleware{}
}

func (a AuthMiddleware) Auth(c *gin.Context) {
	authorization := c.Request.Header.Get("Authorization")
	if len(authorization) {{ "<" | Safe }} 7 {
		c.JSON(http.StatusForbidden, gin.H{
			"code": 403,
			"msg":  "唔好搞嘢",
			"data": nil,
		})
		c.Abort()
		return
	}

	token := authorization[7:]
	if token == "" {
		c.JSON(http.StatusForbidden, gin.H{
			"code": 403,
			"msg":  "唔好搞嘢",
			"data": nil,
		})
		c.Abort()
		return
	}

	// TODO: c.Set(string(constant.CtxKey_UserId), uint64(userId))

	c.Next()
}