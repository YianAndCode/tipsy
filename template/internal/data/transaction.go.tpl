package data

import (
	"context"
	"{{ .ProjectName }}/internal/contract/constant"

	"xorm.io/xorm"
)

// DBFromCtx retrieves the transaction session from the context if it exists,
// otherwise it returns the default engine.
func DBFromCtx(ctx context.Context, defaultEngine *xorm.Engine) xorm.Interface {
	if session, ok := ctx.Value(constant.TxKey).(*xorm.Session); ok {
		return session
	}
	return defaultEngine
}

// DoTransaction executes the given function within a database transaction.
// It injects the transaction session into the context, which can be retrieved by DBFromCtx.
func DoTransaction(ctx context.Context, engine *xorm.Engine, fn func(ctx context.Context) error) error {
	session := engine.NewSession()
	defer session.Close()

	if err := session.Begin(); err != nil {
		return err
	}

	txCtx := context.WithValue(ctx, constant.TxKey, session)

	if err := fn(txCtx); err != nil {
		if rbErr := session.Rollback(); rbErr != nil {
			// It's often useful to log the rollback error
			return rbErr
		}
		return err
	}

	return session.Commit()
}
