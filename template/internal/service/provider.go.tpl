package service

import (
	"{{ .ProjectName }}/internal/service/user"

	"github.com/google/wire"
)

var ProviderSetService = wire.NewSet(
	user.NewUserService,
)
