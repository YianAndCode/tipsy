package {{ .MiddlewareName | ToSnakeCase }}

import "github.com/gin-gonic/gin"

type {{ .MiddlewareName }}Middleware struct {
	//
}

func New{{ .MiddlewareName }}Middleware() *{{ .MiddlewareName }}Middleware {
	return &{{ .MiddlewareName }}Middleware{}
}

func (m {{ .MiddlewareName }}Middleware) {{ .MiddlewareName }}(c *gin.Context) {
	// TODO

	c.Next()
}