package feiyu

import (
	"fmt"
	"os"
	"testing"
	"time"

	"sonic-hub-proxy/config"

	"github.com/alecthomas/kingpin/v2"
	_ "github.com/go-kit/log"
	"github.com/go-kit/log/level"
	"github.com/google/uuid"
	"github.com/prometheus/common/promlog"
	"github.com/prometheus/common/promlog/flag"
)

func init() {
	s := time.Now().Unix()
	fmt.Println(s)

	promlogConfig := &promlog.Config{}

	flag.AddFlags(kingpin.CommandLine, promlogConfig)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	logger := promlog.New(promlogConfig)

	proxyConf := config.NewConfig()
	if err := proxyConf.LoadFile(*configFile); err != nil {
		level.Error(logger).Log("msg", "Load config error", "err", err)
		os.Exit(1)
	} else {
		level.Info(logger).Log("msg", "Load config ok")
	}

	NewClientWithConfig(proxyConf, logger)
}

//TestListPhoneDevice
//CMD: go test -run TestListPhoneDevice -v
func TestListPhoneDevice(t *testing.T) {
	requestID := uuid.New().String()

	devices, err := ListPhoneDevice(requestID)
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
	requestID := uuid.New().String()
	uuid := "177b3c01-8819-4ad8-afdd-3017b18db9a3"
	device, err := GetPhoneDevice(requestID, uuid)
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
