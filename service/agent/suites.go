package agent

import (
	"errors"
	"fmt"

	"github.com/google/uuid"
	jsoniter "github.com/json-iterator/go"
)

type Suites struct {
	ID int64 `xorm:"id" json:"id"`

	// 覆盖类型
	Cover int `xorm:"cover" json:"cover"`

	// 测试套件名字
	Name string `xorm:"name" json:"name"`

	// 测试套件系统类型 [1:Android | 2:ios]
	Platform int `xorm:"platform" json:"platform"`

	// 是否采集系统性能数据
	IsOpenPerfmon int `xorm:"is_open_perfmon" json:"isOpenPerfmon"`

	// 采集性能数据间隔
	PerfmonInterval int `xorm:"perfmon_interval" json:"perfmonInterval"`

	// 覆盖类型
	ProjectID int `xorm:"project_id" json:"-"`

	// 项目内测试套件默认通知配置，为null时取项目配置的默认值
	AlertRobotIDs []int `xorm:"alert_robot_ids" json:"alertRobotIds"`

	Devices []*SonicDevice `xorm:"-" json:"devices"`

	Cases []*SuitesCase `xorm:"-" json:"testCases"`
}

// test_suites_devices
func ListSuites() (l []*Suites, err error) {
	err = Client.DB.SQL("SELECT * FROM test_suites;").Find(&l)
	return
}

//GetSuites
func GetSuites(name string) (Suites, error) {
	querySQL := fmt.Sprintf("SELECT * FROM test_suites WHERE name = '%+v';",
		name,
	)

	var s Suites
	if _, err := Client.DB.SQL(querySQL).Get(&s); err != nil {
		return s, err
	}

	if s.ID <= 0 {
		return s, fmt.Errorf(`not found test case name="%+v"`, name)
	}

	cases, err := ListSuitesCaseBySuitesID(s.ID)
	if err != nil {
		return s, err
	}

	s.Cases = cases

	return s, nil
}

//RunSuite
func RunSuite(caseId int64) error {
	headers := map[string]string{
		"X-REQUEST-ID": uuid.New().String(),
		"Sonictoken":   HeaderSonictoken,
	}

	apiURL := fmt.Sprintf("/server/api/controller/testSuites/runSuite?id=%d", caseId)

	respBody, err := Client.Get(apiURL, headers)
	if err != nil {
		return err
	}

	var data ApiResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return err
	}

	if data.Code != 2000 {
		return errors.New(data.Message)
	}

	return nil
}

//AddDevices
func (s *Suites) AddDevices(d *SonicDevice) error {
	headers := map[string]string{
		"X-REQUEST-ID": uuid.New().String(),
		"Content-Type": "application/json; charset=UTF-8",
		"Sonictoken":   HeaderSonictoken,
	}

	s.Devices = append(s.Devices, d)

	bodyJSON, err := jsoniter.Marshal(s)
	if err != nil {
		return err
	}

	respBody, err := Client.Put("/server/api/controller/testSuites", headers, bodyJSON)
	if err != nil {
		return err
	}

	var data ApiResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return err
	}

	if data.Code != 2000 {
		return errors.New(data.Message)
	}

	return nil
}
