package config

import (
	"encoding/json"
	"mars-go-service/internal/logger"
	"os"
	"strconv"
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
		Enable *bool   `json:"Enable"`
		Level  *string `json:"Level"`
	} `json:"Logging"`

	GracefulTermTimeMillis *int64
	ChatServerConfig       struct {
		Port *int `json:"Port"`
	} `json:"ChatServerConfig"`
	AuthServerConfig struct {
		Host                  *string `json:"Host"`
		Port                  *int    `json:"Port"`
		OAuthCallbackEndpoint *string `json:"OAuthCallbackEndpoint"`
	} `json:"AuthServerConfig"`
	LobbyServerConfig struct {
		Port *int `json:"Port"`
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
		Port     *int    `json:"Port"`
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
		loadAppConfigFromEnvirement()
	} else {
		errCode := json.Unmarshal(b, &config)
		if errCode != nil {
			log.E("Failed to unmarshal config file: %s", fname)
			return false
		}
	}
	if config.ChatServerConfig.Port == nil {
		log.E("CHAT_PORT is not set")
		return false
	}
	if config.AuthServerConfig.Host == nil {
		log.E("AUTH_CHAT_LOBBY_HOST is not set")
		return false
	}
	if config.AuthServerConfig.Port == nil {
		log.E("AUTH_PORT is not set")
		return false
	}
	if config.AuthServerConfig.OAuthCallbackEndpoint == nil {
		log.E("AUTH_SERVER_OAUTH_CALLBACK_ENDPOINT is not set")
		return false
	}
	if config.LobbyServerConfig.Port == nil {
		log.E("LOBBY_PORT is not set")
		return false
	}
	if config.Logging.Enable == nil {
		log.E("SERVER_LOGGING_ENABLED is not set")
		return false
	}
	if config.Logging.Level == nil {
		log.E("SERVER_LOGGING_LEVEL is not set")
		return false
	}
	if config.GracefulTermTimeMillis == nil {
		log.E("GRACEFUL_TERM_TIME_MILLIS is not set")
		return false
	}

	log.D("appConfig: %v", config)
	return true
}

func loadAppConfigFromEnvirement() {
	config = GetAppConfigInstance()
	LOGGING_ENABLED := os.Getenv("SERVER_LOGGING_ENABLED")
	if LOGGING_ENABLED != "" {
		enabled, err := strconv.ParseBool(LOGGING_ENABLED)
		if err != nil {
			log.E("Failed to parse LOGGING_ENABLED: %s", LOGGING_ENABLED)
			return
		}
		config.Logging.Enable = &enabled
	}
	LOGGING_LEVEL := os.Getenv("SERVER_LOGGING_LEVEL")
	if LOGGING_LEVEL != "" {
		config.Logging.Level = &LOGGING_LEVEL
	}
	GRACEFUL_TERM_TIME_MILLIS := os.Getenv("GRACEFUL_TERM_TIME_MILLIS")
	if GRACEFUL_TERM_TIME_MILLIS != "" {
		millis, err := strconv.ParseInt(GRACEFUL_TERM_TIME_MILLIS, 10, 64)
		if err != nil {
			log.E("Failed to parse GRACEFUL_TERM_TIME_MILLIS: %s", GRACEFUL_TERM_TIME_MILLIS)
			return
		}
		config.GracefulTermTimeMillis = &millis
	}
	CHAT_SERVER_PORT := os.Getenv("CHAT_PORT")
	if CHAT_SERVER_PORT != "" {
		port, err := strconv.ParseInt(CHAT_SERVER_PORT, 10, 0)
		if err != nil {
			log.E("Failed to parse CHAT_PORT: %s", CHAT_SERVER_PORT)
			return
		}
		p := int(port)
		config.ChatServerConfig.Port = &p
	}
	AUTH_SERVER_HOST := os.Getenv("AUTH_CHAT_LOBBY_HTTP_HOST")
	if AUTH_SERVER_HOST != "" {
		config.AuthServerConfig.Host = &AUTH_SERVER_HOST
	}
	AUTH_SERVER_PORT := os.Getenv("AUTH_PORT")
	if AUTH_SERVER_PORT != "" {
		port, err := strconv.ParseInt(AUTH_SERVER_PORT, 10, 0)
		if err != nil {
			log.E("Failed to parse AUTH_PORT: %s", AUTH_SERVER_PORT)
			return
		}
		p := int(port)
		config.AuthServerConfig.Port = &p
	}
	AUTH_SERVER_OAUTH_CALLBACK_ENDPOINT := os.Getenv("AUTH_SERVER_OAUTH_CALLBACK_ENDPOINT")
	if AUTH_SERVER_OAUTH_CALLBACK_ENDPOINT != "" {
		config.AuthServerConfig.OAuthCallbackEndpoint = &AUTH_SERVER_OAUTH_CALLBACK_ENDPOINT
	}
	LOBBY_SERVER_PORT := os.Getenv("LOBBY_PORT")
	if LOBBY_SERVER_PORT != "" {
		port, err := strconv.ParseInt(LOBBY_SERVER_PORT, 10, 0)
		if err != nil {
			log.E("Failed to parse LOBBY_PORT: %s", LOBBY_SERVER_PORT)
			return
		}
		p := int(port)
		config.LobbyServerConfig.Port = &p
	}
}

// LoadPrivateConfig reads config file (e.g., configs/config.json) and
// unmarshalls JSON string in it into Config structure
func (PrivateConfig) LoadPrivateConfig(fname string) bool {
	log.D("LoadPrivateConfig from the file \"" + fname + "\".")

	b, err := os.ReadFile(fname)
	if err != nil {
		loadPrivateConfigFromEnvirement()
	} else {
		errCode := json.Unmarshal(b, &private)
		if errCode != nil {
			log.E("Failed to unmarshal private config file: %s", fname)
			return false
		}
	}
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
	log.D("privateConfig: %v", private)
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
		port, err := strconv.ParseInt(DB_PORT, 10, 0)
		if err != nil {
			log.E("Failed to parse DB_PORT: %s", DB_PORT)
			return
		}
		p := int(port)
		private.DB.Port = &p
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
