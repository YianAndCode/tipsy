package contract

import "context"

type Logger interface {
	Debug(ctx context.Context, msg string)
	Debugf(ctx context.Context, msg string, args ...interface{})

	Info(ctx context.Context, msg string)
	Infof(ctx context.Context, msg string, args ...interface{})

	Warn(ctx context.Context, msg string)
	Warnf(ctx context.Context, msg string, args ...interface{})

	Error(ctx context.Context, msg string)
	Errorf(ctx context.Context, msg string, args ...interface{})

	Close() error
}
