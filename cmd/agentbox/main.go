package main

import (
	"fmt"
	"os"

	"github.com/oliveagle/agentbox/cmd/agentbox/cmd"
)

func main() {
	if err := cmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
