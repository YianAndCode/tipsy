package middleware

import (
	"{{ .ProjectName }}/internal/middleware/auth"

	"github.com/google/wire"
)

var ProviderSetMiddleware = wire.NewSet(
	auth.NewAuthMiddleware,
)
