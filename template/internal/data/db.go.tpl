package data

import (
	"context"
	"fmt"

	"{{ .ProjectName }}/internal/contract/constant"

	_ "github.com/go-sql-driver/mysql"
	"xorm.io/xorm"
)

var db *xorm.Engine

func InitDb(host string, port int, user, pass, name string) error {
	var err error
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local", user, pass, host, port, name)
	db, err = xorm.NewEngine("mysql", dsn)
	return err
}

func GetDb(ctx context.Context) *xorm.Engine {
	tx, ok := ctx.Value(constant.CtxKey_DbTx).(*xorm.Engine)
	if ok {
		return tx
	}
	return db
}

func DoTransaction(ctx context.Context, fn func(ctx context.Context) error) error {
	session := db.Context(ctx)
	defer session.Close()

	if err := session.Begin(); err != nil {
		return err
	}

	c := context.WithValue(ctx, constant.CtxKey_DbTx, session.Engine())
	err := fn(c)
	if err != nil {
		session.Rollback()
		return err
	}

	return session.Commit()
}
