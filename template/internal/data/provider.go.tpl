package data

import "github.com/google/wire"

var ProviderSetData = wire.NewSet(NewEngine)
