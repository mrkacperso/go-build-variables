package main

import (
	"fmt"
	"os"
)

const ProgramName = "go-build-variables"

var (
	Version  = "0.0.1"
	Build    = "000000"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Printf("%s usage:\n", ProgramName)
		fmt.Printf("\t-v, --version\t print vesrsion and build\n")
		return
	}

	arg := os.Args[1]
	if arg == "-v" || arg == "--version\n" {
		fmt.Printf("%s version %s, build: %s\n", ProgramName, Version, Build)
	}
}
