package main

/*
typedef int (*intFunc) ();

static inline int bridge_int_func(intFunc f) {
  return f();
}
*/
import "C"
import "unsafe"
import "fmt"

// Use a third-party package to make sure they work
import "github.com/satori/go.uuid"

//export Bridge
// This Go function is called from C
func Bridge(param string, callback unsafe.Pointer) string {
	uuid := uuid.NewV4()
	return fmt.Sprintf("[%s] %s = %d", uuid.String(), param, C.bridge_int_func(C.intFunc(callback)))
}

// Not used but must be present
func main() {}
