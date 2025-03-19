###
# to run use:
#    $ ruby ./prepare_matches.rb


require 'cocos'


require_relative 'helper'


recs = read_csv( "#{DATA_DIR}/matches.csv" )
puts "  #{recs.size } record(s)"
pp recs[0]



worldcup = Worldcup.new
worldcup.collect_matches( recs )


puts "bye"


__END__

"stage_name"=>"group stage",
"group_name"=>"Group 1",
"group_stage"=>"1",
"knockout_stage"=>"0",
"replayed"=>"0",
"replay"=>"0",
"match_date"=>"1930-07-13",
"match_time"=>"15:00",
"stadium_id"=>"S-240",
"stadium_name"=>"Estadio Pocitos",
"city_name"=>"Montevideo",
"country_name"=>"Uruguay",

"score"=>"4–1",
"extra_time"=>"0",
"penalty_shootout"=>"0",
"score_penalties"=>"0-0",


1248 record(s)
{"key_id"=>"1",
 "tournament_id"=>"WC-1930",
 "tournament_name"=>"1930 FIFA Men's World Cup",
 "match_id"=>"M-1930-01",
 "match_name"=>"France vs Mexico",
 "stage_name"=>"group stage",
 "group_name"=>"Group 1",
 "group_stage"=>"1",
 "knockout_stage"=>"0",
 "replayed"=>"0",
 "replay"=>"0",
 "match_date"=>"1930-07-13",
 "match_time"=>"15:00",
 "stadium_id"=>"S-240",
 "stadium_name"=>"Estadio Pocitos",
 "city_name"=>"Montevideo",
 "country_name"=>"Uruguay",
 "home_team_id"=>"T-30",
 "home_team_name"=>"France",
 "home_team_code"=>"FRA",
 "away_team_id"=>"T-46",
 "away_team_name"=>"Mexico",
 "away_team_code"=>"MEX",
 "score"=>"4–1",
 "home_team_score"=>"4",
 "away_team_score"=>"1",
 "home_team_score_margin"=>"3",
 "away_team_score_margin"=>"-3",
 "extra_time"=>"0",
 "penalty_shootout"=>"0",
 "score_penalties"=>"0-0",
 "home_team_score_penalties"=>"0",
 "away_team_score_penalties"=>"0",
 "result"=>"home team win",
 "home_team_win"=>"1",
 "away_team_win"=>"0",
 "draw"=>"0"}