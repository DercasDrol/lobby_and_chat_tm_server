package server

import (
	"fmt"
	"mars-go-service/internal/auth/jwt"
	"mars-go-service/internal/config"
	"mars-go-service/internal/db"
	"mars-go-service/internal/logger"
	"mars-go-service/internal/utils"
	"net/http"
	"runtime/debug"
	"strconv"
	"sync"

	"encoding/json"

	socketio "github.com/googollee/go-socket.io"
	"github.com/googollee/go-socket.io/engineio"
	"golang.org/x/oauth2"
)

type connectionsState struct {
	socketIdUserIdMap *sync.Map //map[ /*socketId*/ string] /*userId*/ string
	socketsMap        *sync.Map //map[string] /*socketId*/ *socketio.Conn
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
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("createHandler userId not found")
		return
	}
	//create new game
	lobbyGame, err := db.InsertNewGameSettings(userId.(string), newGameConfig)
	if err != nil {
		log.E("createHandler db.InsertNewGameAndGetInsertedIdBack error: %v", err)
		return
	}
	if lobbyGame.SharedAt == nil {
		sendGamesToOneUser(so, lobbyGame)
	} else {
		broadcastGame(lobbyGame)
	}
}

func sendGamesToOneUser(so socketio.Conn, lobbyGame *db.LobbyGame) {
	games := make([]*db.LobbyGame, 1)
	games[0] = lobbyGame
	gamesJson, err := json.Marshal(games)
	if err != nil {
		log.E("broadcastGames json.Marshal error: %v", err)
		return
	}
	go emitGames(so, string(gamesJson))
}

func broadcastGame(game *db.LobbyGame) {
	games := make([]*db.LobbyGame, 1)
	games[0] = game

	broadcastGames(games)
}

func broadcastGames(games []*db.LobbyGame) {
	gamesJson, err := json.Marshal(games)
	if err != nil {
		log.E("broadcastGames json.Marshal error: %v", err)
		return
	}
	//BroadcastToRoom sends one by one and waits for the response
	//some connections may be closed from client side but not disconected on server side (refresh page, close tab, etc)
	//because BroadcastToRoom waits for the response from each connection, it may take a long time
	connsState.socketIdUserIdMap.Range(func(soId, _ interface{}) bool {
		so0, ok := connsState.socketsMap.Load(soId.(string))
		if ok {
			so1 := *so0.(*socketio.Conn)
			go emitGames(so1, string(gamesJson))
		}
		return true
	})
}

func updateHandler(so socketio.Conn, lobbyGameJson string) {
	log.D("%v", lobbyGameJson)
	lobbyGameToUpdate := &db.LobbyGame{}
	err := json.Unmarshal([]byte(lobbyGameJson), lobbyGameToUpdate)
	if err != nil {
		log.E("json.Unmarshal(NewGameConfig) error: %v", err)
		return
	}
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("updateHandler userId not found")
		return
	}

	if lobbyGameToUpdate.UserIdCreatedBy == userId.(string) {
		log.D("%v, %v save_changed_options '%v'", so.ID(), userId.(string), lobbyGameToUpdate.NewGameConfig, lobbyGameToUpdate.UserIdCreatedBy)
		//update new game settings
		lobbyGame, err := db.UpdateNewGameSettings(userId.(string), *lobbyGameToUpdate)
		if err != nil {
			log.E("updateHandler db.UpdateNewGameSettings error: %v", err)
			return
		}
		if lobbyGame.SharedAt == nil {
			sendGamesToOneUser(so, lobbyGame)
		} else {
			broadcastGame(lobbyGame)
		}
	} else {
		log.E("updateHandler userId %v != lobbyGameToUpdate.UserIdCreatedBy %v", userId.(string), lobbyGameToUpdate.UserIdCreatedBy)
	}
}

func deleteHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v delete %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("deleteHandler userId not found")
		return
	}
	deleteGame(userId.(string), lobbyGameId)

}

func deleteGame(userId string, lobbyGameId string) {
	err := db.DeleteGame(userId, lobbyGameId)
	if err != nil {
		log.E("deleteHandler db.DeleteGame error: %v", err)
		return
	}
	connsState.socketIdUserIdMap.Range(func(soId, _ interface{}) bool {
		so0, ok := connsState.socketsMap.Load(soId.(string))
		if ok {
			so1 := *so0.(*socketio.Conn)
			go so1.Emit("deleted_game", lobbyGameId)
		}
		return true
	})
}

func leaveOrDeleteNotStartedGamesHandler(userId string) {
	lobbyGames, err := db.GetNotStartedGames(userId)
	if err != nil {
		log.E("leaveOrDeleteNotStartedGamesHandler db.GetNotStartedGames error: %v", err)
		return
	}
	for _, lobbyGame := range lobbyGames {
		gameId := strconv.Itoa(lobbyGame.LobbyGameid)
		if lobbyGame.UserIdCreatedBy == userId {
			deleteGame(userId, gameId)
		} else {
			leaveGame(userId, gameId)
		}
	}
}

func shareGameHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v share %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("shareGameHandler userId not found")
		return
	}

	//share game
	lobbyGame, err := db.ShareGame(userId.(string), lobbyGameId)
	if err != nil {
		log.E("shareGameHandler db.ShareGame error: %v", err)
		return
	}
	broadcastGame(lobbyGame)
}

func startGameHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v start game %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("startGameHandler userId not found")
		return
	}

	//start game
	lobbyGame, err := db.StartGame(userId.(string), lobbyGameId)
	if err != nil {
		log.E("startGameHandler db.StartGame error: %v", err)
		return
	}
	broadcastGame(lobbyGame)
}

func joinGameHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v join game %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("joinGameHandler userId not found")
		return
	}

	//join game
	lobbyGame, err := db.JoinGame(userId.(string), lobbyGameId)
	if err != nil {
		log.E("joinGameHandler db.JoinGame error: %v", err)
		return
	}
	broadcastGame(lobbyGame)
}

func leaveGameHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v leave game %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("leaveGameHandler userId not found")
		return
	}
	leaveGame(userId.(string), lobbyGameId)
}

func leaveGame(userId string, lobbyGameId string) {
	lobbyGame, err := db.LeaveGame(userId, lobbyGameId)
	if err != nil {
		log.E("leaveGame db.LeaveGame error: %v", err)
		return
	}
	broadcastGame(lobbyGame)
}

func loadGamesHandler(so socketio.Conn) {
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("loadGamesHandler userId not found")
		return
	}
	lobbyGames, err := db.GetLobbyGames(userId.(string))
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

func changePlayerColorHandler(so socketio.Conn, lobbyGame string) {
	log.D("%v changePlayerColor %v", so.ID(), lobbyGame)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("changePlayerColorHandler userId not found")
		return
	}
	lobbyGameToUpdate := &db.LobbyGame{}
	err := json.Unmarshal([]byte(lobbyGame), lobbyGameToUpdate)
	if err != nil {
		log.E("json.Unmarshal(LobbyGame) error: %v", err)
		return
	}
	//change player color
	lobbyGameUpdated, err := db.ChangePlayerColor(lobbyGameToUpdate, userId.(string))
	if err != nil {
		log.E("changePlayerColorHandler db.ChangePlayerColor error: %v", err)
		return
	}
	broadcastGame(lobbyGameUpdated)
}

func loadPlayerHandler(so socketio.Conn, lobbyGameId string) {
	log.D("%v loadPlayerHandler %v", so.ID(), lobbyGameId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("loadPlayerIdHandler userId not found")
		return
	}
	player, err := db.GetPlayer(lobbyGameId, userId.(string))
	if err != nil {
		log.E("loadPlayerIdHandler db.GetLobbyGame error: %v", err)
		return
	}
	playerJson, err := json.Marshal(player)
	if err != nil {
		log.E("loadPlayerIdHandler json.Marshal error: %v", err)
		return
	}
	so.Emit("player", string(playerJson))
}

func updateGameStatusHandler(lobbyGameId string) {
	log.D("updateGameStatusHandler %v", lobbyGameId)
	lobbyGameToUpdate, err := db.GetLobbyGame(lobbyGameId)
	if err != nil {
		log.E("updateGameStatusHandler GetLobbyGame error: %v", err)
		return
	}

	if lobbyGameToUpdate.StartedAt != nil {
		updated, err := db.UpdateGameStatus(lobbyGameToUpdate)
		if err != nil {
			log.E("updateGameStatusHandler db.UpdateGameStatus error: %v", err)
			return
		}
		if updated {
			if lobbyGameToUpdate.SharedAt == nil {
				connsState.socketIdUserIdMap.Range(func(soId, userId interface{}) bool {
					if userId == lobbyGameToUpdate.UserIdCreatedBy {
						so, ok := connsState.socketsMap.Load(soId.(string))
						if !ok {
							log.E("updateGameStatusHandler so not found")
							return false
						}
						sendGamesToOneUser(*so.(*socketio.Conn), lobbyGameToUpdate)
						return false
					}
					return true
				})
			} else {
				broadcastGame(lobbyGameToUpdate)
			}
		}
	} else {
		log.E("updateGameStatusHandler: game not started")
	}
}

func sendGameTemplate(so socketio.Conn, template *db.GameTemplate) {
	templates := make([]*db.GameTemplate, 1)
	templates[0] = template
	templatesJson, err := json.Marshal(templates)
	if err != nil {
		log.E("sendGameTemplate json.Marshal error: %v", err)
		return
	}
	so.Emit("game_templates", string(templatesJson))
}

func loadGameTemplatesHandler(so socketio.Conn) {
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("loadGameTemplatesHandler userId not found")
		return
	}
	gameTemplates, err := db.GetGameTemplates(userId.(string))
	if err != nil {
		log.E("loadGameTemplatesHandler db.GetGameTemplates error: %v", err)
		return
	}
	gameTemplatesJson, err := json.Marshal(gameTemplates)
	if err != nil {
		log.E("loadGameTemplatesHandler json.Marshal error: %v", err)
		return
	}
	so.Emit("game_templates", string(gameTemplatesJson))
}

func saveGameTemplatesHandler(so socketio.Conn, gameTemplateString string) {
	log.D("%v saveGameTemplatesHandler %v", so.ID(), gameTemplateString)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("saveGameTemplatesHandler userId not found")
		return
	}
	gameTemplate := &db.GameTemplate{}
	err := json.Unmarshal([]byte(gameTemplateString), gameTemplate)
	if err != nil {
		log.E("saveGameTemplatesHandler json.Unmarshal error: %v", err)
		return
	}

	template, err := db.SaveGameTemplate(userId.(string), *gameTemplate)
	if err != nil {
		log.E("saveGameTemplatesHandler db.SaveGameTemplate error: %v", err)
		return
	}
	sendGameTemplate(so, template)
}

func updateGameTemplateHandler(so socketio.Conn, gameTemplateString string) {
	log.D("%v updateGameTemplatesHandler %v", so.ID(), gameTemplateString)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("updateGameTemplatesHandler userId not found")
		return
	}
	gameTemplate := &db.GameTemplate{}
	err := json.Unmarshal([]byte(gameTemplateString), gameTemplate)
	if err != nil {
		log.E("updateGameTemplatesHandler json.Unmarshal error: %v", err)
		return
	}

	template, err := db.UpdateGameTemplate(userId.(string), *gameTemplate)
	if err != nil {
		log.E("updateGameTemplatesHandler db.UpdateGameTemplate error: %v", err)
		return
	}
	sendGameTemplate(so, template)
}

func deleteGameTemplateHandler(so socketio.Conn, gameTemplateId string) {
	log.D("%v deleteGameTemplateHandler %v", so.ID(), gameTemplateId)
	userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
	if !ok {
		log.E("deleteGameTemplateHandler userId not found")
		return
	}
	id, err := db.DeleteGameTemplate(userId.(string), gameTemplateId)
	if err != nil {
		log.E("deleteGameTemplateHandler db.DeleteGameTemplate error: %v", err)
		return
	}
	so.Emit("deleted_game_template", id)
}

// InitServer initializes the server
func InitServer(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config, gameForCheckChannel *chan string) error {
	connsState = &connectionsState{
		socketIdUserIdMap: &sync.Map{},
		socketsMap:        &sync.Map{},
	}

	socketServer = socketio.NewServer(&engineio.Options{
		ConnInitor: func(r *http.Request, so engineio.Conn) {
			log.D("Lobby ConnInitor")
			jwtFromRequest := r.URL.Query().Get("jwt")
			userId, err := jwt.GetUserId(jwtFromRequest, []byte(jwtSecret))
			if err != nil {
				log.E("jwt.GetUserId error: %v", err)
			}
			connsState.socketIdUserIdMap.Store(so.ID(), userId)
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
		connsState.socketsMap.Store(so.ID(), &so)

		return nil
	})

	socketServer.OnError("/", func(so socketio.Conn, e error) {
		log.E("meet error:", e)
	})

	socketServer.OnEvent("/", "create_new_game", createHandler)

	socketServer.OnEvent("/", "save_changed_options", updateHandler)

	socketServer.OnEvent("/", "delete_game", deleteHandler)

	socketServer.OnEvent("/", "share_game", shareGameHandler)

	socketServer.OnEvent("/", "start_game", startGameHandler)

	socketServer.OnEvent("/", "join_game", joinGameHandler)

	socketServer.OnEvent("/", "leave_game", leaveGameHandler)

	socketServer.OnEvent("/", "load_games", loadGamesHandler)

	socketServer.OnEvent("/", "change_player_color", changePlayerColorHandler)

	socketServer.OnEvent("/", "load_player", loadPlayerHandler)

	socketServer.OnEvent("/", "load_game_templates", loadGameTemplatesHandler)

	socketServer.OnEvent("/", "save_game_template", saveGameTemplatesHandler)

	socketServer.OnEvent("/", "update_game_template", updateGameTemplateHandler)

	socketServer.OnEvent("/", "delete_game_template", deleteGameTemplateHandler)

	socketServer.OnDisconnect("/", func(so socketio.Conn, reason string) {
		log.D("disconnected... %v, by %v", so.ID(), reason)
		userId, ok := connsState.socketIdUserIdMap.Load(so.ID())
		connsState.socketIdUserIdMap.Delete(so.ID())
		connsState.socketsMap.Delete(so.ID())
		if ok {
			existsSocketWithSameUserId := false
			log.D("looking for userId from other connections: %v", userId)
			connsState.socketIdUserIdMap.Range(func(_, userId0 interface{}) bool {
				if userId == userId0 {
					log.D("existsSocketWithSameUserId %v", userId0)
					existsSocketWithSameUserId = true
					return false
				}
				return true
			})
			if !existsSocketWithSameUserId {
				log.D("call leaveOrDeleteNotStartedGamesHandler %v", userId)
				leaveOrDeleteNotStartedGamesHandler(userId.(string))
			}
		}
	})
	go func() {
		log.D("StartGameForCheckGorutine")
		for gameForCheck := range *gameForCheckChannel {
			log.D("gameForCheck: %v", gameForCheck)
			updateGameStatusHandler(gameForCheck)
		}
	}()
	go func() {
		if err := socketServer.Serve(); err != nil {
			log.E("socketio listen error: %s\n", err)
		}
	}()
	defer socketServer.Close()
	httpServeMux := http.NewServeMux()

	httpServeMux.HandleFunc("/socket.io/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*") //*conf.AuthServerConfig.Host)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Authorization, Content-Type, Content-Length, X-CSRF-Token, Token, session, Origin, Host, Connection, Accept-Encoding, Accept-Language, X-Requested-With")
		socketServer.ServeHTTP(w, r)
	})

	log.I("Serving at %v", *conf.LobbyServerConfig.Port)
	log.E("%v", utils.ListenAndServe(fmt.Sprintf(":%v", *conf.LobbyServerConfig.Port), httpServeMux))
	return nil
}
