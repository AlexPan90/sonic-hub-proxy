package agent

import (
	"context"
	"fmt"
	"sync"
	"time"

	"sonic-hub-proxy/config"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
)

const (
	DeviceStatusOnline = "ONLINE"
)

var (
	defaultReloadInterval = 5

	HubSonicDevices sync.Map

	LocalPhoneDevices sync.Map
)

type SonicDevice struct {
	ID int64 `xorm:"Id" json:"id"`

	AgentID int64 `xorm:"agent_id" json:"agentId"`

	// CPU 架构
	CPU string `xorm:"cpu" json:"cpu"`

	// 制造商
	Manufacturer string `xorm:"manufacturer" json:"manufacturer"`

	// 手机型号
	Model string `xorm:"model" json:"model"`

	// 设备名称
	Name string `xorm:"name" json:"name"`

	// 系统类型 1：android 2：ios
	Platform int `xorm:"platform" json:"platform"`

	Size string `xorm:"size" json:"size"`

	// 设备状态
	Status string `xorm:"status" json:"status"`

	// 设备序列号
	UDID string `xorm:"ud_id" json:"udId"`

	// 远程飞鱼的UUID
	RemoteFYUUID string `xorm:"remote_feiyu_uuid" json:"-"`

	// 设备系统版本
	Version string `xorm:"version" json:"version"`

	User string `xorm:"user" json:"user"`

	// 设备温度
	Temperature int `xorm:"temperature" json:"temperature"`

	// 设备电池电压
	Voltage int `xorm:"voltage" json:"voltage"`

	// 设备电量
	Level int `xorm:"level" json:"level"`

	reloadInterval time.Duration `xorm:"-" json:"-"`

	ctx context.Context `xorm:"-" json:"-"`

	cancel context.CancelFunc `xorm:"-" json:"-"`

	logger log.Logger `xorm:"-" json:"-"`
}

//OSName
func (d *SonicDevice) OSName() string {
	if d.Platform == 1 {
		return "Android"
	}

	if d.Platform == 2 {
		return "IOS"
	}

	return "Unknown"
}

func (d *SonicDevice) Run() {

	ticker := time.NewTicker(d.reloadInterval * time.Second)
	defer ticker.Stop()

	// sleep when first start
	time.Sleep(d.reloadInterval * time.Second)

	for {
		level.Info(d.logger).Log("msg", "start reload sonic device", "Namespace", d.Name)

		if e := d.Heartbeat(); e != nil {
			level.Error(d.logger).Log("msg", "reload product error", "err", e, "namespace", d.Name)
		}

		level.Info(d.logger).Log("msg", "complete reload product metadata", "Namespace", d.Name)

		select {
		case <-d.ctx.Done():
			return
		case <-ticker.C:
		}
	}
}

//UpdateRemoteFYUUID
func (d *SonicDevice) UpdateRemoteFYUUID() error {
	execSQL := fmt.Sprintf("UPDATE `devices` SET remote_feiyu_uuid = '%s' WHERE id = %d;",
		d.RemoteFYUUID,
		d.ID,
	)

	if _, err := Client.DB.Exec(execSQL); err != nil {
		return err
	}
	return nil
}

func (d *SonicDevice) Heartbeat() error {
	level.Debug(d.logger).Log("msg", "start reload sonic device", "name", d.Name)
	level.Debug(d.logger).Log("msg", "complete reload product metadata", "name", d.Name)
	return nil
}

func Upload(url string) error {
	// http://192.168.1.15:3000/server/api/folder/upload
	return nil
}

//ListSonicDevice
func ListSonicDevice(agentID int64) (l []*SonicDevice, err error) {
	err = Client.DB.SQL("SELECT * FROM devices;").Find(&l)
	return
}

//WatchHubSonicDevices
func WatchHubSonicDevices(cfg *config.SonicHubProxyConfig, logger log.Logger) error {

	ticker := time.NewTicker(time.Duration(cfg.SonicDevice.ReloadIntervalSeconds) * time.Second)
	defer ticker.Stop()

	for {
		level.Info(logger).Log("msg", "Start watching sonic device")
		l, err := ListSonicDevice(cfg.SonicDevice.HubAgentKey)
		if err != nil {
			level.Error(logger).Log("msg", "Load sonic device error", "err", err)
		}

		for i := 0; i < len(l); i++ {
			l[i].reloadInterval = time.Duration(cfg.SonicDevice.HeartbeatIntervalSeconds)
			l[i].ctx = context.TODO()
			l[i].logger = logger

			HubSonicDevices.Store(l[i].UDID, l[i])

			if len(l[i].RemoteFYUUID) > 0 {
				LocalPhoneDevices.Store(l[i].RemoteFYUUID, l[i])
			}
		}
		level.Info(logger).Log("msg", "End watching sonic device")

		select {
		case <-ticker.C:
		}
	}
}
