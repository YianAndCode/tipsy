package controller

import (
	"{{ .ProjectName }}/internal/controller/user"

	"github.com/google/wire"
)

var ProviderSetController = wire.NewSet(
	user.NewUserController,
)
