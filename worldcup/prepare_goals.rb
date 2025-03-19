require 'cocos'


require_relative 'helper'



recs = read_csv( './data-csv/goals.csv')
puts "  #{recs.size } record(s)"
pp recs[0]

worldcup = Worldcup.new
worldcup.collect_goals( recs )


def pp_goals( rec )
   puts "==> #{rec['match_id']}     #{rec['goals1'].size}-#{rec['goals2'].size}"
   
   goals1 = rec['goals1'].map {|rec| fmt_goal( rec ) }
   goals2 = rec['goals2'].map {|rec| fmt_goal( rec ) }

   if goals1.size == 0
      ## print "  -; "
   else
      print "  "
      print goals1.join(' ')
      if goals2.size == 0
         print "\n"
      else
         print ";\n"
      end
   end
   
   if goals2.size != 0
      print "  "
      print goals2.join(' ')
      print "\n"
   end
end



def fmt_goal( rec )
   buf = String.new
   buf << fmt_name( rec )
   buf << ' '   
   buf << fmt_minute( rec )
   buf << " (og)"  if rec['own_goal']
   buf << " (pen)" if rec['penalty']
   buf
end



def fmt_goals( recs )
   recs.each do |rec|
      print fmt_goal( rec )
      print " "
   end
   ## print "\n"
end



# matches = MATCHES.values[0,10]
matches = worldcup['WC-2022']
# matches = WORLDCUPS['WC-1978'].values
matches.each do |rec|
  pp_goals( rec )
end




__END__

"minute_label"=>"90'+11'",
"minute_regulation"=>"90",
"minute_stoppage"=>"11",
"match_period"=>"second half, stoppage time",

"minute_label"=>"105'+1'",
"minute_regulation"=>"105",
"minute_stoppage"=>"1",
"match_period"=>"extra time, first half, stoppage time",

3637 record(s)
{"key_id"=>"1",
 "goal_id"=>"G-0001",
 "tournament_id"=>"WC-1930",
 "tournament_name"=>"1930 FIFA Men's World Cup",
 "match_id"=>"M-1930-01",
 "match_name"=>"France vs Mexico",
 "match_date"=>"1930-07-13",
 "stage_name"=>"group stage",
 "group_name"=>"Group 1",
 "team_id"=>"T-30",
 "team_name"=>"France",
 "team_code"=>"FRA",
 "home_team"=>"1",
 "away_team"=>"0",
 "player_id"=>"P-05470",
 "family_name"=>"Laurent",
 "given_name"=>"Lucien",
 "shirt_number"=>"0",
 "player_team_id"=>"T-30",
 "player_team_name"=>"France",
 "player_team_code"=>"FRA",
 "minute_label"=>"19'",
 "minute_regulation"=>"19",
 "minute_stoppage"=>"0",
 "match_period"=>"first half",
 "own_goal"=>"0",
 "penalty"=>"0"}