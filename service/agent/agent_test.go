package agent

import (
	"fmt"
	"os"
	"testing"

	"github.com/go-kit/log"
	"github.com/google/uuid"
)

var (
	logger log.Logger
)

func init() {
	if _, err := NewClientWithConfig(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

//TestListPhoneDevice
//CMD: go test -run TestListSonicDevice -v
func TestListSonicDevice(t *testing.T) {
	devices, err := ListSonicDevice(1)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(devices)
}

//TestWatchHubSonicDevices
//CMD: go test -run TestWatchHubSonicDevices -v
func TestWatchHubSonicDevices(t *testing.T) {
	if err := WatchHubSonicDevices(1, logger); err != nil {
		fmt.Println(err)
		return
	}

	HubSonicDevices.Range(func(key, value interface{}) bool {
		uuid := key.(string)
		device := value.(*SonicDevice)

		fmt.Println(uuid, *device)
		return true
	})
}

//TestMonitorSonicDevices
//CMD: go test -run TestMonitorSonicDevices -v
func TestMonitorSonicDevices(t *testing.T) {
	if err := WatchHubSonicDevices(1, logger); err != nil {
		fmt.Println(err)
		return
	}

	MonitorSonicDevices()
}

//TestRunSuite
//CMD: c
func TestRunSuite(t *testing.T) {
	requestID := uuid.New().String()

	if err := RunSuite(requestID, 3); err != nil {
		fmt.Println(err)
		return
	}
}
