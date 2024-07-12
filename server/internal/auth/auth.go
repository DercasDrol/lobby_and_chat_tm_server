package auth

import (
	"encoding/json"
	"fmt"
	"mars-go-service/internal/config"
	"mars-go-service/internal/db"
	"mars-go-service/internal/utils"

	"mars-go-service/internal/logger"
	"net/http"

	socketio "github.com/googollee/go-socket.io"
	engineio "github.com/googollee/go-socket.io/engineio"

	"context"

	discord "mars-go-service/internal/auth/discord"
	html "mars-go-service/internal/auth/html"
	jwt "mars-go-service/internal/auth/jwt"
	session "mars-go-service/internal/auth/session"

	"golang.org/x/oauth2"
)

type connectionsState struct {
	ConnIdToRequestMap map[string]*http.Request
	ConnIdToConnMap    map[string]socketio.Conn
	StateToConnIdMap   map[string]string
	ConnIdToStateMap   map[string]string
}

var (
	log          *logger.Logger
	connsState   *connectionsState
	httpServeMux *http.ServeMux
	socketServer *socketio.Server
	oAuthConf    *oauth2.Config
	jwtSecret    string
)

func socketConnInitor(r *http.Request, so engineio.Conn) {
	log.D("Auth ConnInitor")
	connsState.ConnIdToRequestMap[so.ID()] = r
	stateFromSession := session.GetStateFromSession(r)
	if stateFromSession == "" {
		state := discord.GenerateRandomState()
		session.SetStateFromSession(r, state)
		connsState.StateToConnIdMap[state] = so.ID()
		connsState.ConnIdToStateMap[so.ID()] = state
	} else {
		connsState.StateToConnIdMap[stateFromSession] = so.ID()
		connsState.ConnIdToStateMap[so.ID()] = stateFromSession
	}
}

func onConnectSocketHandler(so socketio.Conn) error {
	log.D("connected... %v", so.ID())
	connsState.ConnIdToConnMap[so.ID()] = so
	return nil
}

func onLoginSocketHandler(so socketio.Conn) {
	log.D("login")
	r := connsState.ConnIdToRequestMap[so.ID()]
	state := session.GetStateFromSession(r)
	link := oAuthConf.AuthCodeURL(state)
	so.Emit("auth_url", link)
}

func onGameServerSocketHandler(so socketio.Conn) {
	log.D("game_server")
	host, err := db.GetMainGameServer()
	if err != nil {
		log.E("Error getting main game server: %v", err)
		return
	}
	so.Emit("game_server", host)
}

func onDisconnectSocketHandler(so socketio.Conn, reason string) {
	delete(connsState.ConnIdToRequestMap, so.ID())
	delete(connsState.ConnIdToConnMap, so.ID())
	delete(connsState.StateToConnIdMap, connsState.ConnIdToStateMap[so.ID()])
	delete(connsState.ConnIdToStateMap, so.ID())
	log.D("disconnected... %v, by %v", so.ID(), reason)
}

func onErrorSocketHandler(so socketio.Conn, e error) {
	log.E("meet error:", e)
}

func httpOAuthEndpointHandler(w http.ResponseWriter, r *http.Request) {
	state := r.FormValue("state")
	soId := connsState.StateToConnIdMap[state]
	so := connsState.ConnIdToConnMap[soId]
	if so == nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("State does not match."))
		return
	}
	token, err := oAuthConf.Exchange(context.Background(), r.FormValue("code"))

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}
	requestFromSocket := connsState.ConnIdToRequestMap[soId]
	res, err := oAuthConf.Client(context.Background(), token).Get("https://discord.com/api/users/@me")

	if err != nil || res.StatusCode != 200 {
		w.WriteHeader(http.StatusInternalServerError)
		if err != nil {
			w.Write([]byte(err.Error()))
		} else {
			w.Write([]byte(res.Status))
		}
		return
	}

	if requestFromSocket != nil {
		defer res.Body.Close()

		dUser := &discord.DiscordUser{}
		json.NewDecoder(res.Body).Decode(dUser)
		jwtToken, err := jwt.CreateJwtToken(fmt.Sprint(dUser.ID), dUser.Username, []byte(jwtSecret))
		//TODO: add error processing here
		db.InsertOrUpdateUser(dUser.ID, dUser.Username, dUser.Avatar)
		log.D("dUser: %v", dUser)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(err.Error()))
			return
		}
		log.D("so.Emit(\"jwt\" %v", jwtToken)
		so.Emit("jwt", jwtToken)
	}

	w.Write([]byte(html.Success))
}

// InitServer initializes the server
func InitServer(conf *config.AppConfig, jwtSec string, authConf *oauth2.Config) error {
	log = logger.NewLogger("auth_server")
	connsState = &connectionsState{
		ConnIdToRequestMap: make(map[string]*http.Request),
		ConnIdToConnMap:    make(map[string]socketio.Conn),
		StateToConnIdMap:   make(map[string]string),
		ConnIdToStateMap:   make(map[string]string),
	}

	httpServeMux = http.NewServeMux()

	socketServer = socketio.NewServer(&engineio.Options{
		ConnInitor: socketConnInitor,
	})

	oAuthConf = authConf
	jwtSecret = jwtSec

	socketServer.OnConnect("/", onConnectSocketHandler)
	socketServer.OnEvent("/", "login", onLoginSocketHandler)
	socketServer.OnEvent("/", "game_server", onGameServerSocketHandler)
	socketServer.OnDisconnect("/", onDisconnectSocketHandler)
	socketServer.OnError("/", onErrorSocketHandler)

	go func() {
		if err := socketServer.Serve(); err != nil {
			log.E("socketio listen error: %s\n", err)
		}
	}()
	defer socketServer.Close()

	httpServeMux.HandleFunc("/socket.io/", func(w http.ResponseWriter, r *http.Request) {
		// origin to excape Cross-Origin Resource Sharing (CORS)
		w.Header().Set("Access-Control-Allow-Origin", "*") //*conf.AuthServerConfig.Host)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Authorization, Content-Type, Content-Length, X-CSRF-Token, Token, session, Origin, Host, Connection, Accept-Encoding, Accept-Language, X-Requested-With")

		socketServer.ServeHTTP(w, r)
	})
	httpServeMux.HandleFunc("/game_server/", func(w http.ResponseWriter, r *http.Request) {
		log.D("game_server requested")
		// origin to excape Cross-Origin Resource Sharing (CORS)
		w.Header().Set("Access-Control-Allow-Origin", "*") //*conf.AuthServerConfig.Host)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Authorization, Content-Type, Content-Length, X-CSRF-Token, Token, session, Origin, Host, Connection, Accept-Encoding, Accept-Language, X-Requested-With")
		host, err := db.GetMainGameServer()
		if err != nil {
			log.E("Error getting main game server: %v", err)
			return
		}
		w.Write([]byte(*host))
	})
	httpServeMux.HandleFunc(*conf.AuthServerConfig.OAuthCallbackEndpoint, httpOAuthEndpointHandler)

	log.I("Serving at %v", *conf.AuthServerConfig.Port)
	log.E("%v", utils.ListenAndServe(fmt.Sprintf(":%v", *conf.AuthServerConfig.Port), session.SessionManager.LoadAndSave(httpServeMux)))

	return nil
}
