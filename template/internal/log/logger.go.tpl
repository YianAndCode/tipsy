package log

import (
	"context"

	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/contract/constant"

	"github.com/rs/zerolog"
)

type Level uint8

const (
	DebugLevel Level = iota
	InfoLevel
	WarnLevel
	ErrorLevel
)

type Logger struct {
	logger *zerolog.Logger
	fm     *FileManager
	level  Level
}

func NewLogger(cnf *config.Config) *Logger {
	convertLevel := func(level string) Level {
		var lv Level = InfoLevel
		switch level {
		case "debug":
			lv = DebugLevel
		case "info":
			lv = InfoLevel
		case "warn":
			lv = WarnLevel
		case "error":
			lv = ErrorLevel
		}
		return lv
	}
	fm := NewFileManager(cnf.App.LogFile)
	logger := zerolog.New(fm).With().Timestamp().Logger()

	return &Logger{
		logger: &logger,
		fm:     fm,
		level:  convertLevel(cnf.App.LogLevel),
	}
}

func (l *Logger) addCtxFields(ctx context.Context, e *zerolog.Event) *zerolog.Event {
	if ctx == nil {
		return e
	}
	if reqID, ok := ctx.Value(constant.CtxKeyRequestID).(string); ok {
		e.Str("request_id", reqID)
	}
	if uri, ok := ctx.Value(constant.CtxKeyURI).(string); ok {
		e.Str("uri", uri)
	}
	return e
}

func (l *Logger) Debug(ctx context.Context, msg string) {
	if l.level > DebugLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Debug()).Msg(msg)
}

func (l *Logger) Debugf(ctx context.Context, msg string, args ...interface{}) {
	if l.level > DebugLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Debug()).Msgf(msg, args...)
}

func (l *Logger) Info(ctx context.Context, msg string) {
	if l.level > InfoLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Info()).Msg(msg)
}

func (l *Logger) Infof(ctx context.Context, msg string, args ...interface{}) {
	if l.level > InfoLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Info()).Msgf(msg, args...)
}

func (l *Logger) Warn(ctx context.Context, msg string) {
	if l.level > WarnLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Warn()).Msg(msg)
}

func (l *Logger) Warnf(ctx context.Context, msg string, args ...interface{}) {
	if l.level > WarnLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Warn()).Msgf(msg, args...)
}

func (l *Logger) Error(ctx context.Context, msg string) {
	if l.level > ErrorLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Error()).Msg(msg)
}

func (l *Logger) Errorf(ctx context.Context, msg string, args ...interface{}) {
	if l.level > ErrorLevel {
		return
	}
	l.addCtxFields(ctx, l.logger.Error()).Msgf(msg, args...)
}

func (l *Logger) Close() error {
	return l.fm.Close()
}
