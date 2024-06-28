require_relative 'helper'

###########
##  samples:
##   national teams
##    EC 2024  - euro
##    EC 2021
##    WC 2022  - world cup
##   club cups intl
##    CL 2023  - (uefa/european) champions league
##    CLI 2204 - (south american) copa libertadores
##   club leagues 
##    PL 2024  - england premiere league


league_code       = ARGV[0] || 'EC'
season_start_year = (ARGV[1] || '2024').to_i(10)

pp league_code, season_start_year

url = Footballdata::Metal.competition_matches_url( league_code, 
                                                   season_start_year )
pp url
#=> "http://api.football-data.org/v4/competitions/EC/matches?season=2024"

if Webcache.cached?( url ) == false
  ## try download
  Footballdata::Metal.matches( league_code, 
                                season_start_year )
end

data = Webcache.read_json( url )
## pp data


Footballdata.pp_matches( data )

puts "bye"

