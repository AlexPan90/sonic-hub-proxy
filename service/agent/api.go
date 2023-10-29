package agent

const (
	HeaderSonictoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYWRtaW4iLCJjM2Y3NDAzYy0yM2FjLTQ5MDMtOGZhYy0wNDY4NmJlNDlhNDQiXSwiZXhwIjoxNjk1NzQxMTc1fQ.Nk8fkL5QKNk4HfTMhSGc0JXQFeyKd411tIcNvIJD1CE"
)

// {"code":3003,"message":"所选设备暂无可用！","data":null}
type ApiResponse struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}
