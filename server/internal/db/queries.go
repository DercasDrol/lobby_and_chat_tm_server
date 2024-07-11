package db

//TODO: cleanup chat_events rows after some rows count in each room
import (
	"context"
	"fmt"
	"mars-go-service/internal/logger"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

var (
	log         *logger.Logger
	databaseUrl string
)

func InitDB(dbUrl string) error {
	log = logger.NewLogger("db")
	databaseUrl = dbUrl //"postgres://postgres:mypassword@localhost:5432/postgres"
	dbpool, err := newConn()
	if err != nil {
		return err
	}
	defer dbpool.Close()
	err = PrepareDBtoWork(dbpool)
	if err != nil {
		log.E("PrepareDBtoWork failed: %v\n", err)
		return err
	}
	return nil
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

func GetUserInfos(ids []string) ([]*User, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `SELECT id, name, avatar FROM users WHERE id = ANY($1);`
	rows, err := dbpool.Query(context.Background(), query, ids)
	if err != nil {
		log.E("SELECT FROM users failed: %v\n", err)
		return nil, err
	}
	defer rows.Close()

	users := make([]*User, 0)
	for rows.Next() {
		user := &User{}
		err = rows.Scan(&user.Id, &user.Username, &user.Avatar)
		if err != nil {
			log.E("rows.Scan failed: %v\n", err)
			return nil, err
		}
		users = append(users, user)
	}
	return users, nil
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

func InsertNewGameSettings(userId string, newGameConfig string) (*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()
	var lobbyGameId string

	query := `
		INSERT INTO games (user_id, settings, server_id)
		VALUES($1, $2, 1)
		RETURNING id;
	`

	err = dbpool.QueryRow(context.Background(), query, userId, newGameConfig).Scan(&lobbyGameId)
	if err != nil {
		log.E("INSERT INTO games failed: %v\n", err)
		return nil, err
	}

	return joinGame(userId, lobbyGameId, dbpool)
}

func GetMainGameServer() (*string, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `SELECT url FROM game_servers WHERE name = 'Main' LIMIT 1;`
	var url string
	err = dbpool.QueryRow(context.Background(), query).Scan(&url)
	if err != nil {
		log.E("SELECT FROM game_servers failed: %v\n", err)
		return nil, err
	}
	return &url, nil
}

func updateNewGameSettings(userId string, lobbyGameToUpdate LobbyGame, dbpool *pgxpool.Pool) (*LobbyGame, error) {
	query := `
		UPDATE games
		SET settings = $1
		WHERE id = $2 AND user_id = $3 
		RETURNING id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at, server_spectator_id;
	`
	return getChangedGameFromRow(dbpool.QueryRow(context.Background(), query, lobbyGameToUpdate.NewGameConfig, lobbyGameToUpdate.LobbyGameid, userId))
}

func UpdateNewGameSettings(userId string, lobbyGameToUpdate LobbyGame) (*LobbyGame, error) {
	//TODO: add commit/rollback
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	return updateNewGameSettings(userId, lobbyGameToUpdate, dbpool)
}

func getPlayersMap(gameId int, dbpool *pgxpool.Pool) (map[string] /*userId*/ string /*playerNickname*/, error) {
	query0 := `SELECT players.user_id, users.name FROM players JOIN users ON players.user_id = users.id WHERE game_id = $1;`
	rows, err := dbpool.Query(context.Background(), query0, gameId)
	if err != nil {
		log.E("SELECT FROM players failed: %v\n", err)
		return nil, err
	}

	playersMap := make(map[string] /*userId*/ string /*playerNickname*/)
	for rows.Next() {
		var userId string
		var playerNickname string
		err = rows.Scan(&userId, &playerNickname)
		if err != nil {
			log.E("rows.Scan failed: %v\n", err)
			return nil, err
		}
		playersMap[userId] = playerNickname
	}
	return playersMap, nil
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
		LIMIT 50;
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
		SELECT id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at, server_spectator_id
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
		lobbyGame, err := getChangedGameFromRow(rows)
		if err != nil {
			log.E("getChangedGameFromRow failed: %v\n", err)
			return nil, err
		}
		lobbyGames = append(lobbyGames, lobbyGame)
	}
	return lobbyGames, nil
}

func DeleteGame(userId string, lobbyGameId string) error {
	dbpool, err := newConn()
	if err != nil {
		return err
	}
	defer dbpool.Close()

	query := `
		DELETE FROM players
		WHERE game_id = $1;
	`
	_, err = dbpool.Exec(context.Background(), query, lobbyGameId)
	if err != nil {
		log.E("DELETE FROM players failed: %v\n", err)
		return err
	}
	query = `
		DELETE FROM games
		WHERE id = $1 AND user_id = $2;
	`
	_, err = dbpool.Exec(context.Background(), query, lobbyGameId, userId)
	if err != nil {
		log.E("DELETE FROM games failed: %v\n", err)
		return err
	}
	log.I("game deleted by: %v\n", userId)
	return nil
}

func ShareGame(userId string, lobbyGameId string) (*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		UPDATE games
		SET shared_at = now()
		WHERE id = $1 AND user_id = $2
		RETURNING id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at, server_spectator_id;
	`

	return getChangedGameFromRow(dbpool.QueryRow(context.Background(), query, lobbyGameId, userId))
}

func StartGame(userId string, lobbyGameId string) (*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()
	lobbyGame, err := getLobbyGame(lobbyGameId, dbpool)
	if err != nil {
		log.E("getLobbyGame failed: %v\n", err)
		return nil, err
	}
	preparePlayersToStart(&lobbyGame.NewGameConfig)
	if lobbyGame.UserIdCreatedBy != userId {
		log.E("startGameHandler userId %v != lobbyGame.UserIdCreatedBy %v", userId, lobbyGame.UserIdCreatedBy)
		return nil, fmt.Errorf("startGameHandler userId %v != lobbyGame.UserIdCreatedBy %v", userId, lobbyGame.UserIdCreatedBy)
	}
	serverUrl, err := getGameServerUrl(lobbyGameId, dbpool)
	if err != nil {
		log.E("startGameHandler db.getServerUrl error: %v", err)
		return nil, err
	}
	simpleGameModel, err := getSimpleGameModel(serverUrl, lobbyGame)
	if err != nil {
		log.E("startGameHandler getSimpleGameModel error: %v", err)
		return nil, err
	}
	addServerPlayerIds(lobbyGameId, &lobbyGame.NewGameConfig.Players, &simpleGameModel.Players, dbpool)
	query := `
		UPDATE games
		SET started_at = now(), settings = $3, server_game_id = $4, death_day = $5, server_spectator_id = $6
		WHERE id = $1 AND user_id = $2
		RETURNING id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at, server_spectator_id;
	`

	return getChangedGameFromRow(dbpool.QueryRow(context.Background(), query, lobbyGameId, userId, lobbyGame.NewGameConfig, simpleGameModel.Id, time.Unix(0, int64(simpleGameModel.ExpectedPurgeTime)*int64(time.Millisecond)), simpleGameModel.SpectatorId))
}

func addServerPlayerIds(lobbyGameId string, players *[]NewPlayerModel, gameServerPlayers *[]SimplePlayer, dbpool *pgxpool.Pool) error {
	query := `UPDATE players SET server_player_id = $1 WHERE user_id = $2 AND game_id = $3;`
	for _, player := range *players {
		for _, gameServerPlayer := range *gameServerPlayers {
			if player.Color == gameServerPlayer.Color {
				_, err := dbpool.Exec(context.Background(), query, gameServerPlayer.Id, player.UserId, lobbyGameId)
				if err != nil {
					log.E("UPDATE players SET server_player_id failed: %v\n", err)
					return err
				}
				break
			}
		}
	}
	return nil
}

func JoinGame(userId string, lobbyGameId string) (*LobbyGame, error) {
	//TODO: add commit/rollback
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	return joinGame(userId, lobbyGameId, dbpool)
}

func joinGame(userId string, lobbyGameId string, dbpool *pgxpool.Pool) (*LobbyGame, error) {

	lobbyGame, err := getLobbyGame(lobbyGameId, dbpool)
	if err != nil {
		log.E("getLobbyGame failed: %v\n", err)
		return nil, err
	}

	query := `
		INSERT INTO players (user_id, game_id)
		SELECT $1, $2 WHERE (Select count(*) < $3 from players where game_id = $2);
	`
	_, err = dbpool.Exec(context.Background(), query, userId, lobbyGameId, lobbyGame.NewGameConfig.MaxPlayers)
	if err != nil {
		log.E("INSERT INTO lobby_players failed: %v\n", err)
		return nil, err
	}
	log.I("game joined by: %v\n", userId)

	newPlayersMap, err := getPlayersMap(lobbyGame.LobbyGameid, dbpool)
	if err != nil {
		log.E("getPlayersMap failed: %v\n", err)
		return nil, err
	}
	updateLobbyGamePlayers(newPlayersMap, lobbyGame, nil, nil)
	return updateNewGameSettings(lobbyGame.UserIdCreatedBy, *lobbyGame, dbpool)
}

func LeaveGame(userId string, lobbyGameId string) (*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		DELETE FROM players
		WHERE user_id = $1 AND game_id = $2 AND (SELECT started_at IS NULL FROM games WHERE id = $2);
	`
	_, err = dbpool.Exec(context.Background(), query, userId, lobbyGameId)
	if err != nil {
		log.E("DELETE FROM lobby_players failed: %v\n", err)
		return nil, err
	}
	log.I("game left by: %v\n", userId)
	lobbyGame, err := getLobbyGame(lobbyGameId, dbpool)
	if err != nil {
		log.E("getLobbyGame failed: %v\n", err)
		return nil, err
	}
	newPlayersMap, err := getPlayersMap(lobbyGame.LobbyGameid, dbpool)
	if err != nil {
		log.E("getPlayersMap failed: %v\n", err)
		return nil, err
	}
	updateLobbyGamePlayers(newPlayersMap, lobbyGame, nil, nil)
	return updateNewGameSettings(lobbyGame.UserIdCreatedBy, *lobbyGame, dbpool)
}

func getLobbyGame(lobbyGameId string, dbpool *pgxpool.Pool) (*LobbyGame, error) {
	query := `
		SELECT id, settings, death_day, finished_at, final_statistic, started_at, created_at, user_id, shared_at, server_spectator_id
		FROM games
		WHERE id = $1;
	`

	return getChangedGameFromRow(dbpool.QueryRow(context.Background(), query, lobbyGameId))
}

// temporary solution, lobbyGame too big to be passed as a parameter from client
func ChangePlayerColor(lobbyGame *LobbyGame, userId string) (*LobbyGame, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	lobbyGameFromDB, err := getLobbyGame(fmt.Sprint(lobbyGame.LobbyGameid), dbpool)
	if err != nil {
		log.E("getLobbyGame failed: %v\n", err)
		return nil, err
	}
	newPlayersMap, err := getPlayersMap(lobbyGame.LobbyGameid, dbpool)
	if err != nil {
		log.E("getPlayersMap failed: %v\n", err)
		return nil, err
	}
	_, playerExists := newPlayersMap[userId]
	if !playerExists {
		log.E("playerExists failed: %v\n", err)
		return nil, err
	}
	var newColor *string
	for player := range lobbyGame.NewGameConfig.Players {
		if lobbyGame.NewGameConfig.Players[player].UserId == userId {
			newColor = &lobbyGame.NewGameConfig.Players[player].Color
			break
		}
	}

	updateLobbyGamePlayers(newPlayersMap, lobbyGameFromDB, &userId, newColor)
	return updateNewGameSettings(lobbyGame.UserIdCreatedBy, *lobbyGame, dbpool)
}

func getGameServerUrl(lobbyGameId string, dbpool *pgxpool.Pool) (string, error) {

	query := `
		SELECT game_servers.url
		FROM games
		JOIN game_servers ON games.server_id = game_servers.id
		WHERE games.id = $1;
	`
	var serverUrl string
	err := dbpool.QueryRow(context.Background(), query, lobbyGameId).Scan(&serverUrl)
	if err != nil {
		log.E("getServerUrl failed: %v\n", err)
		return "", err
	}
	return serverUrl, nil
}

func GetPlayer(lobbyGameId string, userId string) (*Player, error) {
	dbpool, err := newConn()
	if err != nil {
		return nil, err
	}
	defer dbpool.Close()

	query := `
		SELECT user_id, server_player_id, game_id
		FROM players
		WHERE user_id = $1 AND game_id = $2;
	`
	var player Player
	err = dbpool.QueryRow(context.Background(), query, userId, lobbyGameId).Scan(&player.UserId, &player.ServerPlayerId, &player.LobbyGameId)
	if err != nil {
		log.E("SELECT FROM players failed: %v\n", err)
		return nil, err
	}
	return &player, nil
}
