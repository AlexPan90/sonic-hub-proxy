package mysql

import (
	"strconv"
	"strings"
)

//InOrNotJoinWithInt64
func InOrNotJoinWithInt64(elements []int64) string {
	if len(elements) <= 0 {
		return ""
	}
	str := make([]string, len(elements))
	for i := 0; i < len(elements); i++ {
		str[i] = strconv.FormatInt(elements[i], 10)
	}
	return strings.Join(str, ",")
}

//InOrNotJoinWithInt
func InOrNotJoinWithInt(elements []int) string {
	if len(elements) <= 0 {
		return ""
	}
	str := make([]string, 0, len(elements))
	for _, v := range elements {
		str = append(str, strconv.Itoa(v))
	}
	return strings.Join(str, ",")
}

//InOrNotJoinWithString
func InOrNotJoinWithString(elements []string) string {
	switch len(elements) {
	case 0:
		return ""
	}
	var b strings.Builder
	for i := 0; i < len(elements)-1; i++ {
		b.WriteString("'")
		b.WriteString(elements[i])
		b.WriteString("',")
	}
	b.WriteString("'")
	b.WriteString(elements[len(elements)-1])
	b.WriteString("'")
	return b.String()
}
