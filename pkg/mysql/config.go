package mysql

//MySQLConf
type MySQLConf struct {
	Dsn             string `yaml:"dsn"`
	CallTimeout     int    `yaml:"call_timeout"`
	MaxIdleConns    int    `yaml:"max_idle_conns"`
	MaxOpenConns    int    `yaml:"max_open_conns"`
	ConnMaxLifetime int    `yaml:"conn_max_lifetime"`
	Debug           bool   `yaml:"debug"`
}

//MultipleMysqlConf
type MultipleMysqlConf map[string]MySQLConf
