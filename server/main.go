package main

import (
	"fmt"
	auth "mars-go-service/internal/auth"
	"mars-go-service/internal/auth/discord"
	chat "mars-go-service/internal/chat"
	"mars-go-service/internal/config"
	"mars-go-service/internal/db"
	lobby "mars-go-service/internal/lobby"
	"mars-go-service/internal/logger"
	utils "mars-go-service/internal/utils"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"golang.org/x/oauth2"
)

var log *logger.Logger

func init() {
	log = logger.NewLogger("main_logger")
}

func main() {
	log.I("Starting service ...")
	err := Initialize()
	if err != nil {
		log.E("Failed to initialize service: %v", err)
		os.Exit(1)
	}

	conf := config.GetAppConfigInstance()
	pConf := config.GetPrivateConfigInstance()

	authConf := &oauth2.Config{
		RedirectURL:  fmt.Sprintf("%v:%v%v", *conf.AuthServerConfig.Host, *conf.AuthServerConfig.Port, *conf.AuthServerConfig.OAuthCallbackEndpoint),
		ClientID:     *pConf.Auth.ClientID,
		ClientSecret: *pConf.Auth.ClientSecret,
		Scopes:       []string{discord.ScopeIdentify},
		Endpoint:     discord.Endpoint,
	}
	gameForCheckChannel := make(chan string)
	go func() {
		err = StartChatService(conf, *pConf.Auth.JwtSecret, authConf, &gameForCheckChannel)
		if err != nil {
			log.E("Failed to start chat service: %v", err)
			os.Exit(1)
		}
	}()
	go func() {
		err = StartLobbyService(conf, *pConf.Auth.JwtSecret, authConf, &gameForCheckChannel)
		if err != nil {
			log.E("Failed to start lobby service: %v", err)
			os.Exit(1)
		}
	}()

	go func() {
		http.Handle("/", http.FileServer(http.Dir("./web")))
		utils.ListenAndServe(":8080", nil)
	}()

	err = StartAuthService(conf, *pConf.Auth.JwtSecret, authConf)
	if err != nil {
		log.E("Failed to start auth service: %v", err)
		os.Exit(1)
	}

	log.E("Exiting service ...")
}

// Initialize initializes DB and updates DB tables.
func Initialize() error {
	log.I("initiate the service...")
	// Configuration loading
	var configFileName string = "configs/config.json"

	conf := config.GetAppConfigInstance()
	if !conf.LoadAppConfig(configFileName) {
		log.E("Failed to load config file: %s", configFileName)
		os.Exit(1)
	}

	// Configuration loading
	var privateConfigFileName string = "configs/private.json"

	pConf := config.GetPrivateConfigInstance()
	if !pConf.LoadPrivateConfig(privateConfigFileName) {
		log.E("Failed to load private config file: %s", privateConfigFileName)
		os.Exit(1)
	}
	log.I("Configuration has been loaded.")
	dbUrl := fmt.Sprintf("postgres://postgres:%v@%v:%v/%v", *pConf.DB.Password, *pConf.DB.Host, *pConf.DB.Port, *pConf.DB.Database)
	err := db.InitDB(dbUrl)
	if err != nil {
		log.E("Failed to initialize DB: %v", err)
		os.Exit(1)
	}

	// Setup log level
	logger.SetupLogger(*conf.Logging.Enable, *conf.Logging.Level)

	// Setup signal handlers for interruption and termination
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		for sig := range sigCh {
			if sig == syscall.SIGINT || sig == syscall.SIGTERM {
				log.D("Graceful Termination Time = %d", *conf.GracefulTermTimeMillis)
				time.Sleep(time.Duration(*conf.GracefulTermTimeMillis) * time.Millisecond)
				Finalize()
				os.Exit(ExitFailure)
			}
		}
	}()

	return nil
}

// StartAuthService starts all the component of this service.
func StartAuthService(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config) error {
	log.I("start the auth service...")

	var err error
	if err = auth.InitServer(conf, jwtSecret, authConf); err != nil {
		log.E("Failed to start the auth server: err:[%v]", err)
	}

	return nil
}

// StartAuthService starts all the component of this service.
func StartLobbyService(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config, gameForCheckChannel *chan string) error {
	log.I("start the lobby service...")

	if err := lobby.InitServer(conf, jwtSecret, authConf, gameForCheckChannel); err != nil {
		log.E("Failed to start the lobby server: err:[%v]", err)
	}

	return nil
}

// StartChatService starts all the component of this service.
func StartChatService(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config, gameForCheckChannel *chan string) error {
	log.I("start the chat service...")

	if err := chat.InitServer(conf, jwtSecret, authConf, gameForCheckChannel); err != nil {
		log.E("Failed to start the chat server: err:[%v]", err)
	}

	return nil
}

// Finalize and clean up the service
func Finalize() {
	//	db.Close()
	//	client.Close()
	log.E("Shutdown service...")
}

// ExitSuccess is exit code 0 and ExitFailure is exit code 1
const (
	ExitSuccess = iota
	ExitFailure
)
