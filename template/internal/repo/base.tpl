package {{ .RepoName | ToSnakeCase }}

import (
	"{{ .ProjectName }}/internal/data"
	"xorm.io/xorm"
)

type {{ .RepoName }}Repo struct {
	data.Base
}

func New{{ .RepoName }}Repo(db *xorm.Engine) *{{ .RepoName }}Repo {
	return &{{ .RepoName }}Repo{
		Base: data.NewBase(db),
	}
}
