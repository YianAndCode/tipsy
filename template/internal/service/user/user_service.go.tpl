package user

import (
	"context"
	"errors"
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/contract/datatype"
	"{{ .ProjectName }}/internal/entity"
	"{{ .ProjectName }}/internal/repo/user"
	"time"

	"golang.org/x/crypto/bcrypt"
)

type UserService struct {
	repo *user.UserRepo
	log  contract.Logger
}

func NewUserService(repo *user.UserRepo, logger contract.Logger) *UserService {
	return &UserService{
		repo: repo,
		log:  logger,
	}
}

// 注册
func (s UserService) Register(ctx context.Context, loginName, password, nickname string) (*entity.User, error) {
	passwordHash, err := PasswordHash(password)
	if err != nil {
		s.log.Errorf("hash password failed: %s", err.Error())
		return nil, errors.New("something wrong")
	}

	// TODO:
	userId := datatype.UserId(time.Now().Unix())

	user, err := s.repo.Insert(ctx, userId, loginName, passwordHash, nickname)
	if err != nil {
		return nil, err
	}

	return user, nil
}

// 登录
func (s UserService) Login(ctx context.Context, loginName, password string) (*entity.User, error) {
	if loginName == "" {
		return nil, errors.New("invalid username")
	}

	user, err := s.repo.GetByLoginName(ctx, loginName)
	if err != nil {
		return nil, err
	}

	if !PasswordVerify(password, user.Password) {
		return nil, errors.New("username or password not macth")
	}

	return user, nil
}

// 加密密码
func PasswordHash(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

// 密码校验
func PasswordVerify(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
