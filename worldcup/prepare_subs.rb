require 'cocos'


require_relative 'helper'


recs = read_csv( './data-csv/substitutions.csv')
puts "  #{recs.size } record(s)"
# pp recs[0]
# pp recs[1]




worldcup = Worldcup.new
worldcup.collect_subs( recs )






def pp_subs( rec )

      puts "==> #{rec['match_id']}"

      pp rec['subs1']
      puts "  ;"
      pp rec['subs2']
end


# matches = MATCHES.values[0,10]
matches = worldcup['WC-2022']
# matches = WORLDCUPS['WC-1978'].values
matches.each do |rec|
  pp_subs( rec )
end




__END__

10222 record(s)
{"key_id"=>"1",
 "substitution_id"=>"S-0001",
 "tournament_id"=>"WC-1970",
 "tournament_name"=>"1970 FIFA Men's World Cup",
 "match_id"=>"M-1970-01",
 "match_name"=>"Mexico vs Soviet Union",
 "match_date"=>"1970-05-31",
 "stage_name"=>"group stage",
 "group_name"=>"Group 1",
 "team_id"=>"T-72",
 "team_name"=>"Soviet Union",
 "team_code"=>"SUN",
 "home_team"=>"0",
 "away_team"=>"1",
 "player_id"=>"P-60181",
 "family_name"=>"Serebryanikov",
 "given_name"=>"Viktor",
 "shirt_number"=>"15",
 "minute_label"=>"46'",
 "minute_regulation"=>"46",
 "minute_stoppage"=>"0",
 "match_period"=>"second half",
 "going_off"=>"1",
 "coming_on"=>"0"}
{"key_id"=>"2",
 "substitution_id"=>"S-0002",
 "tournament_id"=>"WC-1970",
 "tournament_name"=>"1970 FIFA Men's World Cup",
 "match_id"=>"M-1970-01",
 "match_name"=>"Mexico vs Soviet Union",
 "match_date"=>"1970-05-31",
 "stage_name"=>"group stage",
 "group_name"=>"Group 1",
 "team_id"=>"T-72",
 "team_name"=>"Soviet Union",
 "team_code"=>"SUN",
 "home_team"=>"0",
 "away_team"=>"1",
 "player_id"=>"P-59828",
 "family_name"=>"Puzach",
 "given_name"=>"Anatoliy",
 "shirt_number"=>"20",
 "minute_label"=>"46'",
 "minute_regulation"=>"46",
 "minute_stoppage"=>"0",
 "match_period"=>"second half",
 "going_off"=>"0",
 "coming_on"=>"1"}


 [{"off"=>{"shirt_number"=>11, "given_name"=>"Ousmane", "family_name"=>"Dembélé"},
  "on"=>{"shirt_number"=>12, "given_name"=>"Randal", "family_name"=>"Kolo Muani"},
  "minute_label"=>"41'",
  "minute_regulation"=>41,
  "minute_stoppage"=>0},
 {"off"=>{"shirt_number"=>9, "given_name"=>"Olivier", "family_name"=>"Giroud"},
  "on"=>{"shirt_number"=>26, "given_name"=>"Marcus", "family_name"=>"Thuram"},
  "minute_label"=>"41'",
  "minute_regulation"=>41,
  "minute_stoppage"=>0},
 {"off"=>{"shirt_number"=>22, "given_name"=>"Théo", "family_name"=>"Hernandez"},
  "on"=>{"shirt_number"=>20, "given_name"=>"Kingsley", "family_name"=>"Coman"},
  "minute_label"=>"71'",
  "minute_regulation"=>71,
  "minute_stoppage"=>0},