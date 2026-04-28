module {{ .ProjectName }}

go {{ .GoVersion }}

require (
	github.com/gin-contrib/requestid v1.0.5
	github.com/gin-gonic/gin v1.12.0
	github.com/go-sql-driver/mysql v1.9.3
	github.com/google/wire v0.7.0
	github.com/rs/zerolog v1.34.0
	gopkg.in/yaml.v3 v3.0.1
	xorm.io/xorm v1.3.11
	golang.org/x/crypto v0.49.0
)