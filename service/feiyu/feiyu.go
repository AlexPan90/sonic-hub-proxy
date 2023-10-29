package feiyu

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"time"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
)

const (
	defaultMaxIdleConns        int = 40000
	defaultMaxIdleConnsPerHost int = 1000
	defaultIdleConnTimeout     int = 30
)

var (
	C *Client
)

type Client struct {
	client *http.Client
	cfg    *FeiyuServiceConfig

	logger log.Logger
}

//NewClientWithConfig
func NewClientWithConfig(cfg *FeiyuServiceConfig, logger log.Logger) error {
	c := &Client{
		logger: logger,
	}
	transport := &http.Transport{
		//	Proxy: http.ProxyFromEnvironment,
		DialContext: (&net.Dialer{
			//限制建立TCP连接的时间
			Timeout:   time.Duration(1) * time.Second,
			KeepAlive: 30 * time.Second,
		}).DialContext,
		MaxIdleConns:        defaultMaxIdleConns,
		MaxIdleConnsPerHost: defaultMaxIdleConnsPerHost,
		IdleConnTimeout:     time.Duration(defaultIdleConnTimeout) * time.Second,
		DisableKeepAlives:   false,
		//不包括发送数据超时和接收返回包正文体超时，只能大致的实现发送接收数据超时设置
		//ResponseHeaderTimeout: time.Second * 2,
	}
	c.client = &http.Client{
		Transport: transport,
		//包括从连接(Dial)到读完response body。
		Timeout: time.Duration(1) * time.Second,
	}

	c.cfg = cfg

	C = c

	return nil
}

func (c *Client) Patch(apiURL string, headers map[string]string, data []byte) ([]byte, error) {
	apiURL = fmt.Sprintf(c.cfg.Endpoint, apiURL)

	body := bytes.NewBuffer(data)

	level.Debug(c.logger).Log("method", http.MethodPatch, "request_url", apiURL)

	req, err := http.NewRequest(http.MethodPatch, apiURL, body)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return respBytes, nil
}

func (c *Client) Put(apiURL string, headers map[string]string, data []byte) ([]byte, error) {
	apiURL = fmt.Sprintf(c.cfg.Endpoint, apiURL)

	body := bytes.NewBuffer(data)

	level.Debug(c.logger).Log("method", http.MethodPut, "request_url", apiURL)

	req, err := http.NewRequest(http.MethodPut, apiURL, body)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return respBytes, nil
}

func (c *Client) Post(apiURL string, headers map[string]string, data []byte) ([]byte, error) {

	apiURL = fmt.Sprintf(c.cfg.Endpoint, apiURL)

	body := bytes.NewBuffer(data)

	level.Debug(c.logger).Log("method", http.MethodPost, "request_url", apiURL, "request_body", string(data))

	req, err := http.NewRequest(http.MethodPost, apiURL, body)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return respBytes, nil
}

func (c *Client) Get(apiURL string, headers map[string]string) ([]byte, error) {

	apiURL = fmt.Sprintf(c.cfg.Endpoint, apiURL)

	level.Debug(c.logger).Log("method", http.MethodGet, "request_url", apiURL)

	req, err := http.NewRequest(http.MethodGet, apiURL, nil)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf(`status="%+v" is not 200`, resp.StatusCode)
	}

	return respBytes, nil
}
