require 'cocos'


require_relative 'helper'



recs = read_csv( './data-csv/player_appearances.csv')
puts "  #{recs.size } record(s)"
# pp recs[0]



worldcup = Worldcup.new
worldcup.collect_lineups( recs )





def pp_lineup( rec )
   puts "==> #{rec['date']}   #{rec['team1']['name']} v #{rec['team2']['name']}     -- #{rec['match_id']}"
   
   print "#{rec['team1']['name']}: "
   puts  _build_lineup( rec['team1']['starter'] )

   print "#{rec['team2']['name']}: "
   puts  _build_lineup( rec['team2']['starter'] )
end


## maybe add tags for pos code later?
def _build_lineup( recs )
   if recs.size != 11
      pp recs
      raise ArgumentError, "expected 11 records; got #{recs.size}"
   end

   lineup = [[],[],[],[]]
   recs.each do |rec|
       name = fmt_name( rec )
       pos  = rec['position_code']
        lineup[ Worldcup::POS_INDEX[ pos ] ] << name
   end
   
   buf = _fmt_lineup( lineup )
   buf
end



def _fmt_lineup( lineup, indent: 3, width: 70 )
    lines = LineBuffer.new( indent: indent, width: width)
  
    lineup.each_with_index do |players,i|
        players.each_with_index do |player,j| 
            if j == players.size-1   ## is last player
               if i == lineup.size-1  ## is last player row
                  lines.add( "#{player}" )
               else  
                  lines.add( "#{player} - " )
               end
            else
               lines.add( "#{player}, " )
            end
        end
    end 

    lines.to_s
end

## pp MATCHES.values[0,10]


# matches = MATCHES.values[0,10]
# matches = WORLDCUPS['WC-2022'].values
matches = worldcup['WC-1978']
matches.each do |rec|
  pp_lineup( rec )
end




__END__

27432 record(s)
{"key_id"=>"1",
 "tournament_id"=>"WC-1970",
 "tournament_name"=>"1970 FIFA Men's World Cup",
 "match_id"=>"M-1970-01",
 "match_name"=>"Mexico vs Soviet Union",
 "match_date"=>"1970-05-31",
 "stage_name"=>"group stage",
 "group_name"=>"Group 1",
 "team_id"=>"T-46",
 "team_name"=>"Mexico",
 "team_code"=>"MEX",
 "home_team"=>"1",
 "away_team"=>"0",
 "player_id"=>"P-66980",
 "family_name"=>"Calderón",
 "given_name"=>"Ignacio",
 "shirt_number"=>"1",
 "position_name"=>"goal keeper",
 "position_code"=>"GK",
 "starter"=>"1",
 "substitute"=>"0"}


 {0=>"GK",
 1=>"SW",
 2=>"DF",
 3=>"RB",
 4=>"CB",
 5=>"LB",
 6=>"RWB",
 7=>"LWB",
 8=>"MF",
 9=>"DM",
 10=>"LM",
 11=>"CM",
 12=>"RM",
 13=>"AM",
 14=>"SS",
 15=>"FW",
 16=>"RW",
 17=>"LF",
 18=>"LW",
 19=>"CF",
 20=>"RF"}