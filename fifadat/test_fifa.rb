
require_relative 'fifa'



## fetch_json( Fifa.search_seasons_url( name: 'European Championship'), "./tmp/search_euro_champ.json" )



season = 2034

fetch_json( Fifa.matches_url( season: season ),  "./fifa/#{season}_matches.json" )



__END__


=begin

sleep( 2 )   # 2secs
fetch_json( Fifa.stages_url( season: season ),  "./fifa/#{season}_stages.json" )
=end

idMatch = "400128145"
idStage = "285077"
idSeason = "255711"
idCompetition = "17"


fetch_json( Fifa._timeline_url( idCompetition: idCompetition, 
                                idSeason: idSeason,
                               idStage: idStage, 
                               idMatch: idMatch ), "./tmp/timeline_ARG-FRA.json" )



seasons = [# 1930,
           1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]

seasons.each do |season|
  sleep(1)
  fetch_json( Fifa.squads_url( season: season), "./misc/#{season}_squads.json" )
end

## name = "WORLDCUP"
## fetch_json( Fifa.competition_url( name: name ), "./more/#{name}_competitions.json" )
## fetch_json( Fifa.competitions_url )



# url = "https://api.fifa.com/api/v3/live/football/17/1/201/1096?language=en"

# fetch_json( url, "./tmp/1-201-1094.json" )

puts "bye"



