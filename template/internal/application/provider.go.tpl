package application

import (
	"{{ .ProjectName }}/internal/application/user"

	"github.com/google/wire"
)

var ProviderSet = wire.NewSet(
	user.NewUserApp,
)
