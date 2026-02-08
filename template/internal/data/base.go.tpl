package data

import (
	"context"
	"{{ .ProjectName }}/internal/contract/constant"

	"xorm.io/xorm"
)

// Base provides shared database access capabilities for all repositories.
type Base struct {
	db *xorm.Engine
}

// NewBase creates a new Base instance.
func NewBase(db *xorm.Engine) Base {
	return Base{db: db}
}

// CtxDB retrieves the database connection from the context.
// It intelligently determines if a transaction is in progress, returning the transaction session if it is,
// otherwise returning the default engine.
func (b *Base) CtxDB(ctx context.Context) xorm.Interface {
	if session, ok := ctx.Value(constant.TxKey).(*xorm.Session); ok {
		return session
	}
	return b.db
}
