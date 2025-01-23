package log

import (
	"{{ .ProjectName }}/internal/contract"

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

func NewLogger(logFile string, level string) contract.Logger {
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
	fm := NewFileManager(logFile)
	logger := zerolog.New(fm).With().Timestamp().Logger()

	return &Logger{
		logger: &logger,
		fm:     fm,
		level:  convertLevel(level),
	}
}

func (l *Logger) Debug(msg string) {
	if l.level > DebugLevel {
		return
	}
	l.logger.Debug().Msg(msg)
}

func (l *Logger) Debugf(msg string, args ...interface{}) {
	if l.level > DebugLevel {
		return
	}
	l.logger.Debug().Msgf(msg, args...)
}

func (l *Logger) Info(msg string) {
	if l.level > InfoLevel {
		return
	}
	l.logger.Info().Msg(msg)
}

func (l *Logger) Infof(msg string, args ...interface{}) {
	if l.level > InfoLevel {
		return
	}
	l.logger.Info().Msgf(msg, args...)
}

func (l *Logger) Warn(msg string) {
	if l.level > WarnLevel {
		return
	}
	l.logger.Warn().Msg(msg)
}

func (l *Logger) Warnf(msg string, args ...interface{}) {
	if l.level > WarnLevel {
		return
	}
	l.logger.Warn().Msgf(msg, args...)
}

func (l *Logger) Error(msg string) {
	if l.level > ErrorLevel {
		return
	}
	l.logger.Error().Msg(msg)
}

func (l *Logger) Errorf(msg string, args ...interface{}) {
	if l.level > ErrorLevel {
		return
	}
	l.logger.Error().Msgf(msg, args...)
}

func (l *Logger) Close() error {
	return l.fm.Close()
}
