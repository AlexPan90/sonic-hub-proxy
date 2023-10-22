package errno

var (
	Success                  = &Err{HttpCode: 200, Code: "Success", Message: "Success"}
	ErrUnauthorized          = &Err{HttpCode: 200, Code: "Unauthorized", Message: "Unauthorized account."}
	ErrMissingToken          = &Err{HttpCode: 200, Code: "MissingToken", Message: "Request `X-Auth-Token` is missing in Header."}
	ErrTokenInvalid          = &Err{HttpCode: 200, Code: "InvalidToken", Message: "Invalid `X-Auth-Token`."}
	ErrCallerServiceInvalid  = &Err{HttpCode: 200, Code: "InvalidService", Message: "Invalid `X-From-Service` from header."}
	ErrCallerServiceNotAllow = &Err{HttpCode: 200, Code: "NotAllowCallerService", Message: "Current service call operation is not allowed."}
	ErrParamInvalid          = &Err{HttpCode: 200, Code: "InvalidParameter", Message: "Invalid parameter."}
	ErrInvalidParameterValue = &Err{HttpCode: 200, Code: "InvalidParameterValue", Message: "%s"}
	ErrParamTrimSpace        = &Err{HttpCode: 200, Code: "TrimSpaceParameter", Message: "TrimSpace parameter invalid."}
	ErrMissingParameter      = &Err{HttpCode: 400, Code: "MissingParameter", Message: "Parameter %s must be required."}
	ErrMissingParameterF     = &Err{HttpCode: 200, Code: "MissingParameter", Message: "Parameter %s must be required."}
	ErrInternalServerError   = &Err{HttpCode: 200, Code: "ServiceUnavailable", Message: "Internal server error."}
	ErrDatabase              = &Err{HttpCode: 200, Code: "ServiceException", Message: "Data operation exception."}
	ErrDBConnNotExisted      = &Err{HttpCode: 200, Code: "ServiceException", Message: "Data connection is not existed."}
	ErrLookupHost            = &Err{HttpCode: 200, Code: "LookupHostException", Message: "Exception for a given host."}
	ErrJSONException         = &Err{HttpCode: 200, Code: "JsonException", Message: "JSON data parsing failed."}
	ErrNotFoundDevice        = &Err{HttpCode: 400, Code: "NotFoundDevice", Message: "No corresponding device found."}
	ErrNotFoundTask          = &Err{HttpCode: 400, Code: "NotFoundTask", Message: "No corresponding task found."}
	ErrNotFoundTemplate      = &Err{HttpCode: 400, Code: "NotFoundTaskTemplate", Message: "No corresponding task template found."}
	ErrNotFoundCase          = &Err{HttpCode: 400, Code: "NotFoundSuitesCase", Message: "No corresponding case found."}
	ErrRunSuitesCase         = &Err{HttpCode: 400, Code: "FailedRunSuitesCase", Message: "%+v"}
	ErrTaskBindDevice        = &Err{HttpCode: 400, Code: "FailedBindDevice", Message: "Device binding task use case failed."}
)
