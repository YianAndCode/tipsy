package log

import (
	"{{ .ProjectName }}/internal/contract"

	"github.com/google/wire"
)

var ProviderSetLog = wire.NewSet(NewLogger, wire.Bind(new(contract.Logger), new(*Logger)))
