require_relative 'helper'

##
#  European Championship (EC)

=begin
Footballdata.teams( league: 'euro',  season: '2024' ) ## euro 2024 
Footballdata.matches( league: 'euro',  season: '2024' ) ## euro 2024 

Footballdata.teams( league: 'euro',  season: '2021' ) ## euro 2021 (2020) 
Footballdata.matches( league: 'euro',  season: '2021' ) ## euro 2021 (2020) 
=end

## try metal

## note - 404 - not available ???
## GET http://api.football-data.org/v4/competitions/EC/standings?season=2024
# Footballdata::Metal.standings( 'EC',  2024 ) 
# Footballdata::Metal.standings( 'EC',  2021 ) 


## Footballdata::Metal.scorers( 'EC',  2024 ) 

## Footballdata::Metal.team( 816 )   ## Austria (id=816)

## Footballdata::Metal.person( 8223 )   ## Marko Arnautovic (id=8223)

## Footballdata::Metal.match( 428761 )   ## NED-AUT (id=428761)


## note - headers no effect for TIER_ONE (free plan)
#
# X-Unfold-Lineups  [ true | false ] -- Unfold lineups within the reponse or not
# X-Unfold-Bookings [ true | false ] -- Unfold bookings within the reponse or not
# X-Unfold-Subs     [ true | false ] -- Unfold substitutions within the reponse or not
# X-Unfold-Goals    [ true | false ] -- Unfold goals within the reponse or not

=begin
headers = {
  'X-Unfold-Lineups'  =>  'true',
  'X-Unfold-Bookings' =>  'true',
  'X-Unfold-Subs'     =>  'true',
  'X-Unfold-Goals'    =>  'true',  
}


Footballdata::Metal.matches( 'EC', 2024, 
                                headers: headers )
=end


## Footballdata::Metal.competition( 'EC' )



# euro 2016 not available with free tier
## Footballdata.teams( league: 'euro',  season: '2016' ) 
## GET http://api.football-data.org/v4/competitions/EC/teams?season=2016
## !! HTTP ERROR - 403 Forbidden
## The resource you are looking for is restricted 
##  and apparently not within your permissions. Please check your subscription.

puts "bye"
