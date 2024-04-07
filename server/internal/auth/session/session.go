package session

import (
	"time"

	"net/http"

	"github.com/alexedwards/scs/v2"
)

var SessionManager *scs.SessionManager

func init() {
	SessionManager = scs.New()
	SessionManager.Lifetime = 24 * time.Hour
}

func GetStateFromSession(r *http.Request) string {
	return SessionManager.GetString(r.Context(), "state")
}

func SetStateFromSession(r *http.Request, state string) {
	SessionManager.Put(r.Context(), "state", state)
}
