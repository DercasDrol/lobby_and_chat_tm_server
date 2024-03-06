package server

import (
	"fmt"
	"mars-go-service/internal/auth/jwt"
	"mars-go-service/internal/config"
	"mars-go-service/internal/db"
	"mars-go-service/internal/logger"
	"net/http"
	"runtime/debug"

	"encoding/json"

	socketio "github.com/googollee/go-socket.io"
	"github.com/googollee/go-socket.io/engineio"
	"golang.org/x/oauth2"
)

type connectionsState struct {
	lobbyUsersMap map[ /*socketId*/ string] /*userId*/ string
	socketsMap    map[string] /*socketId*/ socketio.Conn
	lobbyRoomsMap map[string] /*socketId*/ []string /*room*/
}

var (
	log          *logger.Logger
	connsState   *connectionsState
	socketServer *socketio.Server
)

func init() {
	log = logger.NewLogger("lobby_server")
}

func emitGames(so socketio.Conn, gamesJson string) {
	defer func() {
		if panicInfo := recover(); panicInfo != nil {
			fmt.Printf("%v, %s", panicInfo, string(debug.Stack()))
		}
	}()
	so.Emit("lobby_games", gamesJson)
}

func createHandler(so socketio.Conn, newGameConfig string) {
	log.D("%v creates new game %v", so.ID(), newGameConfig)
	userId := connsState.lobbyUsersMap[so.ID()]
	//create new game
	lobbyGame, err := db.InsertNewGameSettingsAndGetLobbyGameBack(userId, newGameConfig)
	if err != nil {
		log.E("createHandler db.InsertNewGameAndGetInsertedIdBack error: %v", err)
		return
	}

	games := make([]*db.LobbyGame, 1)
	games[0] = lobbyGame
	gamesJson, err := json.Marshal(games)
	if err != nil {
		log.E("createHandler json.Marshal error: %v", err)
		return
	}
	//BroadcastToRoom sends one by one and waits for the response
	//some connections may be closed from client side but not disconected on server side (refresh page, close tab, etc)
	//because BroadcastToRoom waits for the response from each connection, it may take a long time
	for soId := range connsState.lobbyUsersMap {
		so := connsState.socketsMap[soId]
		go emitGames(so, string(gamesJson))
	}
}

func updateHandler(so socketio.Conn, lobbyGameJson string) {
	log.D("%v", lobbyGameJson)
	lobbyGameToUpdate := &db.LobbyGame{}
	err := json.Unmarshal([]byte(lobbyGameJson), lobbyGameToUpdate)
	if err != nil {
		log.E("json.Unmarshal(NewGameConfig) error: %v", err)
		return
	}
	userId := connsState.lobbyUsersMap[so.ID()]
	if lobbyGameToUpdate.UserIdCreatedBy == userId {
		log.D("%v, %v save_changed_options '%v'", so.ID(), userId, lobbyGameToUpdate.NewGameConfig, lobbyGameToUpdate.UserIdCreatedBy)
		userId := connsState.lobbyUsersMap[so.ID()]
		//update new game settings
		lobbyGame, err := db.UpdateNewGameSettingsAndGetLobbyGameBack(userId, *lobbyGameToUpdate)
		if err != nil {
			log.E("updateHandler db.UpdateNewGameSettingsAndGetLobbyGameBack error: %v", err)
			return
		}

		games := make([]*db.LobbyGame, 1)
		games[0] = lobbyGame
		gamesJson, err := json.Marshal(games)
		if err != nil {
			log.E("updateHandler json.Marshal error: %v", err)
			return
		}
		//BroadcastToRoom sends one by one and waits for the response
		//some connections may be closed from client side but not disconected on server side (refresh page, close tab, etc)
		//because BroadcastToRoom waits for the response from each connection, it may take a long time
		for soId := range connsState.lobbyUsersMap {
			so := connsState.socketsMap[soId]
			go emitGames(so, string(gamesJson))
		}
	} else {
		log.E("updateHandler userId %v != lobbyGameToUpdate.UserIdCreatedBy %v", userId, lobbyGameToUpdate.UserIdCreatedBy)
	}
}

func loadAndSendGamesToUser(so socketio.Conn) {
	userId := connsState.lobbyUsersMap[so.ID()]
	lobbyGames, err := db.GetLobbyGames(userId)
	if err != nil {
		log.E("loadAndSendGamesToUser db.GetLobbyGames error: %v", err)
		return
	}
	gamesJson, err := json.Marshal(lobbyGames)
	if err != nil {
		log.E("loadAndSendGamesToUser json.Marshal error: %v", err)
		return
	}
	log.D("%v loadAndSendGamesToUser ", so.ID())
	go emitGames(so, string(gamesJson))
}

// InitServer initializes the server
func InitServer(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config) error {
	connsState = &connectionsState{
		lobbyUsersMap: make(map[string] /*socketId*/ string /*userId*/),
		socketsMap:    make(map[string] /*socketId*/ socketio.Conn),
		lobbyRoomsMap: make(map[string] /*socketId*/ []string /*room*/),
	}

	socketServer = socketio.NewServer(&engineio.Options{
		ConnInitor: func(r *http.Request, so engineio.Conn) {
			log.D("Lobby ConnInitor")
			jwtFromRequest := r.URL.Query().Get("jwt")
			userId, err := jwt.GetUserId(jwtFromRequest, []byte(jwtSecret))
			if err != nil {
				log.E("jwt.GetUserId error: %v", err)
			}
			connsState.lobbyUsersMap[so.ID()] = userId
		},
		RequestChecker: func(r *http.Request) (http.Header, error) {
			jwtFromRequest := r.URL.Query().Get("jwt")
			err := jwt.VerifyJwtToken(jwtFromRequest, []byte(jwtSecret))
			if err != nil {
				log.E("jwt.VerifyJwtToken error: %v", err)
			}
			return nil, err
		},
	})

	socketServer.OnConnect("/", func(so socketio.Conn) error {
		log.D("connected... %v", so.ID())
		connsState.socketsMap[so.ID()] = so
		loadAndSendGamesToUser(so)
		return nil
	})

	socketServer.OnError("/", func(so socketio.Conn, e error) {
		log.E("meet error:", e)
	})

	socketServer.OnEvent("/", "create_new_game", createHandler)

	socketServer.OnEvent("/", "save_changed_options", updateHandler)

	socketServer.OnDisconnect("/", func(so socketio.Conn, reason string) {

		log.D("disconnected... %v, by %v", so.ID(), reason)
	})

	go func() {
		if err := socketServer.Serve(); err != nil {
			log.E("socketio listen error: %s\n", err)
		}
	}()
	defer socketServer.Close()
	httpServeMux := http.NewServeMux()
	httpServeMux.HandleFunc("/socket.io/", func(w http.ResponseWriter, r *http.Request) {
		// origin to excape Cross-Origin Resource Sharing (CORS)
		if origin := r.Header.Get("Origin"); origin != "" {
			w.Header().Set("Access-Control-Allow-Origin", origin)
		}
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Authorization, Content-Type, Content-Length, X-CSRF-Token, Token, session, Origin, Host, Connection, Accept-Encoding, Accept-Language, X-Requested-With")

		socketServer.ServeHTTP(w, r)
	})
	httpServeMux.Handle("/", http.FileServer(http.Dir("./asset")))

	log.I("Serving at %v:%v", conf.LobbyServerConfig.Host, conf.LobbyServerConfig.Port)
	log.E("%v", http.ListenAndServe(fmt.Sprintf(":%v", conf.LobbyServerConfig.Port), httpServeMux))

	return nil
}
