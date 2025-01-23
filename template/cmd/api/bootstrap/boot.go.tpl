package bootstrap

import (
	"os"
	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/data"

	"gopkg.in/yaml.v3"
)

func Boot(configFilePath string) error {
	cnfData, err := os.ReadFile(configFilePath)
	if err != nil {
		return err
	}

	// Load config
	cnf := config.Get()
	err = yaml.Unmarshal(cnfData, &cnf)
	if err != nil {
		return err
	}

	err = data.InitDb(cnf.Db.Host, cnf.Db.Port, cnf.Db.User, cnf.Db.Pass, cnf.Db.Name)
	if err != nil {
		return err
	}

	return nil
}
