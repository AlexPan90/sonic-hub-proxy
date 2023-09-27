package params

import (
	"errors"
	"fmt"

	"sonic-hub-proxy/config"
	"sonic-hub-proxy/errno"
	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"

	"github.com/gin-gonic/gin"
)

type RunTaskRequest struct {
	DeviceID string             `json:"DeviceID"`
	TaskID   int64              `json:"TaskID"`
	Device   *agent.SonicDevice `json:"-"`
	Task     feiyu.Task         `json:"-"`
}

//Validator
func (req *RunTaskRequest) Validator(c *gin.Context) errno.Err {

	requestID := c.Request.Header.Get(config.HEADER_X_REQUEST_ID)

	if err := c.ShouldBindJSON(&req); err != nil {
		return errno.ErrParamInvalid.WithRawErr(err)
	}

	if len(req.DeviceID) <= 0 {
		return errno.ErrMissingParameter.WithFmtAndRawErr(
			"`DeviceID`",
			errors.New("`DeviceID` must be required."),
		)
	}

	if req.TaskID <= 0 {
		return errno.ErrMissingParameter.WithFmtAndRawErr(
			"`TaskID`",
			errors.New("`TaskID` must be required."),
		)
	}

	phone, isOK := agent.LocalPhoneDevices.Load(req.DeviceID)
	if !isOK {
		return errno.ErrNotFoundDevice.WithRawErr(
			fmt.Errorf("DeviceID=%+v not found.", req.DeviceID),
		)
	}

	req.Device = phone.(*agent.SonicDevice)

	task, err := feiyu.GetTask(requestID, req.TaskID, true)
	if err != nil {
		return errno.ErrNotFoundTask.WithRawErr(err)
	}

	if task.ID != req.TaskID {
		return errno.ErrNotFoundTask.WithRawErr(
			fmt.Errorf("TaskID=%+v not found.", req.TaskID),
		)
	}

	if len(task.Template.Key) <= 0 {
		return errno.ErrNotFoundTemplate.WithRawErr(
			fmt.Errorf("TaskID=%+v not found.", req.TaskID),
		)
	}

	req.Task = task

	return *errno.Success
}

type GetTaskRequest struct {
	DeviceID string `json:"SonicDeviceID" query:"SonicDeviceID"`
}

//Validator
func (req *GetTaskRequest) Validator(c *gin.Context) errno.Err {
	// requestID := c.Request.Header.Get(config.HEADER_X_REQUEST_ID)

	if err := c.ShouldBindJSON(&req); err != nil {
		return errno.ErrParamInvalid.WithRawErr(err)
	}

	if len(req.DeviceID) <= 0 {
		return errno.ErrMissingParameter.WithFmtAndRawErr(
			"`SonicDeviceID`",
			errors.New("`SonicDeviceID` must be required."),
		)
	}

	return *errno.Success
}
