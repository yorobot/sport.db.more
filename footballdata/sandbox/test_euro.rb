require_relative 'helper'



Footballdata.teams( league: 'euro',  season: '2024' ) ## euro 2024 
Footballdata.matches( league: 'euro',  season: '2024' ) ## euro 2024 

Footballdata.teams( league: 'euro',  season: '2021' ) ## euro 2021 (2020) 
Footballdata.matches( league: 'euro',  season: '2021' ) ## euro 2021 (2020) 


# euro 2016 not available with free tier
## Footballdata.teams( league: 'euro',  season: '2016' ) 
## GET http://api.football-data.org/v4/competitions/EC/teams?season=2016...
## !! HTTP ERROR - 403 Forbidden
## The resource you are looking for is restricted 
##  and apparently not within your permissions. Please check your subscription.

puts "bye"
