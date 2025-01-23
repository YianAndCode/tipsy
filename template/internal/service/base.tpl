package {{ .ServiceName | ToLowerCase }}

import (
	"context"
	"errors"
	"{{ .ProjectName }}/internal/contract"
	"{{ .ProjectName }}/internal/contract/datatype"
	"{{ .ProjectName }}/internal/entity"
	"{{ .ProjectName }}/internal/repo/user"
	"time"

	"golang.org/x/crypto/bcrypt"
)

type {{ .ServiceName }}Service struct {
}

func New{{ .ServiceName }}Service() *{{ .ServiceName }}Service {
	return &{{ .ServiceName }}Service{}
}
