package v1

import (
	_ "fmt"

	"sonic-hub-proxy/api"
	"sonic-hub-proxy/api/v1/params"
	"sonic-hub-proxy/errno"
	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"

	"github.com/gin-gonic/gin"
)

//Stop
func StopTask(c *gin.Context) {

}

//ExecCommand Exec remote command
func RunTask(c *gin.Context) {
	req := new(params.RunTaskRequest)
	if err := req.Validator(c); err.Code != errno.Success.Code {
		api.ErrJSON(c, err)
		return
	}

	testCase, rawErr := agent.GetSuites(req.Task.Template.Key)
	if rawErr != nil {
		api.ErrJSON(c, errno.ErrNotFoundCase.WithRawErr(rawErr))
		return
	}

	isExisted := agent.CheckSuitesDevices(testCase.ID, req.Device.ID)
	if !isExisted {
		if rawErr := testCase.AddDevices(req.Device); rawErr != nil {
			api.ErrJSON(c, errno.ErrTaskBindDevice.WithRawErr(rawErr))
			return
		}
	}

	feiyu.PhoneTasks.Store(req.Device.UDID, req.Task)

	if rawErr := agent.RunSuite(testCase.ID); rawErr != nil {
		api.ErrJSON(c, errno.ErrRunSuitesCase.WithFmtAndRawErr(
			rawErr.Error(),
			rawErr,
		))
		return
	}

	api.SuccJSON(c)
}

//GetTask 获取正在执行的任务
func GetTask(c *gin.Context) {
	req := new(params.GetTaskRequest)
	if err := req.Validator(c); err.Code != errno.Success.Code {
		api.ErrJSON(c, err)
		return
	}

	task, _ := feiyu.PhoneTasks.Load(req.DeviceID)

	api.SuccJSONWithData(c, task)
}
