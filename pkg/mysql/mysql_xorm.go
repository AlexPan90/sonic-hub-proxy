package mysql

import (
	"fmt"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
)

const (
	defaultDriverName = "mysql"
	defaultMasterFlag = "master"
)

//XormConns
type XormConns map[string]*xorm.Engine

//NewXormConns
func NewXormConns(conf MultipleMysqlConf) (XormConns, error) {
	conns := make(XormConns)

	for k, v := range conf {
		conn, err := xorm.NewEngine(defaultDriverName, v.Dsn)
		if err != nil {
			return conns, fmt.Errorf(`component="MySQL(%+v)" msg="Connection failed." err="%+v"`,
				k,
				err,
			)
		}
		conn.SetMaxIdleConns(v.MaxIdleConns)
		conn.SetMaxOpenConns(v.MaxOpenConns)
		conn.SetConnMaxLifetime(time.Duration(v.ConnMaxLifetime))
		conn.ShowSQL(v.Debug)

		conns[k] = conn
	}
	return conns, nil
}

//XormGroupConns
type XormGroupConns map[string]*xorm.EngineGroup

//NewXormGroupConns
func NewXormGroupConns(conf map[string]MultipleMysqlConf) (XormGroupConns, error) {

	groupConns := make(XormGroupConns)

	for k, v := range conf {
		conns, err := NewXormConns(v)
		if err != nil {
			return groupConns, err
		}

		var master *xorm.Engine
		slaves := make([]*xorm.Engine, 0, len(conns))
		for kk, vv := range conns {
			if strings.ToLower(kk) == defaultMasterFlag {
				master = vv
			} else {
				slaves = append(slaves, vv)
			}
		}

		eg, err := xorm.NewEngineGroup(master, slaves)
		groupConns[k] = eg
	}

	return groupConns, nil

}
