package db

import (
	"context"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

// if you need to add new version of db, you should create new function vSQL_X and add it to sql_version_updaters
var (
	sql_version_updaters = []func(*pgxpool.Pool) error{
		vSQL_1,
		vSQL_2,
		vSQLAfterUpdate,
	}
)

func PrepareDBtoWork(dbpool *pgxpool.Pool) error {
	version, err := checkDBVersion(dbpool)
	if err != nil {
		return err
	}
	for i, updater := range sql_version_updaters {
		if version != nil && i+1 > *version {
			err = updater(dbpool)
			if err != nil {
				return err
			}
		}
	}
	return nil
}

func checkDBVersion(dbpool *pgxpool.Pool) (*int, error) {
	// Check if db_version table exists
	var exists bool
	err := dbpool.QueryRow(context.Background(), "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'db_version')").Scan(&exists)
	if err != nil {
		return nil, err
	}
	if !exists {
		// Create db_version table
		_, err = dbpool.Exec(context.Background(), "CREATE TABLE IF NOT EXISTS public.db_version (version integer NOT NULL);")
		if err != nil {
			return nil, err
		}
		_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.db_version OWNER to postgres;`)
		if err != nil {
			return nil, err
		}
		_, err = dbpool.Exec(context.Background(), "INSERT INTO db_version (version) VALUES (0)")
		if err != nil {
			return nil, err
		}
	}
	// Get db version
	var version int
	err = dbpool.QueryRow(context.Background(), "SELECT version FROM db_version").Scan(&version)
	if err != nil {
		return nil, err
	}
	return &version, nil
}

func vSQL_1(dbpool *pgxpool.Pool) error {
	_, err := dbpool.Exec(context.Background(), `CREATE TYPE public.chat_event_type AS ENUM ('join', 'leave', 'message')`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TYPE public.chat_event_type OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS public.chat_events
		(
			id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
			user_id bigint NOT NULL,
			created_at timestamp without time zone NOT NULL DEFAULT now(),
			message character varying(500) COLLATE pg_catalog."default",
			type chat_event_type NOT NULL,
			room_key character varying(100) COLLATE pg_catalog."default" NOT NULL,
			CONSTRAINT messages_pkey PRIMARY KEY (id)
		)

		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.chat_events OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `COMMENT ON COLUMN public.chat_events.room_key IS 'Usually it is game_id, but for general chat it will be "General"';`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE INDEX IF NOT EXISTS room_key
		ON public.chat_events USING btree
		(room_key COLLATE pg_catalog."default" ASC NULLS LAST)
		WITH (deduplicate_items=True)

		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS public.game_servers
		(
			id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
			url character varying(200) COLLATE pg_catalog."default" NOT NULL,
			name character varying(100) COLLATE pg_catalog."default" NOT NULL,
			CONSTRAINT game_servers_pkey PRIMARY KEY (id)
		)

		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.game_servers OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS public.games
		(
			id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
			server_game_id character varying(20) COLLATE pg_catalog."default",
			death_day timestamp without time zone,
			started_at timestamp without time zone,
			finished_at timestamp without time zone,
			server_spectator_id character varying(20) COLLATE pg_catalog."default",
			settings json NOT NULL,
			final_statistic json,
			server_id integer NOT NULL,
			user_id bigint NOT NULL,
			created_at timestamp without time zone NOT NULL DEFAULT now(),
			shared_at timestamp without time zone,
			CONSTRAINT games_pkey PRIMARY KEY (id)
		)

		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.games OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE INDEX IF NOT EXISTS games_user_ids
		ON public.games USING btree
		(user_id ASC NULLS LAST)
		WITH (deduplicate_items=True)
		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS public.players
		(
			id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
			game_id integer NOT NULL,
			user_id bigint NOT NULL,
			server_player_id character varying(20) COLLATE pg_catalog."default",
			CONSTRAINT players_pkey PRIMARY KEY (id),
			CONSTRAINT game_user UNIQUE (game_id, user_id),
			CONSTRAINT fk_game_id FOREIGN KEY (game_id)
				REFERENCES public.games (id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE NO ACTION
		)
		
		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.players OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `
		CREATE TABLE IF NOT EXISTS public.users
		(
			created_at timestamp without time zone DEFAULT now(),
			name character varying(100) COLLATE pg_catalog."default" NOT NULL,
			avatar character varying(50) COLLATE pg_catalog."default",
			id bigint NOT NULL,
			CONSTRAINT users_pkey PRIMARY KEY (id)
		)
		
		TABLESPACE pg_default;
	`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), `ALTER TABLE IF EXISTS public.users OWNER to postgres;`)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), "UPDATE db_version SET version = 1")
	if err != nil {
		return err
	}
	return nil
}

func vSQL_2(dbpool *pgxpool.Pool) error {
	host := "terraforming-mars.herokuapp.com"
	GAME_SERVER_HOST := os.Getenv("GAME_SERVER_HOST")
	if GAME_SERVER_HOST != "" {
		host = GAME_SERVER_HOST
	}
	_, err := dbpool.Exec(context.Background(), `INSERT INTO public.game_servers (url, name) VALUES ($1, 'Main');`, host)
	if err != nil {
		return err
	}
	_, err = dbpool.Exec(context.Background(), "UPDATE db_version SET version = 2")
	if err != nil {
		return err
	}
	return nil
}

func vSQLAfterUpdate(dbpool *pgxpool.Pool) error {
	//initialy I wanted use several game servers, but now I use only one, so I need to update it each time when it is changed
	GAME_SERVER_HOST := os.Getenv("GAME_SERVER_HOST")
	if GAME_SERVER_HOST != "" {
		_, err := dbpool.Exec(context.Background(), `update public.game_servers set url = $1 where name = 'Main';`, GAME_SERVER_HOST)
		if err != nil {
			return err
		}
	}
	return nil
}
