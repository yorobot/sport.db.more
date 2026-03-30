# (JSON) APIs (JSON)

Try some football (JSON) APIs for the worldcup & friends

## Todos

- [ ] check missing score in cwc 2025 !!
```
  18:00 UTC-4   CF Pachuca    FC Salzburg   @ TQL Stadium, Cincinnati
                  (Bryan GONZALEZ 56';
                   Oscar GLOUKH 42', Karim ONISIWO 76')

```


## Unofficial FIFA

<https://api.fifa.com/api/v3/calendar/matches?count=100&idSeason=255711>


FIFA World Cup 2026  

<https://api.fifa.com/api/v3/calendar/matches?count=500&idSeason=285023&language=en>

<https://api.fifa.com/api/v3/stages?idSeason=285023&language=en>



 match data via fifa api
brazil 2014
see <https://www.fifa.com/en/match-centre?date=2014-06-12>
uruguay 1930 
see <https://www.fifa.com/en/match-centre?date=1930-07-13>


docu via <https://givevoicetofootball.github.io/api/>



```
To get ALL seasons for a FIFA Tournament (for example FU20 Women’s World Cup):
API_ROOT/seasons/search?name=FIFA%20U-20%20Women%20World%20Cup

To get the details of a specific season:
API_ROOT/seasons/278491

To get ALL Stages of the season:
API_ROOT/stages?idSeason=278491&idCompetition=108

To get all the Squad of the season:
API_ROOT/teams/squads/all/108/278491

To retrieve all players:
API_ROOT/players/seasons/278491?count=1000

To retrieve all coaches:
API_ROOT/coaches/season/278491

To get ALL matches:
API_ROOT/calendar/matches?idSeason=278491&idCompetition=108&count=100

To get matches for a specific stage:
API_ROOT/calendar/matches?idSeason=278491&idCompetition=108&idStage=278493

To get the standings for a Stage:
API_ROOT/calendar/108/278491/278493/Standing

To get the standings for a specific Group:
API_ROOT/calendar/108/278491/278493/Standing?idGroup=278497

To get the line-ups of a Match:
API_ROOT/live/football/108/278491/278493/300424860?language=en-GB

To get the timeline (live events) of a Match:
API_ROOT/timelines/108/278491/278493/300424860?language=en-GB

To get the Season stats:
API_ROOT/topseasonplayerstatistics/season/278491/topscorers

API_ROOT/topseasonteamstatistics/season/278491/topscorers

To get Team or Player stats:
API_ROOT/seasonstatistics/season/278491/team/1888591

API_ROOT/seasonstatistics/season/278491/team/1888591/players

```
