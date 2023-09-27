package routers

import (
	v1 "sonic-hub-proxy/api/v1"

	"github.com/gin-gonic/gin"
)

func Load(g *gin.Engine) *gin.Engine {

	v1Api := g.Group("/v1")
	{
		v1Api.POST("/task/run", v1.RunTask)
		v1Api.POST("/task/stop", v1.StopTask)
		v1Api.POST("/task/get", v1.GetTask)
	}

	return g
}
