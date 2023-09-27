package timer

import (
	_ "fmt"
	"time"

	"sonic-hub-proxy/device"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
)

const SleepTime = 10 * time.Second

func Task(logger log.Logger) {
	go loopFetchTasks(logger)
}

//loopTask
func loopFetchTasks(logger log.Logger) {
	for {
		if err := device.WatchTasks(logger); err != nil {
			level.Error(logger).Log("msg", "Failed to fetch task", "err", err)
		}

		device.ImmediateTasks.Run()

		device.PlannedTasks.Run()

		time.Sleep(SleepTime)
	}
}
