package main

import "C"
import "fmt"
import "github.com/satori/go.uuid"

//export Test
func Test(name string) string {
	uuid := uuid.NewV4()
	return fmt.Sprintf("[%s] Hello %s", uuid.String(), name)
}

func main() {}
