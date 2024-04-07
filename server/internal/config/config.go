package config

import (
	"encoding/json"
	"mars-go-service/internal/logger"
	"os"
)

// Config is the only one instance holding configuration
// of this service.
var (
	config  *AppConfig
	private *PrivateConfig
	log     *logger.Logger
)

func init() {
	log = logger.NewLogger("config")
}

// AppConfig is a structure into which config file
// (e.g., config/config.json) is loaded.
type AppConfig struct {
	Logging struct {
		Enable bool   `json:"Enable"`
		Level  string `json:"Level"`
		Host   string `json:"Host"`
	} `json:"Logging"`

	GracefulTermTimeMillis int64
	ChatServerConfig       struct {
		Host string `json:"Host"`
		Port int    `json:"Port"`
	} `json:"ChatServerConfig"`
	AuthServerConfig struct {
		Host                  string `json:"Host"`
		Port                  int    `json:"Port"`
		OAuthCallbackEndpoint string `json:"OAuthCallbackEndpoint"`
	} `json:"AuthServerConfig"`
	LobbyServerConfig struct {
		Host string `json:"Host"`
		Port int    `json:"Port"`
	} `json:"LobbyServerConfig"`
}

// PrivateConfig is a structure into which config file
// (e.g., config/private.json) is loaded.
type PrivateConfig struct {
	Auth struct {
		ClientID     string `json:"ClientID"`
		ClientSecret string `json:"ClientSecret"`
		JwtSecret    string `json:"JwtSecret"`
	} `json:"Auth"`
	DB struct {
		Host     string `json:"Host"`
		Port     int    `json:"Port"`
		User     string `json:"User"`
		Password string `json:"Password"`
		Database string `json:"Database"`
	} `json:"DB"`
}

// GetPrivateConfigInstance returns the pointer to the singleton instance of Config
func GetPrivateConfigInstance() *PrivateConfig {
	if private == nil {
		private = &PrivateConfig{}
	}
	return private
}

// GetAppConfigInstance returns the pointer to the singleton instance of Config
func GetAppConfigInstance() *AppConfig {
	if config == nil {
		config = &AppConfig{}
	}
	return config
}

// LoadAppConfig reads config file (e.g., configs/config.json) and
// unmarshalls JSON string in it into Config structure
func (AppConfig) LoadAppConfig(fname string) bool {
	log.D("LoadAppConfig from the file \"" + fname + "\".")

	b, err := os.ReadFile(fname)
	if err != nil {
		log.E("%v", err)
		return false
	}

	errCode := json.Unmarshal(b, &config)
	log.D("appConfig: %v , err: %v", config, errCode)

	return true
}

// LoadPrivateConfig reads config file (e.g., configs/config.json) and
// unmarshalls JSON string in it into Config structure
func (PrivateConfig) LoadPrivateConfig(fname string) bool {
	log.D("LoadPrivateConfig from the file \"" + fname + "\".")

	b, err := os.ReadFile(fname)
	if err != nil {
		log.E("%v", err)
		return false
	}

	errCode := json.Unmarshal(b, &private)
	log.D("privateConfig: %v , err: %v", private, errCode)

	return true
}
