package entity

import "time"

type {{ .Name }} struct {
	ID        uint      `xorm:"'id' pk autoincr"`
	CreatedAt time.Time `xorm:"'created_at' created"`
	UpdatedAt time.Time `xorm:"'updated_at' updated"`
}

func ({{ .Name }}) TableName() string {
	return "{{ .Name | ToSnakeCase }}"
}