# sonic-hub-porxy

<p align="center">🎉 This is a hub proxy based on sonic-cloud.</p>

<p align="center">
  <a href="#">  
    <img src="https://img.shields.io/badge/platform-windows|macosx|linux-success">
  </a>
</p>

### Features

- Call `sonic-server` API to operate
- Call `feiyu` RPA API to operate
- Convert `feiyu` devices to `sonic` devices
- Automatically execute device distribution tasks created by `feiyu`
- `sonic` device discovery

### Build

<hr />

```shell
git clone git@github.com:AlexPan90/sonic-hub-proxy.git

go build cmd/sonic-hub-proxy/sonic_hub_proxy.go
```

### Configuration

Configuration parameter description:
```yaml
sonic_device_conf:
  hub_agent_key: 1
  reload_interval_seconds: 30
  monitor_interval_seconds: 10
  heartbeat_interval_seconds: 5
```