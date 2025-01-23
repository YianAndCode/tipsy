package errcode

const (
	Other            int = 9999 // 其他错误
	Db               int = 1000 // 数据库错误
	InvalidParam     int = 1001 // 参数错误
	PermissionDenied int = 1002 // 未授权
)
