package feiyu

import (
	"fmt"
	"os"

	"github.com/google/uuid"
	jsoniter "github.com/json-iterator/go"
)

var LocalPhoneGroup *PhoneGroup

//PhoneGroup
type PhoneGroup struct {
	ID        int64  `json:"id"`
	Name      string `json:"name"`
	UUID      string `json:"uuid"`
	Status    string `json:"status"`
	Version   string `json:"version"`
	Location  string `json:"location"`
	Org       int    `json:"org"`
	Order     int    `json:"order"`
	IsDeleted bool   `json:"is_deleted"`
}

//CheckPhoneGroup
func CheckPhoneGroup() error {
	pg, err := GetPhoneGroup(C.cfg.PhoneGroupUUID)
	if err != nil {
		return fmt.Errorf("Unable to start service, phone group `%+v` not found.",
			C.cfg.PhoneGroupUUID,
		)
	}

	LocalPhoneGroup = &pg

	return nil
}

//CreatePhoneGroup
func CreatePhoneGroup() error {
	headers := map[string]string{
		HEADER_X_REQUEST_ID: uuid.New().String(),
		"Content-Type":      "application/json",
		"Accept":            "*/*",
	}

	name, err := os.Hostname()
	if err != nil {
		return err
	}

	// t := time.Now().Format(time.RFC3339Nano)
	body := map[string]interface{}{
		"name":       name,
		"status":     "active",
		"version":    "v0.1",
		"org":        3,
		"order":      1,
		"is_deleted": false,
	}

	bodyJSON, err := jsoniter.Marshal(body)
	if err != nil {
		return err
	}

	respBody, err := C.Post("/rpa/api/v1/phone_group/", headers, bodyJSON)
	if err != nil {
		return err
	}

	fmt.Println(string(respBody))

	return nil
}

//ListPhoneGroupResponse
type ListPhoneGroupResponse struct {
	Results  []*PhoneGroup `json:"results"`
	Count    int           `json:"count"`
	Previous string        `json:"previous"`
	Next     string        `json:"next"`
}

//ListPhoneGroup
func ListPhoneGroup() (l []*PhoneGroup, err error) {
	// ?format=api
	headers := map[string]string{
		HEADER_X_REQUEST_ID: uuid.New().String(),
	}

	respBody, err := C.Get("/rpa/api/v1/phone_group/", headers)
	if err != nil {
		return nil, err
	}

	var data ListPhoneGroupResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return nil, err
	}

	if len(data.Results) <= 0 {
		return nil, nil
	}

	l = data.Results

	return l, nil
}

//GetPhoneGroup
func GetPhoneGroup(groupUUID string) (PhoneGroup, error) {
	headers := map[string]string{
		HEADER_X_REQUEST_ID: uuid.New().String(),
	}

	var g PhoneGroup

	respBody, err := C.Get(fmt.Sprintf("/rpa/api/v1/phone_group/%+v/", groupUUID), headers)
	if err != nil {
		return g, err
	}

	err = jsoniter.Unmarshal(respBody, &g)
	if err != nil {
		return g, err
	}

	return g, nil
}
