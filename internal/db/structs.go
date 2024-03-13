package db

import "time"

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
	Index    int    `json:"index"`
	UserId   string `json:"userId"`
	Name     string `json:"name"`
	Color    string `json:"color"`
	Beginner bool   `json:"beginner"`
	Handicap int    `json:"handicap"`
	First    bool   `json:"first"`
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
