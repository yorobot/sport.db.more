# Notes


## Wikipedia Pages


```
-- player_appearances
-- one observation per player per team per match per tournament
CREATE TABLE player_appearances(
  tournament_id TEXT NOT NULL,
  match_id TEXT NOT NULL,
  team_id TEXT NOT NULL,
  home_team BOOLEAN,
  away_team BOOLEAN,
  player_id TEXT NOT NULL,
  shirt_number INTEGER,
  position_name TEXT,
  position_code TEXT,
  starter BOOLEAN,
  substitute BOOLEAN,
  PRIMARY KEY (tournament_id, match_id, team_id, player_id),
  FOREIGN KEY (tournament_id) REFERENCES tournaments (tournament_id),
  FOREIGN KEY (match_id) REFERENCES matches (match_id),
  FOREIGN KEY (team_id) REFERENCES teams (team_id),
  FOREIGN KEY (player_id) REFERENCES players (player_id)
);
```




```
C:.
│   DESCRIPTION
│   NAMESPACE
│   README.md
│
├───codebook
│   ├───code
│   │       make-codebook.R
│   │
│   ├───csv
│   │       datasets.csv
│   │       variables.csv
│   │
│   └───pdf
│           world-cup-codebook.pdf
│           world-cup-codebook.tex
│
├───data
│       awards.RData
│       award_winners.RData
│       bookings.RData
│       confederations.RData
│       datasets.RData
│       goals.RData
│       groups.RData
│       group_standings.RData
│       host_countries.RData
│       managers.RData
│       manager_appearances.RData
│       manager_appointments.RData
│       matches.RData
│       penalty_kicks.RData
│       players.RData
│       player_appearances.RData
│       qualified_teams.RData
│       referees.RData
│       referee_appearances.RData
│       referee_appointments.RData
│       squads.RData
│       stadiums.RData
│       substitutions.RData
│       teams.RData
│       team_appearances.RData
│       tournaments.RData
│       tournament_stages.RData
│       tournament_standings.RData
│       variables.RData
│
├───data-csv
│       awards.csv
│       award_winners.csv
│       bookings.csv
│       confederations.csv
│       goals.csv
│       groups.csv
│       group_standings.csv
│       host_countries.csv
│       managers.csv
│       manager_appearances.csv
│       manager_appointments.csv
│       matches.csv
│       penalty_kicks.csv
│       players.csv
│       player_appearances.csv
│       qualified_teams.csv
│       referees.csv
│       referee_appearances.csv
│       referee_appointments.csv
│       squads.csv
│       stadiums.csv
│       substitutions.csv
│       teams.csv
│       team_appearances.csv
│       tournaments.csv
│       tournament_stages.csv
│       tournament_standings.csv
│
├───data-json
│       worldcup.json
│
├───data-raw
│   ├───code
│   │       build-database-csv.R
│   │       build-database-json.R
│   │       build-database-sqlite.R
│   │       build-database.R
│   │       parse-wikipedia-match-pages.R
│   │       parse-wikipedia-squad-pages.R
│   │
│   ├───hand-coded-tables
│   │       awards.csv
│   │       award_winners.csv
│   │       confederations.csv
│   │       group_standings.csv
│   │       host_countries.csv
│   │       matches.csv
│   │       stadiums.csv
│   │       teams.csv
│   │       tournaments.csv
│   │       tournament_stages.csv
│   │       tournament_standings.csv
│   │
│   ├───manager-names
│   │       manager_names_cleaned.csv
│   │
│   ├───player-names
│   │       player_names_men_cleaned.csv
│   │       player_names_women_cleaned.csv
│   │       squads_supplement.csv
│   │
│   ├───referee-names
│   │       referee_names_cleaned.csv
│   │
│   ├───Wikipedia-awards-page
│   │       men-awards.html
│   │       women-awards.html
│   │
│   ├───Wikipedia-data
│   │       wikipedia_goals.RData
│   │       wikipedia_lineups.RData
│   │       wikipedia_managers.RData
│   │       wikipedia_matches.RData
│   │       wikipedia_penalty_kicks.RData
│   │       wikipedia_referees.RData
│   │       wikipedia_squads.RData
│   │
│   ├───Wikipedia-match-pages
│   │       men-1930-group-1.html
│   │       men-1930-group-2.html
│   │       men-1930-group-3.html
│   │       men-1930-group-4.html
│   │       men-1930-knockout-stage.html
│   │       men-1934-final-tournament.html
│   │       men-1938-final-tournament.html
│   │       men-1950-final-round.html
│   │       men-1950-group-1.html
│   │       men-1950-group-2.html
│   │       men-1950-group-3.html
│   │       men-1950-group-4.html
│   │       men-1954-group-1.html
│   │       men-1954-group-2.html
│   │       men-1954-group-3.html
│   │       men-1954-group-4.html
│   │       men-1954-knockout-stage.html
│   │       men-1958-group-1.html
│   │       men-1958-group-2.html
│   │       men-1958-group-3.html
│   │       men-1958-group-4.html
│   │       men-1958-knockout-stage.html
│   │       men-1962-group-1.html
│   │       men-1962-group-2.html
│   │       men-1962-group-3.html
│   │       men-1962-group-4.html
│   │       men-1962-knockout-stage.html
│   │       men-1966-group-1.html
│   │       men-1966-group-2.html
│   │       men-1966-group-3.html
│   │       men-1966-group-4.html
│   │       men-1966-knockout-stage.html
│   │       men-1970-group-1.html
│   │       men-1970-group-2.html
│   │       men-1970-group-3.html
│   │       men-1970-group-4.html
│   │       men-1970-knockout-stage.html
│   │       men-1974-group-1.html
│   │       men-1974-group-2.html
│   │       men-1974-group-3.html
│   │       men-1974-group-4.html
│   │       men-1974-group-A.html
│   │       men-1974-group-B.html
│   │       men-1974-knockout-stage.html
│   │       men-1978-group-1.html
│   │       men-1978-group-2.html
│   │       men-1978-group-3.html
│   │       men-1978-group-4.html
│   │       men-1978-group-A.html
│   │       men-1978-group-B.html
│   │       men-1978-knockout-stage.html
│   │       men-1982-group-1.html
│   │       men-1982-group-2.html
│   │       men-1982-group-3.html
│   │       men-1982-group-4.html
│   │       men-1982-group-5.html
│   │       men-1982-group-6.html
│   │       men-1982-group-A.html
│   │       men-1982-group-B.html
│   │       men-1982-group-C.html
│   │       men-1982-group-D.html
│   │       men-1982-knockout-stage.html
│   │       men-1986-group-A.html
│   │       men-1986-group-B.html
│   │       men-1986-group-C.html
│   │       men-1986-group-D.html
│   │       men-1986-group-E.html
│   │       men-1986-group-F.html
│   │       men-1986-knockout-stage.html
│   │       men-1990-group-A.html
│   │       men-1990-group-B.html
│   │       men-1990-group-C.html
│   │       men-1990-group-D.html
│   │       men-1990-group-E.html
│   │       men-1990-group-F.html
│   │       men-1990-knockout-stage.html
│   │       men-1994-group-A.html
│   │       men-1994-group-B.html
│   │       men-1994-group-C.html
│   │       men-1994-group-D.html
│   │       men-1994-group-E.html
│   │       men-1994-group-F.html
│   │       men-1994-knockout-stage.html
│   │       men-1998-group-A.html
│   │       men-1998-group-B.html
│   │       men-1998-group-C.html
│   │       men-1998-group-D.html
│   │       men-1998-group-E.html
│   │       men-1998-group-F.html
│   │       men-1998-group-G.html
│   │       men-1998-group-H.html
│   │       men-1998-knockout-stage.html
│   │       men-2002-group-A.html
│   │       men-2002-group-B.html
│   │       men-2002-group-C.html
│   │       men-2002-group-D.html
│   │       men-2002-group-E.html
│   │       men-2002-group-F.html
│   │       men-2002-group-G.html
│   │       men-2002-group-H.html
│   │       men-2002-knockout-stage.html
│   │       men-2006-group-A.html
│   │       men-2006-group-B.html
│   │       men-2006-group-C.html
│   │       men-2006-group-D.html
│   │       men-2006-group-E.html
│   │       men-2006-group-F.html
│   │       men-2006-group-G.html
│   │       men-2006-group-H.html
│   │       men-2006-knockout-stage.html
│   │       men-2010-group-A.html
│   │       men-2010-group-B.html
│   │       men-2010-group-C.html
│   │       men-2010-group-D.html
│   │       men-2010-group-E.html
│   │       men-2010-group-F.html
│   │       men-2010-group-G.html
│   │       men-2010-group-H.html
│   │       men-2010-knockout-stage.html
│   │       men-2014-group-A.html
│   │       men-2014-group-B.html
│   │       men-2014-group-C.html
│   │       men-2014-group-D.html
│   │       men-2014-group-E.html
│   │       men-2014-group-F.html
│   │       men-2014-group-G.html
│   │       men-2014-group-H.html
│   │       men-2014-knockout-stage.html
│   │       men-2018-group-A.html
│   │       men-2018-group-B.html
│   │       men-2018-group-C.html
│   │       men-2018-group-D.html
│   │       men-2018-group-E.html
│   │       men-2018-group-F.html
│   │       men-2018-group-G.html
│   │       men-2018-group-H.html
│   │       men-2018-knockout-stage.html
│   │       men-2022-group-A.html
│   │       men-2022-group-B.html
│   │       men-2022-group-C.html
│   │       men-2022-group-D.html
│   │       men-2022-group-E.html
│   │       men-2022-group-F.html
│   │       men-2022-group-G.html
│   │       men-2022-group-H.html
│   │       men-2022-knockout-stage.html
│   │       women-1991-group-A.html
│   │       women-1991-group-B.html
│   │       women-1991-group-C.html
│   │       women-1991-knockout-stage.html
│   │       women-1995-group-A.html
│   │       women-1995-group-B.html
│   │       women-1995-group-C.html
│   │       women-1995-knockout-stage.html
│   │       women-1999-group-A.html
│   │       women-1999-group-B.html
│   │       women-1999-group-C.html
│   │       women-1999-group-D.html
│   │       women-1999-knockout-stage.html
│   │       women-2003-group-A.html
│   │       women-2003-group-B.html
│   │       women-2003-group-C.html
│   │       women-2003-group-D.html
│   │       women-2003-knockout-stage.html
│   │       women-2007-group-A.html
│   │       women-2007-group-B.html
│   │       women-2007-group-C.html
│   │       women-2007-group-D.html
│   │       women-2007-knockout-stage.html
│   │       women-2011-group-A.html
│   │       women-2011-group-B.html
│   │       women-2011-group-C.html
│   │       women-2011-group-D.html
│   │       women-2011-knockout-stage.html
│   │       women-2015-group-A.html
│   │       women-2015-group-B.html
│   │       women-2015-group-C.html
│   │       women-2015-group-D.html
│   │       women-2015-group-E.html
│   │       women-2015-group-F.html
│   │       women-2015-knockout-stage.html
│   │       women-2019-group-A.html
│   │       women-2019-group-B.html
│   │       women-2019-group-C.html
│   │       women-2019-group-D.html
│   │       women-2019-group-E.html
│   │       women-2019-group-F.html
│   │       women-2019-knockout-stage.html
│   │
│   ├───Wikipedia-squad-pages
│   │       men-1930-squads.html
│   │       men-1934-squads.html
│   │       men-1938-squads.html
│   │       men-1950-squads.html
│   │       men-1954-squads.html
│   │       men-1958-squads.html
│   │       men-1962-squads.html
│   │       men-1966-squads.html
│   │       men-1970-squads.html
│   │       men-1974-squads.html
│   │       men-1978-squads.html
│   │       men-1982-squads.html
│   │       men-1986-squads.html
│   │       men-1990-squads.html
│   │       men-1994-squads.html
│   │       men-1998-squads.html
│   │       men-2002-squads.html
│   │       men-2006-squads.html
│   │       men-2010-squads.html
│   │       men-2014-squads.html
│   │       men-2018-squads.html
│   │       men-2022-squads.html
│   │       women-1991-squads.html
│   │       women-1995-squads.html
│   │       women-1999-squads.html
│   │       women-2003-squads.html
│   │       women-2007-squads.html
│   │       women-2011-squads.html
│   │       women-2015-squads.html
│   │       women-2019-squads.html
│   │
│   └───Wikipedia-tournament-pages
│           men-1930-tournament.html
│           men-1934-tournament.html
│           men-1938-tournament.html
│           men-1950-tournament.html
│           men-1954-tournament.html
│           men-1958-tournament.html
│           men-1962-tournament.html
│           men-1966-tournament.html
│           men-1970-tournament.html
│           men-1974-tournament.html
│           men-1978-tournament.html
│           men-1982-tournament.html
│           men-1986-tournament.html
│           men-1990-tournament.html
│           men-1994-tournament.html
│           men-1998-tournament.html
│           men-2002-tournament.html
│           men-2006-tournament.html
│           men-2010-tournament.html
│           men-2014-tournament.html
│           men-2018-tournament.html
│           men-2022-tournament.html
│           women-1991-tournament.html
│           women-1995-tournament.html
│           women-1999-tournament.html
│           women-2003-tournament.html
│           women-2007-tournament.html
│           women-2011-tournament.html
│           women-2015-tournament.html
│           women-2019-tournament.html
│
├───data-sqlite
│       SQL-schema.txt
│       worldcup.db
│
```



- [ ]  check <https://en.wikipedia.org/wiki/1978_FIFA_World_Cup_Group_1>