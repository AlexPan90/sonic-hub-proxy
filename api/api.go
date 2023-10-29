package api

import (
	"net/http"

	"sonic-hub-proxy/config"
	"sonic-hub-proxy/errno"

	"github.com/gin-gonic/gin"
)

type Response struct {
	RequestID string      `json:"request_id"`
	Code      string      `json:"code"`
	Message   string      `json:"message"`
	Data      interface{} `json:"data"`
}

//SuccJSONWithData
func SuccJSONWithData(c *gin.Context, data interface{}) {
	resp := Response{
		RequestID: c.Request.Header.Get(config.HEADER_X_REQUEST_ID),
		Code:      errno.Success.Code,
		Message:   errno.Success.Message,
		Data:      data,
	}

	c.JSON(http.StatusOK, resp)
}

//SuccJSON 成功返回
func SuccJSON(c *gin.Context) {
	resp := Response{
		RequestID: c.Request.Header.Get(config.HEADER_X_REQUEST_ID),
		Code:      errno.Success.Code,
		Message:   errno.Success.Message,
	}

	c.JSON(http.StatusOK, resp)
}

//ErrJSON
func ErrJSON(c *gin.Context, err errno.Err) {
	resp := Response{
		RequestID: c.Request.Header.Get(config.HEADER_X_REQUEST_ID),
		Code:      err.Code,
		Message:   err.Message,
	}

	c.JSON(err.HttpCode, resp)
}
