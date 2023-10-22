package server

import (
	"sonic-hub-proxy/api/routers"
	"sonic-hub-proxy/config"

	"github.com/gin-gonic/gin"
	"github.com/go-kit/log"
)

//NewHTTPServerWithConfig
func NewHTTPServerWithConfig(
	cfg *config.SonicHubProxyConfig,
	listenAddress string,
	maxRequests int,
	logger log.Logger,
) {

	gin.SetMode(gin.ReleaseMode)
	// gin.SetMode(gin.DebugMode)

	g := gin.New()

	g = routers.Load(g)

	if err := g.Run(listenAddress); err != nil {
		// logger.F.Error("service start fail: " + err.Error())
	}
}
