CREATE TABLE Team (
    team_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE Player (
    player_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    team_id INTEGER REFERENCES Team(team_id)
);

CREATE TABLE Season (
    season_id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    champion TEXT,
    mvp TEXT
);

CREATE TABLE Game (
    game_id SERIAL PRIMARY KEY,
    home_team_id INTEGER REFERENCES Team(team_id),
	home_team_name TEXT,
	score_home_team INTEGER,
    away_team_id INTEGER REFERENCES Team(team_id),
	away_team_name TEXT,
	score_away_team INTEGER,
    season_id INTEGER REFERENCES Season(season_id)
);

CREATE TABLE Team_Season (
    team_id INTEGER REFERENCES Team(team_id),
    season_id INTEGER REFERENCES Season(season_id),
    wins INTEGER,
    losses INTEGER,
    PRIMARY KEY (team_id, season_id)
);

CREATE TABLE Player_Game (
    player_id INTEGER REFERENCES Player(player_id),
    game_id INTEGER REFERENCES Game(game_id),
    pts NUMERIC(5,2),
    trb NUMERIC(5,2),
    ast NUMERIC(5,2),
    fg_pct NUMERIC(5,3),
    fg3_pct NUMERIC(5,3),
    ft_pct NUMERIC(5,3),
    PRIMARY KEY (player_id, game_id)
);

CREATE TABLE Player_Season (
    player_id INTEGER REFERENCES Player(player_id),
    season_id INTEGER REFERENCES Season(season_id),
    pts NUMERIC(5,2),
    trb NUMERIC(5,2),
    ast NUMERIC(5,2),
    fg_pct NUMERIC(5,3),
    fg3_pct NUMERIC(5,3),
    ft_pct NUMERIC(5,3),
    efg_pct NUMERIC(5,3),
    PRIMARY KEY (player_id, season_id)
);

INSERT INTO Season (season_id, year, champion, mvp)
VALUES (1, 2023, 'Denver Nuggets', 'Joel Embiid');

INSERT INTO TEAM (team_id, name)
VALUES (0, 'Played in multiple teams');

