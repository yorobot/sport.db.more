
require_relative 'helper'


## try status api call
## pp ApiFootball::Metal.status


## pp ApiFootball::Metal.leagues
## pp ApiFootball::Metal.venues

=begin
 "league": {
        "id": 218,
        "name": "Bundesliga",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/218.png"
      },
      "country": {
        "name": "Austria",
        "code": "AT",
        "flag": "https://media.api-sports.io/flags/at.svg"
      },
     
=end
## e.g. 2024/25 => 2024 (MUST use start year of season)
AT1 = 218 

# pp ApiFootball::Metal.fixtures( league: AT1, season: 2023 )

=begin
"league": {
    "id": 2,
    "name": "UEFA Champions League",
    "type": "Cup",
    "logo": "https://media.api-sports.io/football/leagues/2.png"
  },
  "country": {
    "name": "World",
=end

## Free plans do not have access to this season, try from 2021 to 2023
## CL = 2
## pp ApiFootball::Metal.fixtures( league: CL, season: 2023 )

=begin
        "id": 13,
        "name": "CONMEBOL Libertadores",
        "type": "Cup",
        "logo": "https://media.api-sports.io/football/leagues/13.png"
      },
      "country": {
        "name": "World",
=end

##
## "Free plans do not have access to this season, try from 2021 to 2023."}

# LIBERTADORES = 13
# pp ApiFootball::Metal.fixtures( league: LIBERTADORES, season: 2023 )

## Free plans do not have access to this season, try from 2021 to 2023.

=begin
        "id": 262,
        "name": "Liga MX",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/262.png"
      },
      "country": {
        "name": "Mexico",
        "code": "MX",

=end

# MX1 = 262
# pp ApiFootball::Metal.fixtures( league: MX1, season: 2023 )

=begin
       "id": 144,
        "name": "Jupiler Pro League",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/144.png"
      },
      "country": {
        "name": "Belgium",
=end
BE1 = 144
pp ApiFootball::Metal.fixtures( league: BE1, season: 2023 )


puts "bye"