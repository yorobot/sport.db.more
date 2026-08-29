# openliga - openligadb.de api client/wrapper and football.txt format converter


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/openliga](https://rubygems.org/gems/openliga)
* rdoc  :: [rubydoc.info/gems/openliga](http://rubydoc.info/gems/openliga)




## Usage

### OpenLigaDb (JSON) API Calls  via Metal

Use the (to the metal) wrappers in `Òpenliga::Metal` to
make api json calls. Example:

``` ruby
  ### api call - /getavailableleagues
  data = Openliga::Metal.leagues

  ## api call - /getavailableteams/{code}/{year}
  data = Openliga::Metal.teams( 'bl1', 2026 )

  ## api call - /getmatchdata/{code}/{year}
  data = Openliga::Metal.matches( 'bl1', 2026 )

  ## api call - /getgoalgetters/{code}/{year}
  data = Openliga::Metal.goalgetters( 'bl1', 2026 )
```


Note - all json api calls get auto-magically cached locally
by default in `./cache`
e.g.

```
└───api.openligadb.de/
    │   getavailableleagues & getavailableleagues.meta.txt
    │
    ├───getavailableteams/
    │   ├───bl1/
    │   │       2025 & 2025.meta.txt
    │   │       2026 & 2026.meta.txt
    │   │
    │   └───dfb/
    │           2025 & 2025.meta.txt
    │           2026 & 2026.meta.txt
    └───getmatchdata/
        ├───bl1/
        │       2025 & 2025.meta.txt
        │       2026 & 2026.meta.txt
        │
        └───dfb
                2025 & 2025.meta.txt
                2026 & 2026.meta.txt
```

Use `Webcache.root = '<your path here>'` to change the web cache root directory.


To be continued...





### About the Football (Match) Data

Use the `openliga` command-line tool to
(i) download openligadb.de match data (in JSON) and
(ii) convert to the Football.TXT format. Try:

```
$ openliga -h
```

resulting in:

```
Usage: openliga [options] CODE
    -m, --metal           use openligadb.de shortcuts/codes and seasons/years (default: false)
    -o, --output=PATH     write football.txt conversion to output path (default: none)
        --season=SEASON   season (default: none)
```

examples with "common football.txt codes"
e.g. `de.1`, `de.2`, `de.3`, `de.cup`:

```
$ openliga de.1
$ openliga de.cup

$ openliga de.1  --output=2026-27_de.1.txt
$ openliga de.1  --season=2020/21 --output=2020-21_de.1.txt
$ openliga de.cup --season=2025/26 --output=2025-26_de.cup.txt
```

or use the original openligadb.de code/shortcut (and season/year)
with the `-m/--metal` flag:

```
$ openliga bl1 --metal
$ openliga bl1 --metal --season=2020
```



Conversion to Football.TXT Conversion Samples


openliga/2020-21_de.1.txt:

```
###
#  converted from openligadb.de json to Football.TXT
#    for source, see https://api.openligadb.de/getmatchdata/bl1/2020

= 1. Fußball-Bundesliga 2020/2021

▪ 1. Spieltag
Fri Sep 18 2020
  20:30  FC Bayern München  v  FC Schalke 04      8-0 (3-0)  @ Allianz Arena, München
            (1-0  S. Gnabry 4'
             2-0  Goretzka 19'
             3-0  Robert Lewandowski  31' (p)
             4-0  S. Gnabry 47'
             5-0  S. Gnabry 59'
             6-0  T. Müller 69'
             7-0  Sanê 71'
             8-0  Musiala  81')
...
```
or

openliga/2025-26_de.cup.txt:

```
###
#  converted from openligadb.de json to Football.TXT
#    for source, see https://api.openligadb.de/getmatchdata/dfb/2025

= DFB Pokal 2025/2026

▪ 1. Runde
Fri Aug 15 2025
  18:00  FC Gütersloh             v 1. FC Union Berlin         0-5 (0-3)
         1. FC Saarbrücken        v 1. FC Magdeburg            1-3 (0-2)
         SG Sonnenhof Großaspach  v Bayer 04 Leverkusen        0-4 (0-1)
  20:45  DSC Arminia Bielefeld    v Werder Bremen              1-0 (0-0)
Sat Aug 16
  13:00  FK Pirmasens             v Hamburger SV               1-2 (0-0)
         BFC Dynamo               v VfL Bochum                 1-3 (0-0)
  15:30  SV Hemelingen            v VfL Wolfsburg              0-9 (0-3)
         FV Illertissen           v 1. FC Nürnberg             3-3 aet (3-3, 2-0), 9-8 pen
         Eintracht Norderstedt    v FC St. Pauli               0-0 aet (0-0, 0-0), 2-3 pen
         SV Sandhausen            v RB Leipzig                 2-4 (2-2)
         Hansa Rostock            v TSG Hoffenheim             0-4 (0-1)
         Bahlinger SC             v 1. FC Heidenheim 1846      0-5 (0-2)
  18:00  Sportfreunde Lotte       v SC Freiburg                0-2 (0-1)
         VfB Lübeck               v SV Darmstadt 98            1-2 (0-1)
         Energie Cottbus          v Hannover 96                1-0 (1-0)


...

▪ Halbfinale
Wed Apr 22
  20:45  Bayer 04 Leverkusen      v FC Bayern München          0-2 (0-1)
            (0-1  H. Kane 22'
             0-2  Luis Díaz 90+4')
Thu Apr 23
  20:45  VfB Stuttgart            v SC Freiburg                2-1 aet (1-1, 0-1)
            (0-1  M. Eggestein 28'
             1-1  D. Undav 70'
             2-1  T. Tomas 119')

▪ Endspiel
Sat May 23
  20:00  FC Bayern München        v VfB Stuttgart              3-0 (0-0)
            (1-0  H. Kane 55'
             2-0  H. Kane 80'
             3-0  H. Kane 90+2' (p))
```



**What's missing (upstream)?**

the only match status is  `finished: true|false`, that is,
there is no cancelled, annulled, awarded, abandonded, etc.


for goal minutes there is only an `is_overtime: true|false` flag for stoppage/injury/added time -
and while auto-calculation is possible if
recorded as `46+ => 45+1` or `95+ => 90+5`  or such  BUT
some entries are only records  as `45+` or `90+`
resulting in  `45+0` or `90+0`
and, thus,  `45+` or `90+` at best.



for penalty shootouts there is a weirdo way to map to "plain" goals
starting with the after-extra time scor  e.g.

```
SG Sonnenhof Großaspach  v  DSC Arminia Bielefeld      2-2 aet (2-2, 1-2), 5-2 pen
            (...
             3-2  Arbnor Nuraj (p)
             4-2  Luca Molinari (p)
             5-2  Franz Xaver Bleicher (p))

-or-

England  v Spanien                    1-1 aet, 1-1 pen
            (0-1  M. Caldentey 25'
             1-1  Alessia RUSSO 57'
             1-2  P. Guijarro (p)
             2-2  A. Greenwood (p)
             3-2  N. Charles (p)
             4-2  C. Kelly (p))
```

and there's no way to record missed/saved penalties.





**What else?**

weirdo "legacy" match result (duplicate entries) with kind 'Unknown' e.g.

```
!! warn - weirdo 'Unknown/Nachspielzeit' results found  in
- name="DFB Pokal 2025/2026", season="2025", shortcut="dfb"

!! warn - weirdo 'Unknown/nach 90 Minuten' results found in
- name="DFB-Pokal 2023/2024", season="2023", shortcut="dfb"
- name="DFB-Pokal 2022/23", season="2022", shortcut="dfb2022"
- name="DFB-Pokal 2021/22", season="2021", shortcut="dfb2021"
- name="DFB-Pokal 2020/21", season="2020", shortcut="dfb2020"
```


data errors:


```
name="3. Fußball-Bundesliga 2022/2023", season="2022",
!! warn - skipping match with team missing:
{"matchID"=>67822,
 "matchDateTime"=>"2023-09-09T15:30:00",
 "timeZoneID"=>nil,
 "leagueId"=>4570,
 "leagueName"=>"3. Fußball-Bundesliga 2022/2023",
 "leagueSeason"=>2022,
 "leagueShortcut"=>"bl3",
 "matchDateTimeUTC"=>"2023-09-09T13:30:00Z",
 "group"=>{"groupName"=>"4. Spieltag", "groupOrderID"=>4, "groupID"=>40156},
 "team1"=>{"teamId"=>0, "teamName"=>nil, "shortName"=>nil, "teamIconUrl"=>nil, "teamGroupName"=>nil},
 "team2"=>{"teamId"=>0, "teamName"=>nil, "shortName"=>nil, "teamIconUrl"=>nil, "teamGroupName"=>nil},
 "lastUpdateDateTime"=>"2026-05-23T14:41:39.19",
 "matchIsFinished"=>false,  ... }
```



## License

The `openliga` scripts are dedicated to the public domain.
Use as you please with no restrictions whatsoever.
