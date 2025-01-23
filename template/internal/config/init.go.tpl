package config

var cnf *Config

func init() {
	cnf = &Config{}
}

func Get() *Config {
	return cnf
}
