package device

import (
	"errors"
	"fmt"
	"sync"

	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
)

var (
	// PlannedTasks 计划任务
	PlannedTasks = &DeviceTasks{
		L:       make(map[string][]*feiyu.Task),
		TaskIDs: make(map[string]struct{}),
	}

	// ImmediateTasks 实时任务
	ImmediateTasks = &DeviceTasks{
		L:       make(map[string][]*feiyu.Task),
		TaskIDs: make(map[string]struct{}),
	}
)

//DeviceTasks 设备任务
type DeviceTasks struct {

	// 存放待执行的任务列表
	L map[string][]*feiyu.Task

	// 用于过滤
	TaskIDs map[string]struct{}

	m sync.Mutex
}

//Append
func (i *DeviceTasks) Append(t *feiyu.Task) {
	i.m.Lock()
	defer i.m.Unlock()

	if _, isOK := i.TaskIDs[t.UUID]; isOK {
		return
	}

	i.L[t.AssignedToUUID] = append(i.L[t.AssignedToUUID], t)

	i.TaskIDs[t.UUID] = struct{}{}
}

//Run
func (i *DeviceTasks) Run() {
	var wg sync.WaitGroup
	for deviceUUID, tasks := range i.L {
		wg.Add(1)
		go func(deviceID string, pendingTasks []*feiyu.Task) {
			defer func() {
				if e := recover(); e != nil {
				}
				defer wg.Done()
			}()

			//获取监控项下对应资源
			deleteKeys := make([]int, 0, len(pendingTasks))
			for key, t := range pendingTasks {
				if err := t.Run(); err != nil {
					if errors.Is(err, feiyu.ErrNotReachedExecTime) {
						t.TaskPendding(err.Error())
						continue
					}

					if err := t.TaskFail(err.Error()); err != nil {
						fmt.Println(err)
					}
					continue
				}
				deleteKeys = append(deleteKeys, key)
			}

			if len(deleteKeys) > 0 {
				for _, k := range deleteKeys {
					pendingTasks = append(pendingTasks[:k:k], pendingTasks[k+1:]...)
				}
			}

		}(deviceUUID, tasks)

	}
	wg.Wait()
}

//WatchTasks
func WatchTasks(logger log.Logger) error {
	tasks, err := feiyu.ListTask("")
	if err != nil {
		return err
	}

	ParseTasks(tasks, logger)

	level.Info(logger).Log("msg", "Successful watch task list.", "immediate_tasks_num", len(ImmediateTasks.L), "planned_tasks_num", len(PlannedTasks.L))

	return nil
}

//ParseTasks
func ParseTasks(tasks []*feiyu.Task, logger log.Logger) {
	tasksCount := len(tasks)
	if tasksCount <= 0 {
		return
	}

	for i := 0; i < tasksCount; i++ {
		// 1.任务状态不是未执行状态，则不处理，直接忽略
		if tasks[i].TaskStatus != feiyu.TaskStatus_Pendding {
			level.Debug(logger).Log("msg", "Abnormal task status.",
				"task_name", tasks[i].TaskName,
				"task_status", tasks[i].TaskStatus,
			)
			continue
		}

		value, isOK := agent.LocalPhoneDevices.Load(tasks[i].AssignedToUUID)
		if !isOK {
			level.Error(logger).Log("msg", "Not found phone device in hub.",
				"task_id", tasks[i].ID,
				"task_name", tasks[i].TaskName,
				"assigned_to_uuid", tasks[i].AssignedToUUID,
			)
			continue
		}
		device := value.(*agent.SonicDevice)

		// 2.任务分配的设备不在线，则直接修改任务状态为失败
		if device.Status != agent.DeviceStatusOnline {
			tasks[i].TaskStatus = feiyu.TaskStatus_Fail
			tasks[i].TaskReason = fmt.Sprintf("Device `%+v` is offline, please change another device.",
				device.Name,
			)

			if err := tasks[i].Modify(); err != nil {
				level.Error(logger).Log("msg", "Failed to update feiyu task status", "err", err)
			}
			continue
		}

		// 3.判断任务类型是否为实时任务
		if tasks[i].ActTimeMode == feiyu.ActTimeMode_Immediate {
			ImmediateTasks.Append(tasks[i])
		}

		// 4.判断任务类型是否为计划任务
		if tasks[i].ActTimeMode == feiyu.ActTimeMode_Planned {
			PlannedTasks.Append(tasks[i])
		}
	}
}
