###
# to run use:
#    $ ruby ./prepare_bookings.rb


require 'cocos'


require_relative 'helper'

##
##  note - sent off   includes red cards 
##           PLUS second yellow card (aka yellow/red card)  !!!
##
##   use sent off for now   


recs = read_csv( "#{DATA_DIR}/bookings.csv" )
puts "  #{recs.size } record(s)"
pp recs[0]



worldcup = Worldcup.new
worldcup.collect_bookings( recs )


def pp_bookings( rec )

   if rec['bookings1'].size > 0 ||
      rec['bookings2'].size > 0

      puts "==> #{rec['match_id']}"

      bookings = []
      
      bookings += rec['bookings1'].map { |rec| fmt_booking( rec ) }
      bookings += rec['bookings2'].map { |rec| fmt_booking( rec ) }                                           
                                                
      print "Sent off: "
      puts  bookings.join(', ')
   end
end

def fmt_booking( rec )
    buf = String.new
    buf << fmt_name( rec )
    buf << ' '
    buf << fmt_minute( rec )
    buf
end


# matches = MATCHES.values[0,10]
matches = worldcup['WC-2022']
# matches = WORLDCUPS['WC-1978'].values
matches.each do |rec|
  pp_bookings( rec )
end




__END__


3178 record(s)
{"key_id"=>"1",
 "booking_id"=>"B-0001",
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
 "player_id"=>"P-33189",
 "family_name"=>"Asatiani",
 "given_name"=>"Kakhi",
 "shirt_number"=>"11",
 "minute_label"=>"30'",
 "minute_regulation"=>"30",
 "minute_stoppage"=>"0",
 "match_period"=>"first half",
 "yellow_card"=>"1",
 "red_card"=>"0",
 "second_yellow_card"=>"0",
 "sending_off"=>"0"}


 
