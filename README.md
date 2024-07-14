# <a name="README"> Lobby and Chat for the Terraforming Mars Open-source.

This is extension for this application  - https://github.com/terraforming-mars/terraforming-mars, which allow you to find opponents to play with and communicate with them and use alternative game client (it is in development stage and doesn't allow to use some extensions).

## How it works.
Main menu of this app repeat design and functionality of the main app (https://github.com/terraforming-mars/terraforming-mars) except of the couple of moments:
1) "NEW GAME" button renamed to "PLAY".
	When you click it you will be asked to authorizate with Discord account.
	After authorization lobby and chat will be available. There you will be able create new game, join to created game, continue already started game, watch others game.
	When game is stared\continued the game client from the main app will be shown into iframe with an additional chat panel.
2) Cuttently from main menu you can't change the 	game client settings or change language. However you can do it from the game client when you run a game.
3) If you click "start" with wrong game config (for example you select "Colonies" extensions and select only one colony) nothing happend while the main app whould show "Must select at least 4 colonies" warning.

## How to try it.

1) There's a instance available at https://fan-side-of-mars.ovh/. It uses  https://tm.fan-side-of-mars.ovh/ (it uses forked repository from https://github.com/terraforming-mars/terraforming-mars to avoid API changes) as game server and one of the game client.

2) Using a docker image. This repository is automatically compiled into docker image - [dercasdrol/new-tm-web-client](https://hub.docker.com/repository/docker/dercasdrol/new-tm-web-client/general).
If you have installed Docker app and "docker compose" extension you need to pull this repo, create file .env (see example.env) according to your target config, and call "docker compose up" from a folder with this repo.
NOTE: currently I use only one Docker image with latest tag, sometimes it may have some problems, because this project in the developing stage. Perhaps later I will add additional tags with stable versions, if this is in demand.
