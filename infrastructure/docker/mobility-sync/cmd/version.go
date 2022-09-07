package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var version = "development"
var buildTime = "-"

// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Display version and build time",
	Long:  `Display software version and time it was build at.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Version:\t%s\n", version)
		fmt.Printf("Build time:\t%s\n", buildTime)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
