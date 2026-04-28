package user

import (
	"context"
	"errors"
	"time"

	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/contract/datatype"
	"{{ .ProjectName }}/internal/entity"
	"{{ .ProjectName }}/internal/repo/user"

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
func (s *UserService) Register(ctx context.Context, in *RegisterInput) (*entity.User, error) {
	passwordHash, err := PasswordHash(in.Password)
	if err != nil {
		s.log.Errorf(ctx, "hash password failed: %s", err.Error())
		return nil, errors.New("something wrong")
	}

	// TODO:
	userId := datatype.UserId(time.Now().Unix())

	user, err := s.repo.Insert(ctx, userId, in.LoginName, passwordHash, in.Nickname)
	if err != nil {
		return nil, err
	}

	return user, nil
}

// 登录
func (s *UserService) Login(ctx context.Context, in *LoginInput) (*entity.User, error) {
	if in.LoginName == "" {
		return nil, errors.New("invalid username")
	}

	user, err := s.repo.GetByLoginName(ctx, in.LoginName)
	if err != nil {
		return nil, err
	}

	if !PasswordVerify(in.Password, user.Password) {
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
