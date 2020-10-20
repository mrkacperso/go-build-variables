package main

import (
	"fmt"
)

var (
	Version  = "0.0.1"
	Build    = "000000"
)

func main() {
	fmt.Printf("version %s, build: %s\n", Version, Build)
}
