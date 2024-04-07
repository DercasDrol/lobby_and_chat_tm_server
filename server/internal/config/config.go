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
	} `json:"Logging"`

	GracefulTermTimeMillis int64
	ChatServerConfig       struct {
		Port int `json:"Port"`
	} `json:"ChatServerConfig"`
	AuthServerConfig struct {
		Port                  int    `json:"Port"`
		OAuthCallbackEndpoint string `json:"OAuthCallbackEndpoint"`
	} `json:"AuthServerConfig"`
	LobbyServerConfig struct {
		Port int `json:"Port"`
	} `json:"LobbyServerConfig"`
}

// PrivateConfig is a structure into which config file
// (e.g., config/private.json) is loaded.
type PrivateConfig struct {
	Auth struct {
		ClientID     *string `json:"ClientID"`
		ClientSecret *string `json:"ClientSecret"`
		JwtSecret    *string `json:"JwtSecret"`
	} `json:"Auth"`
	DB struct {
		Host     *string `json:"Host"`
		Port     *string `json:"Port"`
		User     *string `json:"User"`
		Password *string `json:"Password"`
		Database *string `json:"Database"`
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
		loadPrivateConfigFromEnvirement()
		if private.Auth.ClientID == nil {
			log.E("DISCORD_CLIENT_ID is not set")
			return false
		}
		if private.Auth.ClientSecret == nil {
			log.E("DISCORD_CLIENT_SECRET is not set")
			return false
		}
		if private.Auth.JwtSecret == nil {
			log.E("AUTH_JWT_SECRET is not set")
			return false
		}
		if private.DB.Host == nil {
			log.E("DB_HOST is not set")
			return false
		}
		if private.DB.Port == nil {
			log.E("DB_PORT is not set")
			return false
		}
		if private.DB.User == nil {
			log.E("DB_USER is not set")
			return false
		}
		if private.DB.Password == nil {
			log.E("DB_PASSWORD is not set")
			return false
		}
		if private.DB.Database == nil {
			log.E("DB_NAME is not set")
			return false
		}
		return true
	}

	errCode := json.Unmarshal(b, &private)
	log.D("privateConfig: %v , err: %v", private, errCode)

	return true
}

func loadPrivateConfigFromEnvirement() {
	private = GetPrivateConfigInstance()
	DISCORD_CLIENT_ID := os.Getenv("DISCORD_CLIENT_ID")
	if DISCORD_CLIENT_ID != "" {
		private.Auth.ClientID = &DISCORD_CLIENT_ID
	}
	DISCORD_CLIENT_SECRET := os.Getenv("DISCORD_CLIENT_SECRET")
	if DISCORD_CLIENT_SECRET != "" {
		private.Auth.ClientSecret = &DISCORD_CLIENT_SECRET
	}
	AUTH_JWT_SECRET := os.Getenv("AUTH_JWT_SECRET")
	if AUTH_JWT_SECRET != "" {
		private.Auth.JwtSecret = &AUTH_JWT_SECRET
	}
	DB_HOST := os.Getenv("DB_HOST")
	if DB_HOST != "" {
		private.DB.Host = &DB_HOST
	}
	DB_PORT := os.Getenv("DB_PORT")
	if DB_PORT != "" {
		private.DB.Port = &DB_PORT
	}
	DB_USER := os.Getenv("DB_USER")
	if DB_USER != "" {
		private.DB.User = &DB_USER
	}
	DB_PASSWORD := os.Getenv("DB_PASSWORD")
	if DB_PASSWORD != "" {
		private.DB.Password = &DB_PASSWORD
	}
	DB_NAME := os.Getenv("DB_NAME")
	if DB_NAME != "" {
		private.DB.Database = &DB_NAME
	}
}
