package feiyu

import (
	"errors"
	"fmt"
	"sync"
	"time"

	resty "github.com/go-resty/resty/v2"
	"github.com/google/uuid"
	jsoniter "github.com/json-iterator/go"
)

const (
	TaskStatus_Pendding = "pendding"
	TaskStatus_Cancel   = "cancel"
	TaskStatus_Doing    = "doing"
	TaskStatus_Done     = "done"
	TaskStatus_Fail     = "fail"

	ActTimeMode_Immediate = "asap"
	ActTimeMode_Planned   = "planned"
)

var (
	PhoneTasks sync.Map

	RemoteAllTasks sync.Map
)

var (
	ErrNotReachedExecTime = errors.New("Planned execution time has not been reached.")
)

type Task struct {
	ID               int64  `json:"id"`
	TaskName         string `json:"task_name"`
	UUID             string `json:"uuid"`
	TaskStatus       string `json:"task_status"`
	ActTimeMode      string `json:"act_time_mode"`
	PlannedStartTime string `json:"planned_start_time"`
	AssignedTo       int    `json:"assigned_to"`
	AssignedToUUID   string `json:"assigned_to_uuid"`
	TaskReason       string `json:"task_reason"`
	MaxTimeout       int    `json:"max_timeout"`
	GetTaskDataFunc  string `json:"get_task_data_func"`
	CreateTime       string `json:"create_time"`
	UpdateTime       string `json:"update_time"`

	TemplateID int64        `json:"template"`
	Template   TaskTemplate `json:"task_template"`

	ExtraData []*TaskData `json:"extra_data"`
}

type HubResponse struct {
	RequestID string      `json:"request_id"`
	Code      string      `json:"code"`
	Message   string      `json:"message"`
	Data      interface{} `json:"data"`
}

func (t *Task) ArrivalPlannedStartTime() bool {
	st, err := time.Parse(time.RFC3339Nano, t.PlannedStartTime)
	if err != nil {
		return false
	}
	plannedStartUnixTime := st.Unix()

	currentUnixTime := time.Now().Unix()

	if plannedStartUnixTime > currentUnixTime {
		return false
	}

	return true
}

//Run
func (t *Task) Run() error {
	if t.ActTimeMode == ActTimeMode_Planned {
		if !t.ArrivalPlannedStartTime() {
			return ErrNotReachedExecTime
		}
	}

	client := resty.New()

	client.SetHeaders(map[string]string{
		"Content-Type": "application/json",
		"X-REQUEST-ID": uuid.New().String(),
	})

	body := fmt.Sprintf(`{"DeviceID":"%+v", "TaskID": %d}`,
		t.AssignedToUUID,
		t.ID,
	)

	apiURL := "http://127.0.0.1:9123/v1/task/run"

	respBody, err := client.R().SetBody(body).Post(apiURL)
	if err != nil {
		return err
	}

	var data HubResponse
	err = jsoniter.Unmarshal(respBody.Body(), &data)
	if err != nil {
		return err
	}

	if data.Code != "Success" {
		return fmt.Errorf(data.Message)
	}

	return nil
}

//TaskPendding
func (t *Task) TaskPendding(reason string) error {
	t.TaskStatus = TaskStatus_Pendding
	t.TaskReason = reason

	return t.Modify()
}

//TaskFail
func (t *Task) TaskFail(reason string) error {
	t.TaskStatus = TaskStatus_Fail
	t.TaskReason = reason

	return t.Modify()
}

//TaskDoing
func (t *Task) TaskDoing(reason string) error {
	t.TaskStatus = TaskStatus_Doing
	t.TaskReason = reason

	return t.Modify()
}

//TaskDone
func (t *Task) TaskDone(reason string) error {
	t.TaskStatus = TaskStatus_Done
	t.TaskReason = reason

	return t.Modify()
}

//ModifyStatus
func (t *Task) Modify() error {
	requestId := uuid.New().String()
	headers := map[string]string{
		"X-REQUEST-ID": requestId,
		"Content-Type": "application/json",
		"Accept":       "*/*",
	}

	body := map[string]interface{}{
		"task_status": t.TaskStatus,
		"task_reason": t.TaskReason,
	}

	bodyJSON, err := jsoniter.Marshal(body)
	if err != nil {
		return err
	}

	apiURL := fmt.Sprintf("/rpa/api/v1/device_task/%+v/", t.UUID)
	_, err = C.Patch(apiURL, headers, bodyJSON)
	if err != nil {
		return err
	}

	task, err := GetTask(requestId, t.ID, true)
	if err != nil {
		return err
	}

	t = &task

	return nil
}

//GetTask
func GetTask(requestId string, taskID int64, isExtraData bool) (Task, error) {
	headers := map[string]string{
		"X-KSC-REQUEST-ID": requestId,
		"Content-Type":     "application/json",
		"Accept":           "*/*",
	}

	var task Task

	apiURL := fmt.Sprintf("/rpa/api/v1/device_task?id=%+v", taskID)
	respBody, err := C.Get(apiURL, headers)
	if err != nil {
		return task, err
	}

	var data ListTaskResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return task, err
	}

	if len(data.Results) <= 0 {
		return task, nil
	}

	if data.Results[0].ID != taskID {
		return task, nil
	}

	if isExtraData {
		data.Results[0].ExtraData, _ = ListTaskData(requestId, data.Results[0].UUID)
		data.Results[0].Template, _ = GetTaskTemplate(requestId, data.Results[0].TemplateID)
	}

	return *data.Results[0], nil
}

type ListTaskResponse struct {
	Results  []*Task `json:"results"`
	Count    int     `json:"count"`
	Previous string  `json:"previous"`
	Next     string  `json:"next"`
}

//ListTask
func ListTask(taskUUID string) ([]*Task, error) {
	headers := map[string]string{
		"X-KSC-REQUEST-ID": uuid.New().String(),
		"Content-Type":     "application/json",
		"Accept":           "*/*",
	}

	// apiURL := fmt.Sprintf("/rpa/api/v1/device_task/%+v/", uuid)
	queryParam := ""
	if len(taskUUID) > 0 {
		queryParam = fmt.Sprintf("?uuid=%+v", taskUUID)
	}

	apiURL := fmt.Sprintf("/rpa/api/v1/device_task/%s", queryParam)
	respBody, err := C.Get(apiURL, headers)
	if err != nil {
		return nil, err
	}

	var data ListTaskResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return nil, err
	}

	return data.Results, nil
}
