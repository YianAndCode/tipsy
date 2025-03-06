package error

import "{{ .ProjectName }}/internal/contract/constant/errcode"

var _ error = &AppError{}

type AppError struct {
	Code int

	Msg string // 下发给用户的错误信息

	ErrMsg string // 具体错误信息，打印日志用的
	Err    error  // 嵌套 error
}

func (a AppError) Error() string {
	return a.ErrMsg
}

func (a AppError) Unwrap() error {
	return a.Err
}

type AppErrorOption func(e *AppError)

// 下发给用户的错误信息
func WithMsg(msg string) AppErrorOption {
	return func(e *AppError) {
		e.Msg = msg
	}
}

// 打日志的错误信息
func WithErrMsg(msg string) AppErrorOption {
	return func(e *AppError) {
		e.ErrMsg = msg
	}
}

// 额外错误
func WithError(err error) AppErrorOption {
	return func(e *AppError) {
		e.Err = err
	}
}

func New(code int, opts ...AppErrorOption) *AppError {
	err := &AppError{
		Code: code,
	}

	for _, opt := range opts {
		opt(err)
	}

	return err
}

func Db(dbErr error, errMsg string) *AppError {
	return New(
		errcode.Db,
		WithErrMsg(errMsg),
		WithError(dbErr),
	)
}
