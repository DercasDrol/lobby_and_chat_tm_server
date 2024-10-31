package db

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mars-go-service/internal/utils"
	"math/rand"
	"net/http"
	"strings"

	"github.com/jackc/pgx/v5"
)

var (
	playerColors = []string{"blue", "red", "yellow", "green", "black", "purple", "orange", "pink", "neutral", "bronze"}
)

func preparePlayersToStart(newGameConfig *NewGameConfig) {

	if newGameConfig.RandomFirstPlayer {
		// Shuffle players array to assign each player a random seat around the table
		players := newGameConfig.Players
		players = shufflePlayers(players)
		firstIndex := int(newGameConfig.Seed*float32(len(players))) + 1
		for i, player := range players {
			player.First = i == firstIndex
		}
		newGameConfig.Players = players
	}

	//change color if there are duplicates
	uniqueColors := make(map[string]bool)
	for _, player := range newGameConfig.Players {
		_, exists := uniqueColors[player.Color]
		if !exists {
			uniqueColors[player.Color] = true
		}
	}

	for _, player := range newGameConfig.Players {
		_, exists := uniqueColors[player.Color]
		if exists {
			for _, color := range playerColors {
				_, exists := uniqueColors[color]
				if !exists {
					player.Color = color
					uniqueColors[color] = true
					break
				}
			}
		}
	}
}

func shufflePlayers(players []NewPlayerModel) []NewPlayerModel {
	for i := range players {
		j := rand.Intn(i + 1)
		players[i], players[j] = players[j], players[i]
	}
	return players
}

func updateLobbyGamePlayers(newPlayersMap map[string] /*userId*/ string /*playerNickname*/, lobbyGameToUpdate *LobbyGame, userIdToChangeColor *string, newColor *string) {
	existedColors := make([]string, 0)
	updatedPlayersList := make([]NewPlayerModel, 0)

	for _, player := range lobbyGameToUpdate.NewGameConfig.Players {
		existedColors = append(existedColors, player.Color)
		_, playerExists := newPlayersMap[player.UserId]
		if playerExists {
			player.Index = len(updatedPlayersList) + 1
			player.Name = newPlayersMap[player.UserId] //to avoid nickname change on client side
			updatedPlayersList = append(updatedPlayersList, player)
			delete(newPlayersMap, player.UserId)
		}
	}

	for userId, nickname := range newPlayersMap {
		var playerColor string
		if userIdToChangeColor != nil && *userIdToChangeColor == userId && newColor != nil && !utils.ContainsString(existedColors, *newColor) {
			playerColor = *newColor
			existedColors = append(existedColors, *newColor)
		} else {
			for _, color := range playerColors {
				if !utils.ContainsString(existedColors, color) {
					playerColor = color
					existedColors = append(existedColors, color)
					break
				}
			}
		}
		updatedPlayersList = append(updatedPlayersList, NewPlayerModel{
			Index:    len(updatedPlayersList) + 1,
			UserId:   userId,
			Name:     nickname,
			Color:    playerColor,
			Beginner: false,
			Handicap: 0,
			First:    false,
		})
	}

	lobbyGameToUpdate.NewGameConfig.Players = updatedPlayersList
}

// need to be called for each rows.Next()
func getLobbyGameFromRow(row pgx.Row) (*LobbyGame, error) {
	lobbyGame := &LobbyGame{}
	var newGameConfig string
	err := row.Scan(&lobbyGame.LobbyGameid, &newGameConfig, &lobbyGame.DeathDay, &lobbyGame.FinishedAt, &lobbyGame.FinalStatistic, &lobbyGame.StartedAt, &lobbyGame.CreatedAt, &lobbyGame.UserIdCreatedBy, &lobbyGame.SharedAt, &lobbyGame.SpectatorId)
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
	return lobbyGame, nil
}

func getSimpleGameModel(host string, lobbyGame *LobbyGame) (*SimpleGameModel, error) {
	protocol := "https://"
	if strings.HasPrefix(host, "localhost:") {
		protocol = "http://"
	}
	requestURL := fmt.Sprintf("%vgame", protocol+host+"/")

	newGameCongigJson, err := json.Marshal(lobbyGame.NewGameConfig)
	if err != nil {
		log.E("startGameHandler json.Marshal error: %v", err)
		return nil, err
	}

	req, err := http.NewRequest(http.MethodPut, requestURL, bytes.NewReader(newGameCongigJson))
	if err != nil {
		log.E("startGameHandler: could not create request: %s\n", err)
		return nil, err
	}

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.E("startGameHandler: error making http request: %s\n", err)
		return nil, err
	}

	log.D("startGameHandler: got response!\n")
	log.D("startGameHandler: status code: %d\n", res.StatusCode)

	resBody, err := io.ReadAll(res.Body)
	if err != nil {
		log.E("startGameHandler: could not read response body: %s\n", err)
		return nil, err
	}
	log.D("startGameHandler: response body: %s\n", resBody)

	simpleGameModel := &SimpleGameModel{}
	err = json.Unmarshal(resBody, simpleGameModel)
	if err != nil {
		log.E("startGameHandler json.Unmarshal(simpleGameModel) error: %v", err)
		return nil, err
	}
	return simpleGameModel, nil
}

func updateGameStatus(host string, lobbyGame *LobbyGame) (bool, error) {
	protocol := "https://"
	if strings.HasPrefix(host, "localhost:") {
		protocol = "http://"
	}
	requestURL := fmt.Sprintf("%v%v/api/spectator?id=%v", protocol, host, *lobbyGame.SpectatorId)

	req, err := http.NewRequest(http.MethodGet, requestURL, bytes.NewReader([]byte{}))
	if err != nil {
		log.E("getGameStatus: could not create request: %s\n", err)
		return false, err
	}

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.E("getGameStatus: error making http request: %s\n", err)
		return false, err
	}

	log.D("getGameStatus: got response!\n")
	log.D("getGameStatus: status code: %d\n", res.StatusCode)
	if res.StatusCode != http.StatusOK {
		log.E("getGameStatus: status code is not 200: %d\n", res.StatusCode)
		log.E("getGameStatus: requestURL: %s\n", requestURL)
		return false, nil
	}
	resBody, err := io.ReadAll(res.Body)
	if err != nil {
		log.E("getGameStatus: could not read response body: %s\n", err)
		return false, err
	}
	log.D("getGameStatus: response body: %s\n", resBody)
	stringBody := string(resBody)
	if lobbyGame.FinalStatistic != nil && *lobbyGame.FinalStatistic == stringBody {
		return false, nil
	} else {
		lobbyGame.FinalStatistic = &stringBody
		return true, nil
	}
}
