module {{ .ProjectName }}

go {{ .GoVersion }}

require (
	github.com/gin-gonic/gin v1.10.0
	github.com/go-sql-driver/mysql v1.8.1
	github.com/google/wire v0.6.0
	github.com/rs/zerolog v1.33.0
	gopkg.in/yaml.v3 v3.0.1
	xorm.io/xorm v1.3.9
	golang.org/x/crypto v0.30.0
)