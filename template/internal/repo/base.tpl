package {{ .RepoName | ToSnakeCase }}

type {{ .RepoName }}Repo struct {
}

func New{{ .RepoName }}Repo() *{{ .RepoName }}Repo {
	return &{{ .RepoName }}Repo{}
}
