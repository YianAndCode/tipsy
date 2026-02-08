package {{ .RepoName | ToSnakeCase }}

import "{{ .ProjectName }}/internal/data"

type {{ .RepoName }}Repo struct {
	data.Base
}

func New{{ .RepoName }}Repo() *{{ .RepoName }}Repo {
	return &{{ .RepoName }}Repo{}
}
