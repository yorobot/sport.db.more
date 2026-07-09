## Leagues

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