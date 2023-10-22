package agent

import (
	"fmt"
)

//SuitesCase 测试用例
type SuitesCase struct {
	ID       int64  `xorm:"id" json:"id"`
	Name     string `xorm:"name" json:"name"`
	Platform int    `xorm:"platform" json:"platform"`

	// 所属项目ID
	ProjectId int `xorm:"project_id" json:"projectId"`

	// 所属模块
	ModuleId int `xorm:"module_id" json:"moduleId"`

	// 版本号
	Version string `xorm:"version" json:"version"`

	// 用例描述
	Des string `xorm:"des" json:"des"`

	// 用例设计人
	Designer string `xorm:"designer" json:"designer"`
}

//ListSuitesCase
func ListSuitesCase() (l []*SuitesCase, err error) {
	err = Client.DB.SQL("SELECT * FROM test_cases;").Find(&l)
	return
}

//ListSuitesCaseBySuitesID
func ListSuitesCaseBySuitesID(suitesID int64) (l []*SuitesCase, err error) {
	querySQL := fmt.Sprintf("SELECT c.* FROM test_cases c LEFT JOIN test_suites_test_cases tc ON c.id = tc.test_cases_id WHERE tc.test_suites_id = %d;",
		suitesID,
	)
	err = Client.DB.SQL(querySQL).Find(&l)
	return
}
