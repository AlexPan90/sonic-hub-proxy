package agent

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"time"

	"sonic-hub-proxy/config"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
)

const (
	defaultMaxIdleConns        int = 40000
	defaultMaxIdleConnsPerHost int = 1000
	defaultIdleConnTimeout     int = 30
)

var (
	Client *Agent

	defaultApiBaseURL = "http://192.168.1.15:3000%s"

	defaultDSN = "root:123456@tcp(127.0.0.1:3306)/sonic?charset=utf8&loc=Asia%2FShanghai"
)

//Agent
type Agent struct {
	client *http.Client

	DB *xorm.Engine

	logger log.Logger
}

//NewClientWithConfig
func NewClientWithConfig(cfg *config.SonicHubProxyConfig, logger log.Logger) (*Agent, error) {
	c := &Agent{
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

	conn, err := NewXormEngine()
	if err != nil {
		return nil, err
	}

	c.DB = conn

	Client = c

	return c, nil
}

//NewXormEngine
func NewXormEngine() (*xorm.Engine, error) {
	conn, err := xorm.NewEngine("mysql", defaultDSN)
	if err != nil {
		return nil, err
	}
	conn.SetMaxIdleConns(150)
	conn.SetMaxOpenConns(300)

	return conn, nil
}

func (a *Agent) Get(apiURL string, headers map[string]string) ([]byte, error) {

	apiURL = fmt.Sprintf(defaultApiBaseURL, apiURL)

	req, err := http.NewRequest(http.MethodGet, apiURL, nil)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := a.client.Do(req)
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

func (a *Agent) Put(apiURL string, headers map[string]string, data []byte) ([]byte, error) {

	apiURL = fmt.Sprintf(defaultApiBaseURL, apiURL)

	level.Debug(a.logger).Log("method", http.MethodPut, "request_url", apiURL, "request_body", string(data))

	body := bytes.NewBuffer(data)

	req, err := http.NewRequest(http.MethodPut, apiURL, body)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := a.client.Do(req)
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
