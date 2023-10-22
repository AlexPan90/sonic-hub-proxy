package device

import (
	"fmt"
	"time"

	"sonic-hub-proxy/config"
	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
)

//MonitorFeiyuDevices
func MonitorFeiyuDevices(cfg *config.SonicHubProxyConfig, logger log.Logger) error {
	l, err := feiyu.ListPhoneDevice()
	if err != nil {
		level.Error(logger).Log("msg", "Load feiyu device error", "err", err)
		return err
	}

	for i := 0; i < len(l); i++ {
		feiyu.PhoneDevices.Store(l[i].LocalRegUUID, l[i])
	}

	return nil
}

//MonitorSonicDevices
func MonitorSonicDevices(cfg *agent.SonicServiceConfig, logger log.Logger) {
	ticker := time.NewTicker(time.Duration(cfg.MonitorIntervalSeconds) * time.Second)
	defer ticker.Stop()

	for {
		level.Info(logger).Log("msg", "Start monitoring sonic device")
		agent.HubSonicDevices.Range(func(key, value interface{}) bool {
			d := value.(*agent.SonicDevice)

			if len(d.RemoteFYUUID) <= 0 {
				phoneValue, isOK := feiyu.PhoneDevices.Load(d.UDID)
				if !isOK {
					if err := CreatePhoneDevice(d); err != nil {
						level.Error(logger).Log("msg", "Failed to create phone device to feiyu.", "err", err.Error())
					}
				} else {
					phone := phoneValue.(*feiyu.PhoneDevice)

					d.RemoteFYUUID = phone.UUID
					if err := d.UpdateRemoteFYUUID(); err != nil {
						level.Error(logger).Log("msg", "Failed to update phone device to feiyu.", "err", err.Error())
					}
				}

				level.Info(logger).Log("msg", "Device added remotely successfully.", "remote_feiyu_uuid", d.RemoteFYUUID)

				if len(d.RemoteFYUUID) > 0 {
					agent.LocalPhoneDevices.Store(d.RemoteFYUUID, d)
				}
			}

			level.Info(logger).Log("msg", fmt.Sprintf("reload %s instances every %d seconds",
				d.Name,
				cfg.MonitorIntervalSeconds,
			))

			return true
		})
		level.Info(logger).Log("msg", "End monitoring sonic device")

		select {
		case <-ticker.C:
		}
	}
}

//CreatePhoneDevice
func CreatePhoneDevice(d *agent.SonicDevice) error {
	p := &feiyu.PhoneDevice{
		UUID:         d.UDID,
		LocalRegUUID: d.UDID,
		Name:         d.Name,
		PhoneModel:   d.Model,
		PhoneGroup:   1,
		Brand:        d.Manufacturer,
		OS:           d.OSName(),
		OsVersion:    d.Version,
		AppVersion:   "v1.0",
		PhoneNumber:  "13588888888",
	}

	remoteFYUUID, err := p.Reported()
	if err != nil {
		return err
	}

	d.RemoteFYUUID = remoteFYUUID

	if err := d.UpdateRemoteFYUUID(); err != nil {
		return err
	}

	return err
}
