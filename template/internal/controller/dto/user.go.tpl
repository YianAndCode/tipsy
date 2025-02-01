package dto

// 登录
type UserLoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type UserLoginResponse struct {
	Nickname string `json:"nickname"`
	Token    string `json:"token"`
}

// 注册
type UserRegisterRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
	Nickname string `json:"nickname" binding:"required"`
}

type UserRegisterResponse struct {
	Nickname string `json:"nickname"`
	Token    string `json:"token"`
}
