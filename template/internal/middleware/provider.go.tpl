package middleware

import (
	"{{ .ProjectName }}/internal/middleware/auth"
	"{{ .ProjectName }}/internal/middleware/log"

	"github.com/google/wire"
)

var ProviderSetMiddleware = wire.NewSet(
	auth.NewAuthMiddleware,
	log.NewLogMiddleware,
)
