package timer

import (
	"testing"
	"time"
)

//TestAddJobs
//CMD: go test -run TestAddJobs -v
func TestAddJobs(t *testing.T) {
	c := StartJobs()

	AddJob(c, "/1 * * * * *", JobTask{Name: "abc"})

	time.Sleep(180 * time.Second)
}
