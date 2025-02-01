package user

import (
	"{{ .ProjectName }}/internal/contract/datatype"
	"{{ .ProjectName }}/internal/data"
	"{{ .ProjectName }}/internal/entity"
	"context"

	"xorm.io/xorm"
)

type UserRepo struct {
	//
}

func NewUserRepo() *UserRepo {
	return &UserRepo{}
}


// 通过登录名获取用户
func (r UserRepo) GetByLoginName(ctx context.Context, loginName string) (*entity.User, error) {
	user := &entity.User{LoginName: loginName}
	has, err := data.GetDb(ctx).Get(user)
	if err != nil {
		return nil, err
	}
	if !has {
		return nil, xorm.ErrNotExist
	}
	return user, nil
}

// 插入用户
func (r UserRepo) Insert(ctx context.Context, userId datatype.UserId, loginName, password, nickname string) (*entity.User, error) {
	user := &entity.User{
		UserId:    userId,
		LoginName: loginName,
		Password:  password,
		Nickname:  nickname,
	}

	_, err := data.GetDb(ctx).InsertOne(user)
	if err != nil {
		return nil, err
	}
	return user, nil
}

// 更新密码
func (r UserRepo) UpdatePassword(ctx context.Context, userId datatype.UserId, newPassword string) error {
	user := &entity.User{
		UserId:   userId,
		Password: newPassword,
	}
	_, err := data.GetDb(ctx).ID(userId).MustCols("password").Update(user)
	return err
}

// 更新
func (r UserRepo) Update(ctx context.Context, user *entity.User) error {
	_, err := data.GetDb(ctx).Update(user)
	return err
}
