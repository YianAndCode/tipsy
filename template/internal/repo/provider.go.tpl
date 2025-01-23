package repo

import (
	"{{ .ProjectName }}/internal/repo/user"

	"github.com/google/wire"
)

var ProviderSetRepo = wire.NewSet(
	user.NewUserRepo,
)
