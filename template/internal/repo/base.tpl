package {{ .RepoName | ToLowerCase }}

type {{ .RepoName }}Repo struct {
}

func New{{ .RepoName }}Repo() *{{ .RepoName }}Repo {
	return &{{ .RepoName }}Repo{}
}
