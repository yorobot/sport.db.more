module Footballdata

  LEAGUES = {
    'eng.1' => 'PL',     # incl. team(s) from wales
    'eng.2' => 'ELC',
     # PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 31
     #  ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 38
     #
     # 2019 => 2019/20
     # 2018 => 2018/19
     # 2017 => xxx 2017-18 - requires subscription !!!

    'es.1'  => 'PD',
    # PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 31

    'pt.1'  => 'PPL',
    # PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 28

    'de.1'  => 'BL1',
    # BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34

    'nl.1'  => 'DED',
    # DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34

    'fr.1'  => 'FL1',    # incl. team(s) monaco
    # FL1 - Ligue 1, France
    #   9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
    #
    # 2019 => 2019/20
    # 2018 => 2018/19
    # 2017 => xxx 2017-18 - requires subscription !!!

    'it.1'  => 'SA',
    # SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 27

    'br.1'  => 'BSA',
    # BSA - Série A, Brazil
    #   4 seasons | 2020-05-03 - 2020-12-06 / matchday 10
    #
    #  2020 => 2020
    #  2019 => 2019
    #  2018 => 2018
    #  2017 => xxx 2017 - requires subscription !!!

    ## todo/check: use champs and NOT cl - why? why not?
    'uefa.cl'        => 'CL',    ## note: cl is country code for chile!! - use champs - why? why not?
    ##  was europe.cl / cl  
    
    ## Copa Libertadores
    'copa.l'  => 'CLI',
 
    ############
    ## national teams
    'euro'  => 'EC',
    'world' => 'WC',

  }
end   #  module Footballdata


__END__

## 13 competitions

Campeonato Brasileiro Série A
    "code": "BSA",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2024-04-13",
      "endDate": "2024-12-08",
      "currentMatchday": 7,
      "winner": null
  
Championship
    "code": "ELC",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2023-08-04",
      "endDate": "2024-05-04",
      "currentMatchday": 46,
      "winner": null
  
Premier League
    "code": "PL",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 37,
      "winner": null

      
UEFA Champions League
    "code": "CL",
    "type": "CUP",
    "currentSeason":
      "startDate": "2023-09-19",
      "endDate": "2024-06-01",
      "currentMatchday": 6,
      "winner": null

      
European Championship
    "code": "EC",
    "type": "CUP",
    "currentSeason":
      "startDate": "2024-06-14",
      "endDate": "2024-07-14",
      "currentMatchday": 1,
      "winner": null

      
Ligue 1
    "code": "FL1",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 33,
      "winner": null
 
 Bundesliga
    "code": "BL1",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-18",
      "endDate": "2024-05-18",
      "currentMatchday": 34,
      "winner": null
  
Serie A
    "code": "SA",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2023-08-19",
      "endDate": "2024-05-26",
      "currentMatchday": 37,
      "winner": null

Eredivisie
    "code": "DED",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 34,
      "winner": null
 
 Primeira Liga
    "code": "PPL",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2023-08-13",
      "endDate": "2024-05-19",
      "currentMatchday": 34,
      "winner": null
 

Copa Libertadores
    "code": "CLI",
    "type": "CUP",
    "currentSeason": 
      "startDate": "2024-02-07",
      "endDate": "2024-05-31",
      "currentMatchday": 5,
      "winner": null
  

  Primera Division
    "code": "PD",
    "type": "LEAGUE",
    "currentSeason": 
      "startDate": "2023-08-13",
      "endDate": "2024-05-26",
      "currentMatchday": 37,
      "winner": null
 
  FIFA World Cup
    "code": "WC",
    "type": "CUP",
    "currentSeason": 
      "startDate": "2022-11-20",
      "endDate": "2022-12-18",
      "currentMatchday": 8,
      "winner": 
        "name": "Argentina",
      