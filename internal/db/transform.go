package db

import (
	"encoding/json"
	"mars-go-service/internal/utils"
	"math/rand"

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
func getChangedGameFromRow(row pgx.Row) (*LobbyGame, error) {
	lobbyGame := &LobbyGame{}
	var newGameConfig string
	err := row.Scan(&lobbyGame.LobbyGameid, &newGameConfig, &lobbyGame.DeathDay, &lobbyGame.FinishedAt, &lobbyGame.FinalStatistic, &lobbyGame.StartedAt, &lobbyGame.CreatedAt, &lobbyGame.UserIdCreatedBy, &lobbyGame.SharedAt)
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
