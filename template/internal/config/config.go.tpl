package config

type Config struct {
	App struct {
		Host     string `yaml:"host"`      // 监听地址
		Port     int    `yaml:"port"`      // 监听端口
		LogFile  string `yaml:"log_file"`  // 日志文件
		LogLevel string `yaml:"log_level"` // 日志级别
	} `yaml:"app"`
	Db struct {
		Host string `yaml:"host"` // 数据库地址
		Port int    `yaml:"port"` // 数据库端口
		User string `yaml:"user"` // 数据库用户名
		Pass string `yaml:"pass"` // 数据库密码
		Name string `yaml:"name"` // 数据库名
	} `yaml:"db"`
}
