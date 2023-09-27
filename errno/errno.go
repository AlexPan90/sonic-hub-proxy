package errno

import (
	"errors"
	"fmt"
)

//Err
type Err struct {
	HttpCode int    `json:"-" xml:"-"`
	Code     string `json:"code" xml:"Code"`
	Message  string `json:"message" xml:"Message"`
	RawErr   error  `json:"-"`
}

//New
func New(httpCode int, errCode string, msg string, err error) Err {
	return Err{
		HttpCode: httpCode,
		Code:     errCode,
		Message:  msg,
		RawErr:   err,
	}
}

//WithRawErr Used to add service raw error
func (e *Err) WithRawErr(err error) Err {
	return Err{
		HttpCode: e.HttpCode,
		Code:     e.Code,
		Message:  e.Message,
		RawErr:   err,
	}
}

//WithFmt
func (e *Err) WithFmt(f string) Err {
	errs := Err{
		HttpCode: e.HttpCode,
		Code:     e.Code,
		Message:  e.Message,
	}
	errs.Message = fmt.Sprintf(errs.Message, f)

	return errs
}

//WithFmtAndRawErr
func (e *Err) WithFmtAndRawErr(f string, err error) Err {
	errs := Err{
		HttpCode: e.HttpCode,
		Code:     e.Code,
		Message:  e.Message,
		RawErr:   err,
	}
	errs.Message = fmt.Sprintf(errs.Message, f)

	return errs
}

//WithCodeAndMessage
func (e *Err) WithCodeAndMessage(code, msg string) Err {
	return Err{
		HttpCode: e.HttpCode,
		Code:     code,
		Message:  msg,
		RawErr:   errors.New(msg),
	}
}
