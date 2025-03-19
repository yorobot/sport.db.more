require 'cocos'

require_relative 'helper'


recs = read_csv( './data-csv/penalty_kicks.csv')
puts "  #{recs.size } record(s)"
pp recs[0]


worldcup = Worldcup.new
worldcup.collect_penalties( recs )



def pp_pens( rec )
   puts "==> #{rec['match_id']}     #{rec['penalties1'].size}-#{rec['penalties2'].size}"

   penalties1 = rec['penalties1'].map {|rec| fmt_pen( rec ) }
   penalties2 = rec['penalties2'].map {|rec| fmt_pen( rec ) }

   print 'Penalties: '
   print penalties1.join( ', ' )
   print ";\n"
   print '           '
   print penalties2.join( ', ' )
   print "\n"
end


def fmt_pen( rec )
   name = fmt_name( rec )
   if rec['converted']
     "#{name}"
   else
     "#{name} (X)" 
   end
end



matches = worldcup['WC-2022']
# matches = WORLDCUPS['WC-1978'].values
matches.each do |rec|
  pp_pens( rec )
end




__END__

396 record(s)
{"key_id"=>"1",
 "penalty_kick_id"=>"PK-001",
 "tournament_id"=>"WC-1982",
 "tournament_name"=>"1982 FIFA Men's World Cup",
 "match_id"=>"M-1982-50",
 "match_name"=>"West Germany vs France",
 "match_date"=>"1982-07-08",
 "stage_name"=>"semi-finals",
 "group_name"=>"not applicable",
 "team_id"=>"T-86",
 "team_name"=>"West Germany",
 "team_code"=>"DEU",
 "home_team"=>"1",
 "away_team"=>"0",
 "player_id"=>"P-68969",
 "family_name"=>"Kaltz",
 "given_name"=>"Manfred",
 "shirt_number"=>"20",
 "converted"=>"1"}