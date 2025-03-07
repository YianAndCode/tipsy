package {{ .ServiceName | ToSnakeCase }}

type {{ .ServiceName }}Service struct {
}

func New{{ .ServiceName }}Service() *{{ .ServiceName }}Service {
	return &{{ .ServiceName }}Service{}
}
