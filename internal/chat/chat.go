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
	chatUsersMap map[ /*room*/ string]map[ /*socketId*/ string] /*userId*/ string
	socketsMap   map[string] /*socketId*/ socketio.Conn
	chatRoomsMap map[string] /*socketId*/ []string /*room*/
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
	// save event to db
	// share event to all users in the chat room
	// TODO: add suitable error handling
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
	for soId := range connsState.chatUsersMap[chatRoom] {
		so := connsState.socketsMap[soId]
		go emitEvent(so, string(eventsJson))
	}
}
func emitEvent(so socketio.Conn, eventsJson string) {
	defer func() {
		if panicInfo := recover(); panicInfo != nil {
			fmt.Printf("%v, %s", panicInfo, string(debug.Stack()))
		}
	}()
	so.Emit("events", eventsJson)
}

/*
	func getRoomUserList(chatRoom string) []byte {
		room := connsState.chatUsersMap[chatRoom]
		users := make([]*discord.DiscordUser, len(room))
		for _, user := range room {

			users = append(users, user)
		}
		usersJson, err := json.Marshal(users)
		if err != nil {
			log.E("getRoomUserList json.Marshal error: %v", err)
		}
		return usersJson
	}
*/

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
	roomUsers := connsState.chatUsersMap[chatRoom]
	if roomUsers == nil {
		connsState.chatUsersMap[chatRoom] = make(map[string]string)
	}
	connsState.chatRoomsMap[so.ID()] = append(connsState.chatRoomsMap[so.ID()], chatRoom)
	so.Join(chatRoom)
	sendActualDataToUser(so, chatRoom)
	saveAndShareEvent(JOIN, chatRoom, connsState.chatUsersMap[chatRoom][so.ID()], "")
}

func leaveHandler(so socketio.Conn, chatRoom string, isDisconnect bool) {
	log.D("%v leave %v", so.ID(), chatRoom)
	connsState.chatRoomsMap[so.ID()] = removeSliceElement(connsState.chatRoomsMap[so.ID()], chatRoom)
	userId := connsState.chatUsersMap[chatRoom][so.ID()]
	if !isDisconnect {
		so.Leave(chatRoom)
	}
	delete(connsState.chatUsersMap[chatRoom], so.ID())
	saveAndShareEvent(LEAVE, chatRoom, userId, "")
}

func removeSliceElement(s []string, elem string) []string {
	index := -1
	for k, v := range s {
		if elem == v {
			index = k
			break
		}
	}
	if index == -1 {
		return s
	} else {
		return append(s[:index], s[index+1:]...)
	}
}

// InitServer initializes the server
func InitServer(conf *config.AppConfig, jwtSecret string, authConf *oauth2.Config) error {
	connsState = &connectionsState{
		chatUsersMap: make(map[string] /*room*/ map[string] /*socketId*/ string /*userId*/),
		socketsMap:   make(map[string] /*socketId*/ socketio.Conn),
		chatRoomsMap: make(map[string] /*socketId*/ []string /*room*/),
	}

	socketServer = socketio.NewServer(&engineio.Options{
		ConnInitor: func(r *http.Request, so engineio.Conn) {
			log.D("Chat ConnInitor")
			generalRoomUsers := connsState.chatUsersMap[GENERAL_ROOM]
			if generalRoomUsers == nil {
				connsState.chatUsersMap[GENERAL_ROOM] = make(map[string]string)
			}

			jwtFromRequest := r.URL.Query().Get("jwt")
			userId, err := jwt.GetUserId(jwtFromRequest, []byte(jwtSecret))
			if err != nil {
				log.E("jwt.GetUserId error: %v", err)
			}
			connsState.chatUsersMap[GENERAL_ROOM][so.ID()] = userId
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
		userId := connsState.chatUsersMap[event.ChatRoom][so.ID()]
		log.D("%v, %v chat '%v'", so.ID(), userId, event.ChatRoom, event.Text)
		saveAndShareEvent(MESSAGE, event.ChatRoom, userId, event.Text)
	})

	socketServer.OnEvent("/", "leave", func(so socketio.Conn, chatRoom string) {
		leaveHandler(so, chatRoom, false)
	})

	socketServer.OnDisconnect("/", func(so socketio.Conn, reason string) {
		for _, room := range connsState.chatRoomsMap[so.ID()] {
			leaveHandler(so, room, true)
		}
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
