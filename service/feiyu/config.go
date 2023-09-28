package feiyu

import (
	"fmt"
)

const (
	HEADER_X_REQUEST_ID = "X-REQUEST-ID"
)

var (
	defaultBaseURL = "https://backend23.feiyu.ai%s"

	defaultReloadTaskIntervalSeconds = 10
)

//FeiyuServiceConfig
type FeiyuServiceConfig struct {
	Endpoint                  string `yaml:"endpoint"`
	RequestToken              string `yaml:"request_token"`
	PhoneGroupUUID            string `yaml:"phone_group_uuid"`
	ReloadTaskIntervalSeconds int    `yaml:"reload_task_interval_seconds"`
}

//Check
func (cfg *FeiyuServiceConfig) Check() error {
	// TODO:
	// if len(cfg.Endpoint) <= 0 {
	// 	return fmt.Errorf("configuration missing `services.feiyu.endpoint` value, must be required.")
	// }

	if len(cfg.PhoneGroupUUID) <= 0 {
		return fmt.Errorf("configuration missing `services.feiyu.phone_group_uuid` value, must be required.")
	}

	cfg.fillDefault()

	return nil
}

//fillDefault
func (cfg *FeiyuServiceConfig) fillDefault() {
	if len(cfg.Endpoint) <= 0 {
		cfg.Endpoint = defaultBaseURL
	}

	if cfg.ReloadTaskIntervalSeconds <= 0 {
		cfg.ReloadTaskIntervalSeconds = defaultReloadTaskIntervalSeconds
	}
}
