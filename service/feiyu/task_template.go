package feiyu

import (
	"fmt"

	jsoniter "github.com/json-iterator/go"
)

type TaskTemplate struct {
	TaskName     string      `json:"task_name"`
	Key          string      `json:"key"`
	ActiveStatus string      `json:"active_status"`
	Category     int         `json:"category"`
	Platform     int         `json:"platform"`
	Order        int         `json:"order"`
	Parent       interface{} `json:"parent"`
}

//GetTaskTemplate
func GetTaskTemplate(requestId string, templateId int64) (TaskTemplate, error) {
	headers := map[string]string{
		HEADER_X_REQUEST_ID: requestId,
		"Content-Type":      "application/json",
		"Accept":            "*/*",
	}

	var template TaskTemplate

	apiURL := fmt.Sprintf("/rpa/api/v1/device_task_template/%+v/", templateId)
	respBody, err := C.Get(apiURL, headers)
	if err != nil {
		return template, err
	}

	err = jsoniter.Unmarshal(respBody, &template)
	if err != nil {
		return template, err
	}

	return template, nil
}
