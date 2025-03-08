
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
## BE1 = 144
## pp ApiFootball::Metal.fixtures( league: BE1, season: 2023 )

## pp ApiFootball.fixtures( league: 'world', season: '2022' )



fixtures = ApiFootball.fixtures( league: 'uefa.nl', season: '2022' )
## fixtures = ApiFootball.fixtures( league: 'southamerica', season: '2021' )
## fixtures = ApiFootball.fixtures( league: 'world', season: '2022' )


## fixtures = ApiFootball.fixtures( league: 'copa.l', season: '2023' )
## fixtures = ApiFootball.fixtures( league: 'copa.l', season: '2023' )

## fixtures = ApiFootball.fixtures( league: 'copa.s', season: '2023' )

## fixtures = ApiFootball.fixtures( league: 'at.1', season: '2023/24' )
## fixtures = ApiFootball.fixtures( league: 'at.2', season: '2023/24' )

## fixtures = ApiFootball.fixtures( league: 'at.cup', season: '2023/24' )
## fixtures = ApiFootball.fixtures( league: 'mx.1', season: '2023' )

## fixtures = ApiFootball.fixtures( league: 'mls', season: '2023' )
## fixtures = ApiFootball.fixtures( league: 'be.1', season: '2023/24' )

## fixtures = ApiFootball.fixtures( league: 'eng.1', season: '2023/24' )
## fixtures = ApiFootball.fixtures( league: 'eng.fa.cup', season: '2023/24' )



pp fixtures


league_name    = fixtures['response'][0]['league']['name']
league_country = fixtures['response'][0]['league']['country']
season         = '2023/24'   ## use year from fixtures - why? why not?


buf = String.new 
if league_country != 'World'
  buf << "= #{league_country} | #{league_name}"  
else
  buf << "= #{league_name}"
end
buf << " #{season}\n\n"


buf << "  # Matches   #{fixtures['response'].size}"
buf << "\n\n"
buf += ApiFootball._build_fixtures( fixtures )

puts buf


puts "bye"



__END__

name with  /   remove surrounding spaces?
  Silz / Mötz                 =>  Silz/Mötz 
  Oberwart / Rotenturm        =>  Oberwart/Rotenturm
  Wallern / Marienkirchen

name with -   remove surround spaces?
   FavAC - Platz      =>    FavAC-Platz
   U.N.A.M. - Pumas   =>    U.N.A.M.-Pumas


## check in mls   mls cup round 1  - first matches have no dates (or only scheduled?)
##                                 because of best of three series or such?

## check fa cup  - first rounds no halftime scores???
##   e.g.  Dereham Town v Walsham Le Willows  4-1 (-) ...


note - extra time is score of extra time ONLY!!
       AND fulltime is 90min

goals - is  after extra time

"goals"=>
     {"home"=>3, "away"=>3},
"score"=>
     {"halftime"=>{"home"=>2, "away"=>0},
      "fulltime"=>{"home"=>2, "away"=>2},
      "extratime"=>{"home"=>1, "away"=>1},
      "penalty"=>{"home"=>4, "away"=>2}}}]}

"goals"=>
     {"home"=>2, "away"=>2},
"score"=>
     {"halftime"=>{"home"=>0, "away"=>1},
      "fulltime"=>{"home"=>2, "away"=>2},
      "extratime"=>{"home"=>0, "away"=>0},
      "penalty"=>{"home"=>3, "away"=>4}}},
