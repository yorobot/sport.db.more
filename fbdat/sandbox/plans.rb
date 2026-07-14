require_relative 'helper'



# data = Footballdata::Metal.competitions( auth: false )   ## get all
data = Footballdata::Metal.competitions( auth: true )   ## get free tier (TIER_ONE) with auth (token)
pp data

puts "bye"



__END__

club leagues

==> England (ENG) - Premier League (PL) -- TIER_ONE LEAGUE, 126 season(s)
     2024-08-16 - 2025-05-25 @ 1
==> England (ENG) - Championship (ELC) -- TIER_ONE LEAGUE, 8 season(s)
     2024-08-09 - 2025-05-03 @ 1
==> France (FRA) - Ligue 1 (FL1) -- TIER_ONE LEAGUE, 81 season(s)
     2024-08-18 - 2025-05-18 @ 1
==> Germany (DEU) - Bundesliga (BL1) -- TIER_ONE LEAGUE, 61 season(s)
     2023-08-18 - 2024-05-18 @ 34
==> Italy (ITA) - Serie A (SA) -- TIER_ONE LEAGUE, 92 season(s)
     2023-08-19 - 2024-06-02 @ 38
==> Netherlands (NLD) - Eredivisie (DED) -- TIER_ONE LEAGUE, 69 season(s)
     2024-08-09 - 2025-05-18 @ 1
==> Portugal (POR) - Primeira Liga (PPL) -- TIER_ONE LEAGUE, 75 season(s)
     2023-08-13 - 2024-05-19 @ 34
==> Spain (ESP) - Primera Division (PD) -- TIER_ONE LEAGUE, 94 season(s)
     2024-08-18 - 2025-05-25 @ 1

==> Brazil (BRA) - Campeonato Brasileiro Série A (BSA) -- TIER_ONE LEAGUE, 8 season(s)
     2024-04-13 - 2024-12-08 @ 13


club int'l cups
==> Europe (EUR) - UEFA Champions League (CL) -- TIER_ONE CUP, 44 season(s)
     2023-09-19 - 2024-06-01 @ 6
==> South America (SAM) - Copa Libertadores (CLI) -- TIER_ONE CUP, 4 season(s)
     2024-02-07 - 2024-05-31 @ 6

national teams
==> Europe (EUR) - European Championship (EC) -- TIER_ONE CUP, 17 season(s)
     2024-06-14 - 2024-07-14 @ 4
==> World (INT) - FIFA World Cup (WC) -- TIER_ONE CUP, 22 season(s)
     2022-11-20 - 2022-12-18 @ 8


---

Premier League
    "code": "PL",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 37,

Championship
    "code": "ELC",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-04",
      "endDate": "2024-05-04",
      "currentMatchday": 46,

Ligue 1
    "code": "FL1",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 33,

 Bundesliga
    "code": "BL1",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-18",
      "endDate": "2024-05-18",
      "currentMatchday": 34,

Serie A
    "code": "SA",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-19",
      "endDate": "2024-05-26",
      "currentMatchday": 37,

Eredivisie
    "code": "DED",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-11",
      "endDate": "2024-05-19",
      "currentMatchday": 34,

 Primeira Liga
    "code": "PPL",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-13",
      "endDate": "2024-05-19",
      "currentMatchday": 34,

  Primera Division
    "code": "PD",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2023-08-13",
      "endDate": "2024-05-26",
      "currentMatchday": 37,

Campeonato Brasileiro Série A
    "code": "BSA",
    "type": "LEAGUE",
    "currentSeason":
      "startDate": "2024-04-13",
      "endDate": "2024-12-08",
      "currentMatchday": 7,


Copa Libertadores
    "code": "CLI",
    "type": "CUP",
    "currentSeason":
      "startDate": "2024-02-07",
      "endDate": "2024-05-31",
      "currentMatchday": 5,

UEFA Champions League
    "code": "CL",
    "type": "CUP",
    "currentSeason":
      "startDate": "2023-09-19",
      "endDate": "2024-06-01",
      "currentMatchday": 6,


European Championship
    "code": "EC",
    "type": "CUP",
    "currentSeason":
      "startDate": "2024-06-14",
      "endDate": "2024-07-14",
      "currentMatchday": 1,

FIFA World Cup
    "code": "WC",
    "type": "CUP",
    "currentSeason":
      "startDate": "2022-11-20",
      "endDate": "2022-12-18",
      "currentMatchday": 8,
