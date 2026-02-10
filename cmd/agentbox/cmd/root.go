package cmd

import (
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	cfgFile string
	rootCmd = &cobra.Command{
		Use:   "agentbox",
		Short: "A Toolbx-inspired container management tool for AI agents",
		Long: `Agentbox allows you to create and manage interactive
command line environments for software development without installing
software on your host system.

Built on top of Docker/Podman and OCI container technologies.`,
		Version: "0.1.0",
	}
)

func Execute() error {
	return rootCmd.Execute()
}

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.config/agentbox/config.yaml)")
	rootCmd.PersistentFlags().String("engine", "auto", "Container engine to use (docker, podman, auto)")
	viper.BindPFlag("engine", rootCmd.PersistentFlags().Lookup("engine"))

	// Add subcommands
	rootCmd.AddCommand(createCmd)
	rootCmd.AddCommand(enterCmd)
	rootCmd.AddCommand(runCmd)
	rootCmd.AddCommand(listCmd)
	rootCmd.AddCommand(rmCmd)
	rootCmd.AddCommand(rmiCmd)
	rootCmd.AddCommand(completionCmd)
}

func initConfig() {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		viper.AddConfigPath("$HOME/.config/agentbox")
		viper.SetConfigName("config")
		viper.SetConfigType("yaml")
	}

	viper.SetEnvPrefix("AGENTBOX")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err == nil {
		rootCmd.Println("Using config file:", viper.ConfigFileUsed())
	}
}
