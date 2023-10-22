package agent

import (
	"fmt"
)

const (
	defaultReloadIntervalSeconds    = 60
	defaultMonitorIntervalSeconds   = 30
	defaultHeartbeatIntervalSeconds = 10
)

var (
	defaultApiBaseURL = "http://192.168.1.15:3000%s"

	defaultDSN = "root:123456@tcp(127.0.0.1:3306)/sonic?charset=utf8&loc=Asia%2FShanghai"
)

//SonicServiceConfig
type SonicServiceConfig struct {
	Endpoint                 string   `yaml:"endpoint"`
	HubAgentKey              int64    `yaml:"hub_agent_key"`
	HubRequestToken          string   `yaml:"hub_request_token"`
	HubDSN                   string   `yaml:"hub_dsn"`
	ExcludeDevices           []string `yaml:"exclude_devices"`
	ReloadIntervalSeconds    int      `yaml:"reload_interval_seconds"`
	MonitorIntervalSeconds   int      `yaml:"monitor_interval_seconds"`
	HeartbeatIntervalSeconds int      `yaml:"heartbeat_interval_seconds"`
}

//Check
func (cfg *SonicServiceConfig) Check() error {

	if cfg.HubAgentKey <= 0 {
		return fmt.Errorf("configuration missing `services.sonic.hub_agent_key` value, must be required.")
	}

	if len(cfg.HubRequestToken) <= 0 {
		return fmt.Errorf("configuration missing `services.sonic.hub_request_token` value, must be required.")
	}

	cfg.fillDefault()

	return nil
}

//fillDefault
func (cfg *SonicServiceConfig) fillDefault() {
	if cfg.ReloadIntervalSeconds <= 0 {
		cfg.ReloadIntervalSeconds = defaultReloadIntervalSeconds
	}

	if cfg.MonitorIntervalSeconds <= 0 {
		cfg.MonitorIntervalSeconds = defaultMonitorIntervalSeconds
	}

	if cfg.HeartbeatIntervalSeconds <= 0 {
		cfg.HeartbeatIntervalSeconds = defaultHeartbeatIntervalSeconds
	}

	if len(cfg.Endpoint) <= 0 {
		cfg.Endpoint = defaultApiBaseURL
	}

	if len(cfg.HubDSN) <= 0 {
		cfg.HubDSN = defaultDSN
	}
}
