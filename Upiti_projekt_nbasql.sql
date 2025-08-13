-- 1.

-- 1.1 ispis imena svih timova
SELECT name FROM TEAM;

-- 1.2 ispis svih utakmica i rezulrara u kojima su igrali Boston Celticsi
SELECT HOME_TEAM_NAME, SCORE_HOME_TEAM, AWAY_TEAM_NAME, SCORE_AWAY_TEAM
FROM GAME
WHERE HOME_TEAM_NAME = 'Boston Celtics' OR AWAY_TEAM_NAME = 'Boston Celtics';

-- 1.3 PRIKAZ SVIH sezona i sampiona
SELECT year, CHAMPION
FROM SEASON;

--1.4 prikaz svih utakmica u kojima je ukupan zbroj bodova preko 250
SELECT GAME_ID, HOME_TEAM_NAME, SCORE_HOME_TEAM, AWAY_TEAM_NAME, SCORE_AWAY_TEAM
FROM GAME
WHERE (SCORE_HOME_TEAM + SCORE_AWAY_TEAM) > 250;

--1.5 svi timovi s brojem pobjeda vecim od 50
SELECT TEAM_ID, WINS, LOSSES
FROM TEAM_SEASON
WHERE WINS > 50;

-- 2.

--2.1 svi igraci i za koje timove igraju te sezone
SELECT P.NAME AS PLAYER_NAME, T.NAME AS TEAM_NAME
FROM PLAYER P
JOIN TEAM T ON P.TEAM_ID = T.TEAM_ID;

--2.2 top 5 igraca po broju zabijenih poena po utakmici
SELECT NAME, PTS
FROM PLAYER_SEASON
INNER JOIN PLAYER USING (PLAYER_ID)
ORDER BY PTS DESC
LIMIT 5;

--2.3 top 5 igraca s najvise odigranih utakmica
SELECT PLAYER.NAME, COUNT(GAME_ID) AS GAMES_PLAYED
FROM PLAYER_GAME
INNER JOIN PLAYER USING (PLAYER_ID)
GROUP BY PLAYER.NAME
ORDER BY GAMES_PLAYED DESC
LIMIT 5;

--2.4 sve utakmice u kojima je igrao MVP (Joel Embiid) i njegova statistika u svakoj utakmici
SELECT *
FROM PLAYER_GAME
INNER JOIN GAME USING(GAME_ID)
INNER JOIN PLAYER USING (PLAYER_ID)
INNER JOIN SEASON USING (SEASON_ID)
WHERE PLAYER.NAME = SEASON.MVP
ORDER BY GAME_ID;

--2.5 igrač i njegov prosjek poena za tu sezonu
SELECT NAME, PTS
FROM PLAYER
INNER JOIN PLAYER_SEASON USING (PLAYER_ID)
WHERE PLAYER.NAME = 'Bam Adebayo';

-- 3.

--3.1 prosjecan broj poena svih igraca te sezone
SELECT AVG(PTS)
FROM PLAYER_SEASON;

--3.2 prosjecan zbroj zabijenih poena po utakmici
SELECT AVG(SCORE_HOME_TEAM + SCORE_AWAY_TEAM)
FROM GAME;

--3.3 najvise uhvacenih skokova jednog igraca u jednoj utakmici
SELECT MAX(TRB)
FROM PLAYER_GAME;

--3.4 timovi s najvise igraca kroz sezonu (ukljucujuci tradeove)
SELECT TEAM.NAME, COUNT(PLAYER_ID)
FROM PLAYER
INNER JOIN TEAM USING (TEAM_ID)
GROUP BY TEAM.NAME
ORDER BY COUNT DESC;

--3.5 prosjecan broj skokova svih igraca kroz sezonu
SELECT AVG(TRB)
FROM PLAYER_SEASON;

-- 4.

--4.1 najveci broj poena zabijen u svim utakmicama sezone
SELECT NAME, PTS, GAME_ID
FROM PLAYER_GAME
INNER JOIN PLAYER USING (PLAYER_ID)
WHERE PTS = (SELECT MAX(PTS) FROM PLAYER_GAME);

--4.2 za svaku utakmicu ko je zabio najvise poena, MOZE VISE OD JEDNOG IGRACA IMATI ISTI MAX BROJ POENA
SELECT PLAYER_GAME.GAME_ID, PLAYER.NAME, PTS
FROM PLAYER_GAME
JOIN
	(SELECT GAME_ID, MAX(PTS) AS MAX_PTS
	FROM PLAYER_GAME
	GROUP BY GAME_ID) AS ABC
	ON PLAYER_GAME.GAME_ID = ABC.GAME_ID AND PTS = MAX_PTS
INNER JOIN PLAYER USING (PLAYER_ID)
ORDER BY PLAYER_GAME.GAME_ID;

--4.3 svi igraci koji imaju prosjek poena veci od prosjeka
SELECT PTS , NAME
FROM PLAYER_SEASON
INNER JOIN PLAYER USING (PLAYER_ID)
WHERE PTS > (SELECT AVG(PTS) FROM PLAYER_SEASON)
ORDER BY PTS DESC;

--4.4 svi timovi koji imaju vise pobjeda od prosjeka
SELECT *
FROM TEAM_SEASON
INNER JOIN TEAM USING (TEAM_ID)
WHERE TEAM_SEASON.WINS > (SELECT AVG(WINS) FROM TEAM_SEASON)
ORDER BY TEAM_SEASON.WINS DESC;

--4.5 odabire sve igrace koji u prosjeku imaju vise od 20 poena po utakmici
		-- pa iz tog skupa izbacuje one koji imaju manje od 5 skokova
SELECT PLAYER.NAME, PTS, TRB
FROM (SELECT *
FROM PLAYER_SEASON
WHERE PTS > 20
EXCEPT
SELECT *
FROM PLAYER_SEASON
WHERE TRB < 5)
INNER JOIN PLAYER USING (PLAYER_ID)
ORDER BY PTS DESC, TRB DESC;


-- 5.

-- 5.1 Ako tim nema pobjeda ili poraza unesenih postavi na 0
ALTER TABLE Team_Season
ALTER COLUMN wins SET DEFAULT 0;

ALTER TABLE Team_Season
ALTER COLUMN losses SET DEFAULT 0;

-- 5.2 Ako broj poena ili skokova ili asistencija nije unesen za utakmicu postavi na 0
ALTER TABLE Player_Game
ALTER COLUMN pts SET DEFAULT 0,
ALTER COLUMN trb SET DEFAULT 0,
ALTER COLUMN ast SET DEFAULT 0;

-- 5.3 Ako postotci suta nisu uneseni postavi na 0.000
ALTER TABLE Player_Game
ALTER COLUMN fg_pct SET DEFAULT 0.000,
ALTER COLUMN fg3_pct SET DEFAULT 0.000,
ALTER COLUMN ft_pct SET DEFAULT 0.000;

ALTER TABLE Player_Season
ALTER COLUMN pts SET DEFAULT 0,
ALTER COLUMN trb SET DEFAULT 0,
ALTER COLUMN ast SET DEFAULT 0,
ALTER COLUMN fg_pct SET DEFAULT 0.000,
ALTER COLUMN fg3_pct SET DEFAULT 0.000,
ALTER COLUMN ft_pct SET DEFAULT 0.000,
ALTER COLUMN efg_pct SET DEFAULT 0.000;

-- 5.4 Ako se ne zna prvak ili mvp postavi na 'Unknown'
ALTER TABLE Season
ALTER COLUMN champion SET DEFAULT 'Unknown',
ALTER COLUMN mvp SET DEFAULT 'Unknown';



-- 6.


-- 6.1 Na Team_Season: pobjede i porazi ne mogu biti negativni brojevi
ALTER TABLE Team_Season
ADD CONSTRAINT chk_wins_nonnegative CHECK (wins >= 0);
ALTER TABLE Team_Season
ADD CONSTRAINT chk_losses_nonnegative CHECK (losses >= 0);
-- 6.2 Na Player_Game i Player_Season: poeni, skokovi i asistencije ne mogu biti negativni
ALTER TABLE Player_Game
ADD CONSTRAINT chk_pts_nonnegative CHECK (pts >= 0);

ALTER TABLE Player_Game
ADD CONSTRAINT chk_trb_nonnegative CHECK (trb >= 0);

ALTER TABLE Player_Game
ADD CONSTRAINT chk_ast_nonnegative CHECK (ast >= 0);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_pts_season_nonnegative CHECK (pts >= 0);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_trb_season_nonnegative CHECK (trb >= 0);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_ast_season_nonnegative CHECK (ast >= 0);

-- 6.3 Postotci suta (fg_pct, fg3_pct, ft_pct, efg_pct) moraju biti između 0 i 1
ALTER TABLE Player_Game
ADD CONSTRAINT chk_fg_pct_range CHECK (fg_pct BETWEEN 0 AND 1);

ALTER TABLE Player_Game
ADD CONSTRAINT chk_fg3_pct_range CHECK (fg3_pct BETWEEN 0 AND 1);

ALTER TABLE Player_Game
ADD CONSTRAINT chk_ft_pct_range CHECK (ft_pct BETWEEN 0 AND 1);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_fg_pct_season_range CHECK (fg_pct BETWEEN 0 AND 1);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_fg3_pct_season_range CHECK (fg3_pct BETWEEN 0 AND 1);

ALTER TABLE Player_Season
ADD CONSTRAINT chk_ft_pct_season_range CHECK (ft_pct BETWEEN 0 AND 1);
ALTER TABLE Player_Season
ADD CONSTRAINT chk_efg_pct_season_range CHECK (efg_pct BETWEEN 0 AND 1);




-- 7.

COMMENT ON TABLE Team IS 'Tablica koja sadrži NBA timove';
COMMENT ON TABLE Player IS 'Tablica s informacijama o igračima i njihovim timovima';
COMMENT ON TABLE Season IS 'Tablica s podacima o NBA sezonama, prvacima i MVP-ovima';
COMMENT ON TABLE Game IS 'Tablica s podacima o utakmicama, rezultatima i sezoni';
COMMENT ON TABLE Team_Season IS 'Povezna tablica koja prikazuje rezultate timova po sezonama';
COMMENT ON TABLE Player_Game IS 'Statistički podaci igrača za pojedinačne utakmice';
COMMENT ON TABLE Player_Season IS 'Statistički podaci igrača za cijelu sezonu';


-- 8.

CREATE INDEX idx_player_game_player_id ON Player_Game(player_id);
CREATE INDEX idx_player_game_game_id ON Player_Game(game_id);

CREATE INDEX idx_player_season_player_id ON Player_Season(player_id);


-- 9.

-- 9.1
CREATE OR REPLACE PROCEDURE UpdatePlayerPointsByName(
    p_player_name TEXT,
    p_new_pts NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE PLAYER_SEASON
    SET PTS = p_new_pts
    WHERE PLAYER_ID = (
        SELECT PLAYER_ID FROM PLAYER WHERE NAME = p_player_name
    );

    IF NOT FOUND THEN
        RAISE NOTICE 'Igrac s imenom % nije pronaden', p_player_name;
    END IF;
END;
$$;

CALL UpdatePlayerPointsByName('LeBron James', 28.9);

SELECT * 
FROM PLAYER
INNER JOIN PLAYER_SEASON USING (PLAYER_ID)
WHERE NAME = 'LeBron James'


-- 9.2
CREATE OR REPLACE PROCEDURE AddNewTeam(
    p_team_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM TEAM WHERE NAME = p_team_name) THEN
        RAISE NOTICE 'Tim s imenom "%" vec postoji', p_team_name;
    ELSE
        INSERT INTO TEAM (NAME)
        VALUES (p_team_name);
        RAISE NOTICE 'Tim "%" je uspjesno dodan', p_team_name;
    END IF;
END;
$$;

CALL AddNewTeam('Albuquerque Armadillos');

SELECT *
FROM TEAM
WHERE NAME = 'Albuquerque Armadillos'


-- 10.

-- 10.1
CREATE OR REPLACE FUNCTION check_scores_nonnegative()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.score_home_team < 0 THEN
        RAISE EXCEPTION 'Rezultat domaceg tima ne moze biti negativan';
    END IF;
    IF NEW.score_away_team < 0 THEN
        RAISE EXCEPTION 'Rezultat gostujuceg tima ne moze biti negativan';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_scores_nonnegative
BEFORE INSERT OR UPDATE ON Game
FOR EACH ROW
EXECUTE FUNCTION check_scores_nonnegative();

-- 10.2
CREATE OR REPLACE FUNCTION prevent_season_delete()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Brisanje iz tablice Season nije dozvoljeno';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_season_delete
BEFORE DELETE ON SEASON
FOR EACH ROW
EXECUTE FUNCTION prevent_season_delete();

DELETE FROM SEASON WHERE SEASON_ID = 1;
