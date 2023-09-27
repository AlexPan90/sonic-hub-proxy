package feiyu

import (
	"fmt"
	"sync"
	"time"

	"github.com/google/uuid"
	jsoniter "github.com/json-iterator/go"
)

var (
	PhoneDevices sync.Map
)

//PhoneDevice
type PhoneDevice struct {
	ID           int64  `json:"id"`
	Name         string `json:"name"`
	UUID         string `json:"uuid"`
	LocalRegUUID string `json:"local_reg_uuid"`
	PhoneGroup   int64  `json:"phone_group"`
	Brand        string `json:"brand"`
	OS           string `json:"os"`
	PhoneModel   string `json:"phone_model"`
	OsVersion    string `json:"os_version"`
	AppVersion   string `json:"app_version"`
	PhoneNumber  string `json:"phone_number"`
	Status       string `json:"status"`
	Order        int    `json:"order"`
	IsRegistered bool   `json:"is_registered"`
	IsDeleted    bool   `json:"is_deleted"`
}

//Heartbeat
func (d *PhoneDevice) Heartbeat() error {
	return nil
}

//Reported
func (d *PhoneDevice) Reported() (string, error) {
	headers := map[string]string{
		"X-REQUEST-ID": uuid.New().String(),
		"Content-Type": "application/json",
		"Accept":       "*/*",
	}

	t := time.Now().Format(time.RFC3339Nano)
	body := map[string]interface{}{
		"name":             d.Name,
		"phone_group":      d.PhoneGroup,
		"local_reg_uuid":   d.UUID,
		"brand":            d.Brand,
		"phone_model":      d.PhoneModel,
		"os":               d.OS,
		"os_version":       d.OsVersion,
		"app_version":      d.AppVersion,
		"phone_number":     d.PhoneNumber,
		"status":           d.Status,
		"order":            1,
		"is_deleted":       d.IsDeleted,
		"is_registered":    d.IsRegistered,
		"register_time":    t,
		"last_active_time": t,
	}

	bodyJSON, err := jsoniter.Marshal(body)
	if err != nil {
		return "", err
	}

	respBody, err := C.Post("/rpa/api/v1/phone_device/", headers, bodyJSON)
	if err != nil {
		return "", err
	}

	var data PhoneDevice
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return "", err
	}

	if len(data.UUID) <= 0 {
		return "", fmt.Errorf(`failed to reporting phone device id="%+v"`, d.UUID)
	}

	return data.UUID, nil
}

func GetPhoneDevice(requestId, uuid string) (PhoneDevice, error) {
	headers := map[string]string{
		"X-REQUEST-ID": requestId,
	}

	var phone PhoneDevice

	respBody, err := C.Get(fmt.Sprintf("/rpa/api/v1/phone_device/%+v/", uuid), headers)
	if err != nil {
		return phone, err
	}

	err = jsoniter.Unmarshal(respBody, &phone)
	if err != nil {
		return phone, err
	}

	return phone, nil
}

type ListPhoneDeviceResponse struct {
	Results  []*PhoneDevice `json:"results"`
	Count    int            `json:"count"`
	Previous string         `json:"previous"`
	Next     string         `json:"next"`
}

//ListPhoneDevice
func ListPhoneDevice() (l []*PhoneDevice, err error) {

	headers := map[string]string{
		"X-REQUEST-ID": uuid.New().String(),
	}

	respBody, err := C.Get("/rpa/api/v1/phone_device", headers)
	if err != nil {
		return nil, err
	}

	var data ListPhoneDeviceResponse
	err = jsoniter.Unmarshal(respBody, &data)
	if err != nil {
		return nil, err
	}

	if len(data.Results) <= 0 {
		return nil, nil
	}

	l = append(l, data.Results...)

	return l, nil
}
