package db

import "time"

type User struct {
	Id       string `json:"id"`
	Username string `json:"username"`
	Avatar   string `json:"avatar"`
}

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
	IncludedCards                    []string         `json:"includedCards"`
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
	PreludeDraftVariant              *bool            `json:"preludeDraftVariant,omitempty"`
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
	SpectatorId     *string       `json:"spectatorId,omitempty"`
}

type SimpleGameModel struct {
	ActivePlayer       string           `json:"activePlayer"`
	Id                 string           `json:"id"`
	Phase              string           `json:"phase"`
	Players            []SimplePlayer   `json:"players"`
	SpectatorId        *string          `json:"spectatorId,omitempty"`
	GameOptions        GameOptionsModel `json:"gameOptions"`
	LastSoloGeneration int              `json:"lastSoloGeneration"`
	ExpectedPurgeTime  int              `json:"expectedPurgeTimeMs"`
}

type SimplePlayer struct {
	Color string `json:"color"`
	Id    string `json:"id"`
	Name  string `json:"name"`
}

type Player struct {
	UserId         string `json:"userId"`
	ServerPlayerId string `json:"serverPlayerId"`
	LobbyGameId    int    `json:"lobbyGameId"`
}

type GameOptionsModel struct {
	AresExtension                    bool     `json:"aresExtension"`
	AltVenusBoard                    bool     `json:"altVenusBoard"`
	Board                            string   `json:"board"`
	BannedCards                      []string `json:"bannedCards"`
	IncludedCards                    []string `json:"includedCards"`
	CeoExtension                     bool     `json:"ceoExtension"`
	Colonies                         bool     `json:"colonies"`
	CommunityCardsOption             bool     `json:"communityCardsOption"`
	CorporateEra                     bool     `json:"corporateEra"`
	DraftVariant                     bool     `json:"draftVariant"`
	EscapeVelocityMode               bool     `json:"escapeVelocityMode"`
	EscapeVelocityThreshold          *int     `json:"escapeVelocityThreshold,omitempty"`
	EscapeVelocityPeriod             *int     `json:"escapeVelocityPeriod,omitempty"`
	EscapeVelocityPenalty            *int     `json:"escapeVelocityPenalty,omitempty"`
	FastModeOption                   bool     `json:"fastModeOption"`
	IncludeFanMA                     bool     `json:"includeFanMA"`
	IncludeVenusMA                   bool     `json:"includeVenusMA"`
	InitialDraft                     bool     `json:"initialDraft"`
	PreludeDraftVariant              *bool    `json:"preludeDraftVariant,omitempty"`
	MoonExpansion                    bool     `json:"moonExpansion"`
	PathfindersExpansion             bool     `json:"pathfindersExpansion"`
	Prelude                          bool     `json:"prelude"`
	PromoCardsOption                 bool     `json:"promoCardsOption"`
	PoliticalAgendasExtension        string   `json:"politicalAgendasExtension"`
	RemoveNegativeGlobalEventsOption bool     `json:"removeNegativeGlobalEventsOption"`
	ShowOtherPlayersVP               bool     `json:"showOtherPlayersVP"`
	ShowTimers                       bool     `json:"showTimers"`
	ShuffleMapOption                 bool     `json:"shuffleMapOption"`
	SolarPhaseOption                 bool     `json:"solarPhaseOption"`
	SoloTR                           bool     `json:"soloTR"`
	RandomMA                         string   `json:"randomMA"`
	RequiresMoonTrackCompletion      bool     `json:"requiresMoonTrackCompletion"`
	RequiresVenusTrackCompletion     bool     `json:"requiresVenusTrackCompletion"`
	Turmoil                          bool     `json:"turmoil"`
	TwoCorpsVariant                  bool     `json:"twoCorpsVariant"`
	VenusNext                        bool     `json:"venusNext"`
	UndoOption                       bool     `json:"undoOption"`
}
