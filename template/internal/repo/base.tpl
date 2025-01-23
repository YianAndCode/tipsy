package {{ .RepoName | ToLowerCase }}

type {{ .RepoName }}Repo struct {
}

func New{{ .RepoName }}Repo {
	return &{{ .RepoName }}Repo{}
}
