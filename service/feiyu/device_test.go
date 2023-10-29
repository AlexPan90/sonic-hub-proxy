package feiyu

import (
	"fmt"
	"os"
	"testing"

	"sonic-hub-proxy/config"

	_ "github.com/go-kit/log"
	"github.com/go-kit/log/level"
	"github.com/google/uuid"
	"github.com/prometheus/common/promlog"
)

func init() {
	configFile := "../../proxy.yml"

	promlogConfig := &promlog.Config{}

	logger := promlog.New(promlogConfig)

	proxyConf := config.NewConfig()
	if err := proxyConf.LoadFile(configFile); err != nil {
		level.Error(logger).Log("msg", "Load config error", "err", err)
		os.Exit(1)
	} else {
		level.Info(logger).Log("msg", "Load config ok")
	}

	NewClientWithConfig(proxyConf, logger)
}

//TestHeartbeat
//CMD: go test -run TestHeartbeat -v
func TestHeartbeat(t *testing.T) {
	uuid := "31eb908f-6466-4904-abfa-081417caf12d"
	device, err := GetPhoneDevice(uuid)
	if err != nil {
		fmt.Println(err)
		return
	}

	if err := device.Heartbeat(); err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(device)
}

//TestListPhoneDevice
//CMD: go test -run TestListPhoneDevice -v
func TestListPhoneDevice(t *testing.T) {
	devices, err := ListPhoneDevice()
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(devices)
	return
}

//TestGetPhoneDevice
//CMD: go test -run TestGetPhoneDevice -v
func TestGetPhoneDevice(t *testing.T) {
	uuid := "177b3c01-8819-4ad8-afdd-3017b18db9a3"
	device, err := GetPhoneDevice(uuid)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(device)
}

//TestReported
//CMD: go test -run TestReported -v
func TestReported(t *testing.T) {
	d := &PhoneDevice{
		Name:        "手机J05",
		UUID:        "24d23063-50da-4fa2-bd37-b15c964326f5",
		PhoneGroup:  1,
		Brand:       "小米",
		OS:          "Android",
		PhoneNumber: "13520923333",
		PhoneModel:  "小米5",
		OsVersion:   "v1.0",
		AppVersion:  "v1.0",
	}

	uuid, err := d.Reported()
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(uuid)
}

//TestGetTask
//CMD: go test -run TestGetTask -v
func TestGetTask(t *testing.T) {
	requestID := uuid.New().String()

	tasks, err := GetTask(requestID, 3, true)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(tasks)
	return
}

//TestGetTask
//CMD: go test -run TestModifyTask -v
func TestModifyTask(t *testing.T) {
	requestID := uuid.New().String()

	task, err := GetTask(requestID, 4, true)
	if err != nil {
		fmt.Println(err)
		return
	}

	task.TaskStatus = TaskStatus_Cancel

	if err := task.Modify(); err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(task)
	return
}

//TestListTask
//CMD: go test -run TestListTask -v
func TestListTask(t *testing.T) {
	d := &PhoneDevice{
		UUID: "dfde440f-fd91-4449-9708-336ae8479646",
	}

	tasks, err := ListTask(d.UUID)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(tasks)
	return
}

//TestListTaskData
//CMD: go test -run TestListTaskData -v
func TestListTaskData(t *testing.T) {
	requestID := uuid.New().String()

	taskUUID := "dfde440f-fd91-4449-9708-336ae8479646"

	taskData, err := ListTaskData(requestID, taskUUID)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(taskData)
	return
}

//TestGetTaskTemplate
//CMD: go test -run TestGetTaskTemplate -v
func TestGetTaskTemplate(t *testing.T) {
	requestID := uuid.New().String()

	template, err := GetTaskTemplate(requestID, 1)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(template)
	return
}

//TestListPhoneGroup
//CMD: go test -run TestListPhoneGroup -v
func TestListPhoneGroup(t *testing.T) {
	l, err := ListPhoneGroup()
	if err != nil {
		fmt.Println(err)
		return
	}

	for _, v := range l {
		fmt.Println(*v)
	}
}

//TestCreatePhoneGroup
//CMD: go test -run TestCreatePhoneGroup -v
func TestCreatePhoneGroup(t *testing.T) {
	if err := CreatePhoneGroup(); err != nil {
		fmt.Println(err)
		return
	}
}

//TestGetPhoneGroup
//CMD: go test -run TestGetPhoneGroup -v
func TestGetPhoneGroup(t *testing.T) {
	g, err := GetPhoneGroup("48f532f5-3bb8-4349-a0c4-7cc7bd821781")
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(g)
}
