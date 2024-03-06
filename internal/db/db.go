package db

import (
	"context"
	"encoding/json"
	"mars-go-service/internal/logger"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

var (
	log         *logger.Logger
	databaseUrl string
)

type EventType string

// Event is to define the event
type Event struct {
	Id        int       `json:"id"`
	EvtType   EventType `json:"evtType"`
	ChatRoom  string    `json:"chatRoom"`
	UserId    string    `json:"userId"`
	Timestamp time.Time `json:"timestamp"`
	Text      string    `json:"text"`
}

type NewPlayerModel struct {
	Index         int    `json:"index"`
	LobbyPlayerId int    `json:"lobbyPlayerId"`
	Name          string `json:"name"`
	Color         string `json:"color"`
	Beginner      bool   `json:"beginner"`
	Handicap      int    `json:"handicap"`
	First         bool   `json:"first"`
}

type NewGameConfig struct {
	Players                          []NewPlayerModel `json:"players"`
	MaxPlayers                       int              `json:"maxPlayers"`
	Prelude                          bool             `json:"prelude"`
	VenusNext                        bool             `json:"venusNext"`
	Colonies                         bool             `json:"colonies"`
	Turmoil                          bool             `json:"turmoil"`
	Board                            string           `json:"board"`
	Seed                             float32          `json:"seed"`
	InitialDraft                     bool             `json:"initialDraft"`
	RandomFirstPlayer                bool             `json:"randomFirstPlayer"`
	ClonedGamedId                    *string          `json:"clonedGamedId,omitempty"`
	UndoOption                       bool             `json:"undoOption"`
	ShowTimers                       bool             `json:"showTimers"`
	FastModeOption                   bool             `json:"fastModeOption"`
	ShowOtherPlayersVP               bool             `json:"showOtherPlayersVP"`
	CorporateEra                     bool             `json:"corporateEra"`
	Prelude2Expansion                bool             `json:"prelude2Expansion"`
	PromoCardsOption                 bool             `json:"promoCardsOption"`
	CommunityCardsOption             bool             `json:"communityCardsOption"`
	AresExtension                    bool             `json:"aresExtension"`
	PoliticalAgendasExtension        string           `json:"politicalAgendasExtension"`
	SolarPhaseOption                 bool             `json:"solarPhaseOption"`
	RemoveNegativeGlobalEventsOption bool             `json:"removeNegativeGlobalEventsOption"`
	IncludeVenusMA                   bool             `json:"includeVenusMA"`
	MoonExpansion                    bool             `json:"moonExpansion"`
	PathfindersExpansion             bool             `json:"pathfindersExpansion"`
	CeoExtension                     bool             `json:"ceoExtension"`
	DraftVariant                     bool             `json:"draftVariant"`
	StartingCorporations             int              `json:"startingCorporations"`
	ShuffleMapOption                 bool             `json:"shuffleMapOption"`
	RandomMA                         string           `json:"randomMA"` //
	IncludeFanMA                     bool             `json:"includeFanMA"`
	SoloTR                           bool             `json:"soloTR"`
	CustomCorporationsList           []string         `json:"customCorporationsList"`
	BannedCards                      []string         `json:"bannedCards"`
	CustomColoniesList               []string         `json:"customColoniesList"`
	CustomPreludes                   []string         `json:"customPreludes"`
	RequiresMoonTrackCompletion      bool             `json:"requiresMoonTrackCompletion"`
	RequiresVenusTrackCompletion     bool             `json:"requiresVenusTrackCompletion"`
	MoonStandardProjectVariant       bool             `json:"moonStandardProjectVariant"`
	AltVenusBoard                    bool             `json:"altVenusBoard"`
	EscapeVelocityMode               bool             `json:"escapeVelocityMode"`
	EscapeVelocityThreshold          *int             `json:"escapeVelocityThreshold,omitempty"`
	EscapeVelocityBonusSeconds       *int             `json:"escapeVelocityBonusSeconds,omitempty"`
	EscapeVelocityPeriod             *int             `json:"escapeVelocityPeriod,omitempty"`
	EscapeVelocityPenalty            *int             `json:"escapeVelocityPenalty,omitempty"`
	TwoCorpsVariant                  bool             `json:"twoCorpsVariant"`
	CustomCeos                       []string         `json:"customCeos"`
	StartingCeos                     int              `json:"startingCeos"`
	StarWarsExpansion                bool             `json:"starWarsExpansion"`
	UnderworldExpansion              bool             `json:"underworldExpansion"`
}

type LobbyGame struct {
	LobbyGameid     int           `json:"lobbyGameId"`
	GameModel       *string       `json:"gameModel,omitempty"`
	NewGameConfig   NewGameConfig `json:"newGameConfig"`
	DeathDay        *time.Time    `json:"deathDay,omitempty"`
	StartedAt       *time.Time    `json:"startedAt,omitempty"`
	CreatedAt       time.Time     `json:"createdAt"`
	SharedAt        *time.Time    `json:"sharedAt,omitempty"`
	FinishedAt      *time.Time    `json:"finishedAt,omitempty"`
	FinalStatistic  *string       `json:"finalState,omitempty"`
	UserIdCreatedBy string        `json:"userIdCreatedBy"`
}

func InitDB(dbUrl string) {
	log = logger.NewLogger("db")
	databaseUrl = dbUrl //"postgres://postgres:mypassword@localhost:5432/postgres"
}

func newConn() (*pgxpool.Pool, error) {
	dbpool, err := pgxpool.New(context.Background(), databaseUrl)
	if err != nil {
		log.E("Unable to create connection pool: %v\n", err)
		return nil, err
	}

	return dbpool, nil
}

func InsertOrUpdateUser(id string, name string, avatar string) error {

	dbpool, err := newConn()
	if err != nil {
		return err
	}
	defer dbpool.Close()
	query := `
		INSERT INTO users (id, name, avatar)
		VALUES($1, $2, $3)
		ON CONFLICT (id)
		DO
		UPDATE SET name = EXCLUDED.name, avatar = EXCLUDED.avatar;
	`

	_, err = dbpool.Exec(context.Background(), query, id, name, avatar)
	if err != nil {
		log.E("INSERT INTO users failed: %v\n", err)
		return err
	}
	log.I("user: %v,%v inserted or updated\n", id, name)
	return nil
}

func InsertNewEventAndGetInsertedIdBack(userId string, message string, eventType string, room_key string) (*int, *time.Time, error) {
	var id int
	var created_at time.Time
	dbpool, err := newConn()
	if err != nil {
		return nil, nil, err
	}
	defer dbpool.Close()

	query := `
		INSERT INTO chat_events (user_id, message, type, room_key)
		VALUES($1, $2, $3, $4)
		RETURNING id, created_at;
	`
	user_id, err := strconv.ParseInt(userId, 10, 64)
	if err != nil {
		log.E("strconv.ParseInt failed: %v\n", err)
		return nil, nil, err
	}
	err = dbpool.QueryRow(context.Background(), query, user_id, message, eventType, room_key).Scan(&id, &created_at)
	if err != nil {
		log.E("INSERT INTO chat_events failed: %v\n", err)
		return nil, nil, err
	}
	log.I("chat_events: %v,%v,%v inserted\n", user_id, message, eventType)
	return &id, &created_at, nil
}

func InsertNewGameSettingsAndGetLobbyGameBack(userId string, newGameConfig string) (*LobbyGame, error) {
	var id int
	var deathDay *time.Time
	var startedAt *time.Time
	var createdAt time.Time
	var finishedAt *time.Time
	var finalStatistic *string

	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		INSERT INTO games (user_id, settings, server_id)
		VALUES($1, $2, 1)
		RETURNING id, death_day, finished_at, final_statistic, started_at, created_at;
	`
	user_id, err := strconv.ParseInt(userId, 10, 64)
	if err != nil {
		log.E("strconv.ParseInt failed: %v\n", err)
		return nil, err
	}
	err = dbpool.QueryRow(context.Background(), query, user_id, newGameConfig).Scan(&id, &deathDay, &finishedAt, &finalStatistic, &startedAt, &createdAt)
	if err != nil {
		log.E("INSERT INTO games failed: %v\n", err)
		return nil, err
	}

	newGameConfigStruct := &NewGameConfig{}
	err = json.Unmarshal([]byte(newGameConfig), newGameConfigStruct)
	if err != nil || newGameConfig == "" {
		log.E("json.Unmarshal(NewGameConfig) error: %v", err)
		return nil, err
	}

	lobbyGame := &LobbyGame{
		LobbyGameid:     id,
		GameModel:       nil,
		NewGameConfig:   *newGameConfigStruct,
		DeathDay:        deathDay,
		StartedAt:       startedAt,
		CreatedAt:       createdAt,
		FinishedAt:      finishedAt,
		FinalStatistic:  nil,
		UserIdCreatedBy: userId,
	}

	log.I("game inserted by: %v\n", user_id)
	return lobbyGame, nil
}

func UpdateNewGameSettingsAndGetLobbyGameBack(userId string, lobbyGameToUpdate LobbyGame) (*LobbyGame, error) {
	lobbyGame := &LobbyGame{}
	var newGameConfig string
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		UPDATE games
		SET settings = $1
		WHERE id = $2 AND user_id = $3 
		RETURNING id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at;
	`
	user_id, err := strconv.ParseInt(userId, 10, 64)
	if err != nil {
		log.E("strconv.ParseInt failed: %v\n", err)
		return nil, err
	}
	err = dbpool.QueryRow(context.Background(), query, lobbyGameToUpdate.NewGameConfig, lobbyGameToUpdate.LobbyGameid, user_id).Scan(
		&lobbyGame.LobbyGameid, &newGameConfig, &lobbyGame.DeathDay, &lobbyGame.FinishedAt, &lobbyGame.FinalStatistic, &lobbyGame.StartedAt, &lobbyGame.CreatedAt, &lobbyGame.UserIdCreatedBy, &lobbyGame.SharedAt,
	)
	if err != nil {
		log.E("INSERT INTO games failed: %v\n", err)
		return nil, err
	}

	newGameConfigStruct := &NewGameConfig{}
	err = json.Unmarshal([]byte(newGameConfig), newGameConfigStruct)
	if err != nil || newGameConfig == "" {
		log.E("json.Unmarshal(NewGameConfig) error: %v", err)
		return nil, err
	}

	lobbyGame.NewGameConfig = *newGameConfigStruct

	log.I("game updated by: %v\n", user_id)
	return lobbyGame, nil
}

func GetEventsByRoom(room_key string) ([]*Event, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		SELECT id, type, room_key, user_id, created_at, message
		FROM chat_events
		WHERE room_key = $1
		ORDER BY id DESC
		LIMIT 100;
	`
	rows, err := dbpool.Query(context.Background(), query, room_key)
	if err != nil {
		log.E("SELECT FROM chat_events failed: %v\n", err)
		return nil, err
	}
	defer rows.Close()

	events := make([]*Event, 0)
	for rows.Next() {
		event := &Event{}
		err = rows.Scan(&event.Id, &event.EvtType, &event.ChatRoom, &event.UserId, &event.Timestamp, &event.Text)
		if err != nil {
			log.E("rows.Scan failed: %v\n", err)
			return nil, err
		}
		events = append(events, event)
	}
	return events, nil
}

func GetLobbyGames(userId string) ([]*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		SELECT id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at
		FROM games
		where user_id = $1 OR (shared_at is not null AND finished_at is null);
	`
	rows, err := dbpool.Query(context.Background(), query, userId)
	if err != nil {
		log.E("SELECT FROM games failed: %v\n", err)
		return nil, err
	}
	defer rows.Close()

	lobbyGames := make([]*LobbyGame, 0)
	for rows.Next() {
		lobbyGame := &LobbyGame{}
		var newGameConfig string
		err = rows.Scan(&lobbyGame.LobbyGameid, &newGameConfig, &lobbyGame.DeathDay, &lobbyGame.FinishedAt, &lobbyGame.FinalStatistic, &lobbyGame.StartedAt, &lobbyGame.CreatedAt, &lobbyGame.UserIdCreatedBy, &lobbyGame.SharedAt)
		if err != nil {
			log.E("rows.Scan failed: %v\n", err)
			return nil, err
		}
		newGameConfigStruct := &NewGameConfig{}
		err = json.Unmarshal([]byte(newGameConfig), newGameConfigStruct)
		if err != nil || newGameConfig == "" {
			log.E("json.Unmarshal(NewGameConfig) error: %v", err)
			return nil, err
		}
		lobbyGame.NewGameConfig = *newGameConfigStruct
		lobbyGames = append(lobbyGames, lobbyGame)
	}
	return lobbyGames, nil
}
