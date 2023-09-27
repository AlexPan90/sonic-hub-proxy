package config

import (
	_ "fmt"
	"io/ioutil"
	_ "os"
	_ "strings"

	"gopkg.in/yaml.v2"
)

const (
	HEADER_X_REQUEST_ID = "X-Request-ID"
)

type SonicDeviceConfig struct {
	HubAgentKey              int64    `yaml:"hub_agent_key"`
	ExcludeDevices           []string `yaml:"exclude_devices"`
	ReloadIntervalSeconds    int      `yaml:"reload_interval_seconds"`
	MonitorIntervalSeconds   int      `yaml:"monitor_interval_seconds"`
	HeartbeatIntervalSeconds int      `yaml:"heartbeat_interval_seconds"`
}

type SonicHubProxyConfig struct {
	Filename    string             `yaml:"filename"`
	RateLimit   float64            `yaml:"rate_limit"`
	SonicDevice *SonicDeviceConfig `yaml:"sonic_device_conf"`
}

//NewConfig
func NewConfig() *SonicHubProxyConfig {
	return &SonicHubProxyConfig{}
}

//LoadFile
func (c *SonicHubProxyConfig) LoadFile(filename string) error {
	c.Filename = filename
	content, err := ioutil.ReadFile(c.Filename)
	if err != nil {
		return err
	}
	if err = yaml.UnmarshalStrict(content, c); err != nil {
		return err
	}

	if err = c.check(); err != nil {
		return err
	}

	c.fillDefault()

	return nil
}

func (c *SonicHubProxyConfig) check() (err error) {
	return nil
}

func (c *SonicHubProxyConfig) fillDefault() {

}
