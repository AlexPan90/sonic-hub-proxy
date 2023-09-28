package config

import (
	_ "fmt"
	"io/ioutil"
	_ "os"
	_ "strings"

	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"

	"gopkg.in/yaml.v2"
)

const (
	HEADER_X_REQUEST_ID = "X-Request-ID"
)

type SonicHubServicesConfig struct {
	Sonic *agent.SonicServiceConfig `yaml:"sonic"`
	Feiyu *feiyu.FeiyuServiceConfig `yaml:"feiyu"`
}

//SonicHubProxyConfig
type SonicHubProxyConfig struct {
	Filename  string                 `yaml:"filename"`
	RateLimit float64                `yaml:"rate_limit"`
	Services  SonicHubServicesConfig `yaml:"services"`
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

func (c *SonicHubProxyConfig) check() error {
	if err := c.Services.Sonic.Check(); err != nil {
		return err
	}

	if err := c.Services.Feiyu.Check(); err != nil {
		return err
	}

	return nil
}

func (c *SonicHubProxyConfig) fillDefault() {

}
