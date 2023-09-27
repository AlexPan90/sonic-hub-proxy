package agent

import (
	"fmt"
)

type SuitesDevices struct {
	SuitesID  int64 `xorm:"suites_id" json:"suitesId"`
	DevicesID int64 `xorm:"devices_id" json:"devicesId"`
}

//ListSuitesDevicesID
func ListSuitesDevicesID(suitesID int64) (l []int64, err error) {
	querySQL := fmt.Sprintf("SELECT devices_id FROM test_suites_devices WHERE test_suites_id = %d;",
		suitesID,
	)
	err = Client.DB.SQL(querySQL).Find(&l)
	return
}

//CheckSuitesDevices
func CheckSuitesDevices(suitesID, devicesID int64) bool {
	querySQL := fmt.Sprintf("SELECT COUNT(1) FROM test_suites_devices WHERE test_suites_id = %d AND devices_id = %d;",
		suitesID,
		devicesID,
	)

	var isExisted int
	if _, err := Client.DB.SQL(querySQL).Get(&isExisted); err != nil {
		return false
	}

	if isExisted <= 0 {
		return false
	}

	return true
}
