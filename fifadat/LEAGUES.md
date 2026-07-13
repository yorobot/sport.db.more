## Leagues


how to add a new league

- [ ] add to fifadat/config/leagues.csv
- [ ] add to fifadat/api.rb  - COMPETITION_ID
- [ ] for ppconv - add to config.rb


```
uefa champs

UEFA,1,0,1,7,2000001032,UEFA,FRG,UEFA Champions League
UEFA,1,0,1,7,2000001041,UEFA,FRG,UEFA Europa League
UEFA,1,0,1,7,c7b8o53flg36wbuevfzy3lb10,UEFA,FRG,UEFA Conference League


copa liber
CONMEBOL,1,0,1,7,2000001035,CONMEBOL,FRG,CONMEBOL Libertadores
CONMEBOL,1,0,1,7,2000001042,CONMEBOL,FRG,CONMEBOL Sudamericana


mexico
CONCACAF,1,0,2,7,2000000104,CONCACAF,MEX,Liga MX

arg
CONMEBOL,1,0,2,7,2000000128,CONMEBOL,ARG,Liga Profesional Argentina


bra
CONMEBOL,1,0,2,7,2000000078,CONMEBOL,BRA,Serie A



de
es
UEFA,1,0,2,7,2000000037,UEFA,ESP,Primera División

it

UEFA,1,0,2,7,6694fff47wqxl10lrd9tb91f8,UEFA,ITA,Coppa Italia
UEFA,1,0,2,7,2000000026,UEFA,ITA,Serie A


fr
UEFA,1,0,2,7,2000000018,UEFA,FRA,Ligue 1



at cup ??

UEFA,1,0,2,7,1ncmha8yglhyyhg6gtaujymqf,UEFA,AUT,Cup
UEFA,1,0,2,7,2000000005,UEFA,AUT,Bundesliga


de cup ??

UEFA,1,0,2,7,486rhdgz7yc0sygziht7hje65,UEFA,GER,DFB Pokal
UEFA,1,0,2,7,2000000019,UEFA,GER,Bundesliga

```


try at (austria)

```
$ ruby ppdebug.rb at
$ ruby ppmatch.rb at --season=2025-26
$ ruby ppmatch.rb at --season=2025-26 --full

$ ruby ppconv.rb at --season=2025-26
```



```
stats:{
 "MatchStatus"=>{0=>195},
 "ResultType"=>{1=>193, 4=>2},
 "Leg"=>{nil=>195},
 "IsHomeMatch"=>{nil=>195},
 "MatchDay"=>{true=>192, false=>3},
 "MatchNumber"=>{false=>195},
 "Attendance"=>{true=>192, false=>3},
 "Weather"=>{false=>195}
 }

note - use MatchDay

false => 3 !!!   play off finals have no matchday!!

   "MatchDay": "1",
    "StageName": [{"Locale": "en-gb", "Description": "Regular Season"}],

   "MatchDay": "10",
    "StageName": [{"Locale": "en-gb", "Description": "Championship Round"}],

  "MatchDay": null,
    "StageName":
     [{"Locale": "en-gb",
       "Description": "Conference League Play-offs - Final"}],


```