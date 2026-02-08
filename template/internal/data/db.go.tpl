package data

import (
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"{{ .ProjectName }}/internal/config"
	"xorm.io/xorm"
)

// NewEngine creates a new xorm.Engine and returns it along with a cleanup function.
// It is a wire provider.
func NewEngine(c *config.Config) (*xorm.Engine, func(), error) {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		c.Db.User,
		c.Db.Pass,
		c.Db.Host,
		c.Db.Port,
		c.Db.Name,
	)

	engine, err := xorm.NewEngine("mysql", dsn)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create engine: %w", err)
	}

	if err := engine.Ping(); err != nil {
		return nil, nil, fmt.Errorf("failed to ping database: %w", err)
	}

	cleanup := func() {
		engine.Close()
	}

	return engine, cleanup, nil
}
