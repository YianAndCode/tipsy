package contract

type Logger interface {
	Debug(msg string)
	Debugf(msg string, args ...interface{})

	Info(msg string)
	Infof(msg string, args ...interface{})

	Warn(msg string)
	Warnf(msg string, args ...interface{})

	Error(msg string)
	Errorf(msg string, args ...interface{})

	Close() error
}
