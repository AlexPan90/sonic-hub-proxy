package feiyu

import (
	"fmt"

	jsoniter "github.com/json-iterator/go"
)

type TaskData struct {
	ID          int64  `json:"id"`
	Title       string `json:"title"`
	Text        string `json:"text"`
	Description string `json:"description"`

	ImageURLs []string `json:"image_url_list"`
	VideoURL  string   `json:"video_url"`
}

//ParseImages check image urls and download image.
func (t *TaskData) ParseImages() error {
	return nil
}

//ParseVideo check video url and download.
func (t *TaskData) ParseVideo() error {
	return nil
}

//ListTaskDataResponse
type ListTaskDataResponse struct {
	Code    string      `json:"Code"`
	Message string      `json:"Message"`
	Count   int         `json:"count"`
	Results []*TaskData `json:"results"`
}

func ListTaskData(requestId, taskUUID string) ([]*TaskData, error) {
	headers := map[string]string{
		HEADER_X_REQUEST_ID: requestId,
		"Content-Type":      "application/json",
		"Accept":            "*/*",
	}

	apiURL := fmt.Sprintf("/rpa/api/v1/device_task_data/?task_uuid=%+v", taskUUID)

	respBody, err := C.Get(apiURL, headers)
	if err != nil {
		return nil, err
	}

	var data ListTaskDataResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return nil, err
	}

	if len(data.Results) <= 0 {
		return nil, nil
	}

	return data.Results, nil
}
