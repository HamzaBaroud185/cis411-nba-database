DROP TABLE IF EXISTS stats;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS coaches;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS league;
--- Creating all the tables 
CREATE TABLE league (
    conference_id SERIAL PRIMARY KEY,
    conference VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    rank INT,
    conference_id INT NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES league(conference_id)
);

CREATE TABLE coaches (
    coach_id SERIAL PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    team_id INT UNIQUE NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE stats (
    stats_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    points_per_game DECIMAL(5,2),
    games_played INT,
    three_points_per_game DECIMAL(5,2),
    field_goal_per_game DECIMAL(5,2),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

--- Retrive coach for a specific team
SELECT c.coach_name
FROM coaches c
JOIN teams t ON c.team_id = t.team_id
WHERE t.team_name = 'Lakers';

--- Retrieve all players for a specific team
SELECT p.player_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
WHERE t.team_name = 'Celtics';

--- Most points per game for a team
SELECT p.player_name, t.team_name, MAX(s.points_per_game) AS max_ppg
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN stats s ON p.player_id = s.player_id
WHERE t.team_name = 'Lakers'
GROUP BY p.player_name, t.team_name
ORDER BY max_ppg DESC;

--- Most games played for a team
SELECT p.player_name, t.team_name, MAX(s.games_played) AS most_games
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN stats s ON p.player_id = s.player_id
WHERE t.team_name = 'Lakers'
GROUP BY p.player_name, t.team_name
ORDER BY most_games DESC;

--- Highest points per game across the league
SELECT p.player_name, l.conference, t.team_name, s.points_per_game
FROM players p
JOIN stats s ON p.player_id = s.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN league l ON t.conference_id = l.conference_id
ORDER BY s.points_per_game DESC;

--- Retrieve all player data across the league
SELECT
    p.player_name,
    c.coach_name,
    t.team_name,
    l.conference,
    s.field_goal_per_game
FROM players p
JOIN stats s ON p.player_id = s.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN league l ON t.conference_id = l.conference_id
JOIN coaches c ON t.team_id = c.team_id;



