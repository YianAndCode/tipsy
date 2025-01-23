package entity

import (
	"{{ .ProjectName }}/internal/contract/datatype"
	"time"
)

type User struct {
	UserId    datatype.UserId `xorm:"bigint unsigned not null pk"`                  // UserId
	LoginName string          `xorm:"varchar(32) not null unique(unq-login_name)"`  // 登录名
	Password  string          `xorm:"varchar(255) not null"`                        // 密码
	Nickname  string          `xorm:"varchar(16) not null"`                         // 昵称
	Gender    datatype.Gender `xrom:"tinyint not null default(0)"`                  // 性别
	Email     string          `xorm:"varchar(200) null"`                            // 邮箱
	AvatarUrl string          `xorm:"varchar(256) null"`                            // 头像
	Tz        string          `xorm:"varchar(64) not null default 'Asia/Shanghai'"` // 时区
	CreatedAt time.Time       `xorm:"created timestamp not null default CURRENT_TIMESTAMP"`
	UpdatedAt time.Time       `xorm:"updated timestamp not null default CURRENT_TIMESTAMP"`
	DeletedAt time.Time       `xorm:"deleted timestamp null"`
}

func (User) TableName() string {
	return "users"
}
