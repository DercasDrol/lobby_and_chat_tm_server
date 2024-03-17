package server

import (
	"fmt"
	"mars-go-service/internal/auth/jwt"
	"mars-go-service/internal/config"
	"mars-go-service/internal/db"
	"mars-go-service/internal/logger"
	"net/http"
	"runtime/debug"
	"sync"

	"encoding/json"

	socketio "github.com/googollee/go-socket.io"
	"github.com/googollee/go-socket.io/engineio"
	"golang.org/x/oauth2"
)

type connectionsState struct {
	soIdToUserIdMap *sync.Map //map[string] /*socketId*/ string          /*userId*/
	roomToSoIdsMap  *sync.Map //map[string] /*room*/ map[string]struct{} /*socketId*/
	soIdToConnMap   *sync.Map //map[string] /*socketId*/ *socketio.Conn
	soIdToRoomsMap  *sync.Map //map[string] /*socketId*/ map[string]struct{} /*room*/
}

var (
	log          *logger.Logger
	connsState   *connectionsState
	socketServer *socketio.Server
)

const (
	JOIN         db.EventType = "join"
	LEAVE        db.EventType = "leave"
	MESSAGE      db.EventType = "message"
	GENERAL_ROOM              = "General"
)

func init() {
	log = logger.NewLogger("chat_server")
}

func saveAndShareEvent(evtType db.EventType, chatRoom string, userId string, text string) {
	id, created_at, err := db.InsertNewEventAndGetInsertedIdBack(userId, text, fmt.Sprint(evtType), chatRoom)
	if err != nil {
		log.E("saveAndShareEvent db.InsertNewEventAndGetInsertedIdBack error: %v", err)
		return
	}
	event := &db.Event{
		Id:        *id,
		EvtType:   evtType,
		ChatRoom:  chatRoom,
		UserId:    userId,
		Timestamp: *created_at,
		Text:      text,
	}
	events := make([]*db.Event, 1)
	events[0] = event
	eventsJson, err := json.Marshal(events)
	if err != nil {
		log.E("saveAndShareEvent json.Marshal error: %v", err)
		return
	}

	//BroadcastToRoom sends one by one and waits for the response
	//some connections may be closed from client side but not disconected on server side (refresh page, close tab, etc)
	//because BroadcastToRoom waits for the response from each connection, it may take a long time
	soIdMap, ok := connsState.roomToSoIdsMap.Load(chatRoom)
	if !ok {
		log.E("saveAndShareEvent connsState.roomToSoIdsMap.Load error: %v", chatRoom)
		return
	}
	soIdMap0 := soIdMap.(*sync.Map)
	soIdMap0.Range(func(key, value interface{}) bool {
		soId := key.(string)
		so, ok := connsState.soIdToConnMap.Load(soId)
		if !ok {
			log.E("saveAndShareEvent connsState.soIdToConnMap.Load error: %v", soId)
			return true
		}
		if so != nil {
			if evtType == JOIN || evtType == LEAVE {
				chatUserList := getChatUserList(chatRoom)
				go emitUserIds(*so.(*socketio.Conn), chatUserList)
			}

			go emitEvent(*so.(*socketio.Conn), string(eventsJson))
		}
		return true
	})
}

func getChatUserList(chatRoom string) *ChatUserList {
	soIdsMap, ok := connsState.roomToSoIdsMap.Load(chatRoom)
	if !ok {
		log.E("getChatUserList connsState.roomToSoIdsMap.Load error: %v", chatRoom)
		return nil
	}
	soIdsMap0 := soIdsMap.(*sync.Map)
	usersIds := make([]string, 0)
	soIdsMap0.Range(func(key, value interface{}) bool {
		soId := key.(string)
		userId, ok := connsState.soIdToUserIdMap.Load(soId)
		if !ok {
			log.E("getChatUserList connsState.soIdToUserIdMap.Load error: %v", soId)
			return true
		}
		usersIds = append(usersIds, userId.(string))
		return true
	})
	return &ChatUserList{chatRoom, usersIds}
}

type ChatUserList struct {
	ChatRoom string   `json:"chatRoom"`
	UsersIds []string `json:"usersIds"`
}

func emitUserIds(so socketio.Conn, chatUserList *ChatUserList) {
	chatUserListJson, err := json.Marshal(chatUserList)
	if err != nil {
		log.E("emitUserIds json.Marshal error: %v", err)
		return
	}
	defer func() {
		if panicInfo := recover(); panicInfo != nil {
			fmt.Printf("%v, %s", panicInfo, string(debug.Stack()))
		}
	}()
	so.Emit("online_users_list_changes", string(chatUserListJson))
}

func emitEvent(so socketio.Conn, eventsJson string) {
	defer func() {
		if panicInfo := recover(); panicInfo != nil {
			fmt.Printf("%v, %s", panicInfo, string(debug.Stack()))
		}
	}()
	so.Emit("events", eventsJson)
}

func sendActualDataToUser(so socketio.Conn, chatRoom string) {

	events, err := db.GetEventsByRoom(chatRoom)
	if err != nil {
		log.E("sendActualDataToUser db.GetEventsByRoom error: %v", err)
		return
	}

	eventsJson, err := json.Marshal(events)
	if err != nil {
		log.E("sendActualDataToUser json.Marshal error: %v", err)
		return
	}
	log.D("%v sendActualDataToUser %v", so.ID(), chatRoom)
	go emitEvent(so, string(eventsJson))
}

func joinHandler(so socketio.Conn, chatRoom string) {
	log.D("%v join %v", so.ID(), chatRoom)
	soIdsMap, _ := connsState.roomToSoIdsMap.LoadOrStore(chatRoom, &sync.Map{})
	soIdsMap0 := soIdsMap.(*sync.Map)
	soIdsMap0.Store(so.ID(), struct{}{})

	roomsMap, _ := connsState.soIdToRoomsMap.LoadOrStore(so.ID(), &sync.Map{})
	roomsMap0 := roomsMap.(*sync.Map)
	roomsMap0.Store(chatRoom, struct{}{})

	so.Join(chatRoom)
	sendActualDataToUser(so, chatRoom)
	userId, ok := connsState.soIdToUserIdMap.Load(so.ID())
	if !ok {
		log.E("joinHandler userId not found")
		return
	}
	saveAndShareEvent(JOIN, chatRoom, userId.(string), "")

}

func leaveHandler(so socketio.Conn, chatRoom string, isDisconnect bool) {
	log.D("%v leave %v", so.ID(), chatRoom)

	userId, ok := connsState.soIdToUserIdMap.Load(so.ID())

	if !isDisconnect {
		so.Leave(chatRoom)
	}
	roomsMap, _ := connsState.soIdToRoomsMap.Load(so.ID())
	roomsMap0 := roomsMap.(*sync.Map)
	roomsMap0.Delete(chatRoom)

	soIdsMap, _ := connsState.roomToSoIdsMap.Load(chatRoom)
	soIdsMap0 := soIdsMap.(*sync.Map)
	soIdsMap0.Delete(so.ID())

	if !ok {
		log.E("leaveHandler userId not found")
		return
	}
	saveAndShareEvent(LEAVE, chatRoom, userId.(string), "")
}

func InitServer(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config) error {
	connsState = &connectionsState{
		soIdToUserIdMap: &sync.Map{},
		roomToSoIdsMap:  &sync.Map{},
		soIdToConnMap:   &sync.Map{},
		soIdToRoomsMap:  &sync.Map{},
	}

	socketServer = socketio.NewServer(&engineio.Options{
		ConnInitor: func(r *http.Request, so engineio.Conn) {
			log.D("Chat ConnInitor")
			jwtFromRequest := r.URL.Query().Get("jwt")
			userId, err := jwt.GetUserId(jwtFromRequest, []byte(jwtSecret))
			if err != nil {
				log.E("jwt.GetUserId error: %v", err)
			}
			connsState.soIdToUserIdMap.Store(so.ID(), userId)
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
		connsState.soIdToConnMap.Store(so.ID(), &so)
		return nil
	})

	socketServer.OnError("/", func(so socketio.Conn, e error) {
		log.E("meet error:", e)
	})

	socketServer.OnEvent("/", "join", joinHandler)

	socketServer.OnEvent("/", "chat", func(so socketio.Conn, message []byte) {
		event := &db.Event{}
		err := json.Unmarshal(message, event)
		if err != nil || event.ChatRoom == "" {
			log.E("json.Unmarshal(message) error: %v", err)
			return
		}
		if event.Text == "" {
			log.E("event.Text is empty")
			return
		}
		userId, ok := connsState.soIdToUserIdMap.Load(so.ID())
		if !ok {
			log.E("chat userId not found")
			return
		}
		log.D("%v, %v chat '%v'", so.ID(), userId, event.ChatRoom, event.Text)
		saveAndShareEvent(MESSAGE, event.ChatRoom, userId.(string), event.Text)
	})

	socketServer.OnEvent("/", "leave", func(so socketio.Conn, chatRoom string) {
		leaveHandler(so, chatRoom, false)
	})

	socketServer.OnEvent("/", "get_users_infos", func(so socketio.Conn, userIds string) {
		log.D("get_users_infos handler : %v", userIds)
		userIdsArr := []string{}
		err := json.Unmarshal([]byte(userIds), &userIdsArr)
		if err != nil {
			log.E("json.Unmarshal(userIds) error: %v", err)
			return
		}
		users, err := db.GetUserInfos(userIdsArr)
		if err != nil {
			log.E("db.GetUserInfos error: %v", err)
			return
		}
		usersJson, err := json.Marshal(users)
		if err != nil {
			log.E("json.Marshal(users) error: %v", err)
			return
		}
		so.Emit("users_infos", string(usersJson))
		log.D("users_infos emitted : %v", string(usersJson))
	})

	socketServer.OnDisconnect("/", func(so socketio.Conn, reason string) {
		roomsMap, ok := connsState.soIdToRoomsMap.Load(so.ID())
		if !ok {
			log.E("soIdToRoomsMap not found")
			return
		}
		roomsMap0 := roomsMap.(*sync.Map)
		roomsMap0.Range(func(key, value interface{}) bool {
			room := key.(string)
			leaveHandler(so, room, true)
			return true
		})
		connsState.soIdToUserIdMap.Delete(so.ID())
		connsState.soIdToConnMap.Delete(so.ID())
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

	log.I("Serving at %v:%v", conf.ChatServerConfig.Host, conf.ChatServerConfig.Port)
	log.E("%v", http.ListenAndServe(fmt.Sprintf(":%v", conf.ChatServerConfig.Port), httpServeMux))

	return nil
}
