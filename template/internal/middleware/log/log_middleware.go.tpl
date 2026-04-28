package log

import (
	"{{ .ProjectName }}/internal/contract/constant"

	"github.com/gin-contrib/requestid"
	"github.com/gin-gonic/gin"
)

type LogMiddleware struct{}

func NewLogMiddleware() *LogMiddleware {
	return &LogMiddleware{}
}

func (m *LogMiddleware) Log(c *gin.Context) {
	c.Set(constant.CtxKeyRequestID, requestid.Get(c))
	c.Set(constant.CtxKeyURI, c.Request.RequestURI)
	c.Next()
}
