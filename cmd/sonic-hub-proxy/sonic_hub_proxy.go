package main

import (
	"os"

	"sonic-hub-proxy/config"
	"sonic-hub-proxy/device"
	"sonic-hub-proxy/internal/server"
	"sonic-hub-proxy/service/agent"
	"sonic-hub-proxy/service/feiyu"
	"sonic-hub-proxy/timer"

	"github.com/alecthomas/kingpin/v2"
	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
	"github.com/prometheus/common/promlog"
	"github.com/prometheus/common/promlog/flag"
	"github.com/prometheus/common/version"
)

func initLibrary(
	cfg *config.SonicHubProxyConfig,
	logger log.Logger,
) error {
	if _, err := agent.NewClientWithConfig(cfg, logger); err != nil {
		return err
	}

	if err := feiyu.NewClientWithConfig(cfg, logger); err != nil {
		return err
	}

	if err := device.MonitorFeiyuDevices(cfg, logger); err != nil {
		return err
	}

	go agent.WatchHubSonicDevices(cfg, logger)

	go device.MonitorSonicDevices(cfg, logger)

	go timer.Task(logger)
	return nil
}

func main() {
	var (
		listenAddress = kingpin.Flag(
			"web.listen-address",
			"Address on which to expose metrics and web interface.",
		).Default(":9123").String()

		maxRequests = kingpin.Flag(
			"web.max-requests",
			"Maximum number of parallel scrape requests. Use 0 to disable.",
		).Default("0").Int()

		configFile = kingpin.Flag(
			"config.file", "Sonic hub proxy configuration file.",
		).Default("proxy.yml").String()
	)

	promlogConfig := &promlog.Config{}

	flag.AddFlags(kingpin.CommandLine, promlogConfig)
	kingpin.Version(version.Print("ksc_exporter"))
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	logger := promlog.New(promlogConfig)

	level.Info(logger).Log("msg", "Starting ksc_exporter", "version", version.Info())
	level.Info(logger).Log("msg", "Build context", "build_context", version.BuildContext())

	proxyConf := config.NewConfig()
	if err := proxyConf.LoadFile(*configFile); err != nil {
		level.Error(logger).Log("msg", "Load config error", "err", err)
		os.Exit(1)
	} else {
		level.Info(logger).Log("msg", "Load config ok")
	}

	if err := initLibrary(proxyConf, logger); err != nil {
		level.Error(logger).Log("msg", "Failed to init library for proxy", "err", err)
		os.Exit(1)
	}

	server.NewHTTPServerWithConfig(proxyConf, *listenAddress, *maxRequests, logger)
}
