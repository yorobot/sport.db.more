require 'cocos'


require_relative 'helper'



app_recs = read_csv( './data-csv/player_appearances.csv')
puts "  #{app_recs.size } record(s)"
# pp recs[0]

sub_recs = read_csv( './data-csv/substitutions.csv')
puts "  #{sub_recs.size } record(s)"
# pp recs[0]
# pp recs[1]

goal_recs = read_csv( './data-csv/goals.csv')
puts "  #{goal_recs.size } record(s)"
# pp recs[0]

pen_recs = read_csv( './data-csv/penalty_kicks.csv')
puts "  #{pen_recs.size } record(s)"
# pp recs[0]


card_recs = read_csv( './data-csv/bookings.csv')
puts "  #{card_recs.size } record(s)"
# pp recs[0]


more_app_recs = read_csv( './data-csv/player_appearances_more.csv')
puts "  #{more_app_recs.size } record(s)"
# pp recs[0]

more_card_recs = read_csv( './data-csv/bookings_more.csv')
puts "  #{more_card_recs.size } record(s)"



worldcup = Worldcup.new
worldcup.collect_lineups( app_recs )
worldcup.collect_lineups( more_app_recs )

worldcup.collect_subs( sub_recs )
worldcup.collect_goals( goal_recs )
worldcup.collect_penalties( pen_recs )

worldcup.collect_bookings( card_recs )
worldcup.collect_bookings( more_card_recs )





def _build_match( rec )


   ### assert rec lineup
   if rec['team1']['starter'].size == 0 ||
      rec['team2']['starter'].size == 0 
      pp rec
      raise ArgumentError, "lineup(s) missing in match record"
   end


   buf = String.new
   buf << "#{rec['date']}   #{rec['team1']['name']} v #{rec['team2']['name']}\n"
   
   if rec['goals1'].size > 0 ||
      rec['goals2'].size > 0
      buf << _build_goals( rec )
   end
   buf << "\n"

   buf << "#{rec['team1']['name']}: "
   buf <<  _build_lineup( rec['team1']['starter'],
                          rec['subs1'] )
   buf << "\n"

   buf <<  "#{rec['team2']['name']}: "
   buf <<  _build_lineup( rec['team2']['starter'],
                        rec['subs2'] )
   buf << "\n"

   if rec['penalties1'].size > 0
     buf << "\n"
     buf << _build_pens( rec )
   end

   if rec['bookings1'].size > 0 ||
      rec['bookings2'].size > 0
      buf << "\n"
      buf << _build_bookings( rec )
   end

   buf
end



## maybe add tags for pos code later?
def _build_lineup( recs, sub_recs )
   if recs.size != 11
      pp recs
      raise ArgumentError, "expected 11 records; got #{recs.size}"
   end

   ## build lookup map for sub_recs
   subs = {}
   sub_recs.each do |sub|
       name = fmt_name( sub['off'] )
       subs[ name ] = sub 
   end


   lineup = [[],[],[],[]]
   recs.each do |rec|
       name = fmt_name( rec )
       pos  = rec['position_code']

       line = String.new
       line << name

       ## check for subs
       ##   todo/fix add subs of subs!!!
       sub = subs[name]
       if sub
           sub_name = fmt_name(sub['on'])
           line << " (#{fmt_minute( sub )} #{sub_name}"

           ## check for sub of subs (NOT recursive for now)
           subsub = subs[sub_name]
           if subsub
              line << " (#{fmt_minute(subsub)} #{fmt_name(subsub['on'])})"
              subs.delete( sub_name )
           end
        
           line << ")" 
           subs.delete( name )
       end  

        lineup[ Worldcup::POS_INDEX[ pos ] ] << line
   end
   
   if subs.size > 0   ## any subs left/unmatched?
      pp subs
      raise ArgumentError, "unmatched subs, subs of subs?" 
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


def _build_goals( rec )
   
   goals1 = rec['goals1'].map {|rec| fmt_goal( rec ) }
   goals2 = rec['goals2'].map {|rec| fmt_goal( rec ) }

   buf = String.new
   if goals1.size == 0
      ## print "  -; "
   else
      buf << "  "
      buf << goals1.join(' ')
      if goals2.size == 0
         buf << "\n"
      else
         buf << ";\n"
      end
   end
   
   if goals2.size != 0
      buf << "  "
      buf << goals2.join(' ')
      buf << "\n"
   end
   buf
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



def _build_pens( rec )

   penalties1 = rec['penalties1'].map {|rec| fmt_pen( rec ) }
   penalties2 = rec['penalties2'].map {|rec| fmt_pen( rec ) }

   buf = String.new
   buf <<'Penalties: '
   buf << penalties1.join( ', ' )
   buf << ";\n"
   buf << '           '
   buf << penalties2.join( ', ' )
   buf << "\n"

   buf
end


def fmt_pen( rec )
   name = fmt_name( rec )
   if rec['converted']
     "#{name}"
   else
     "#{name} (X)" 
   end
end





def _build_bookings( rec )

      bookings = []
      
      bookings += rec['bookings1'].map { |rec| fmt_booking( rec ) }
      bookings += rec['bookings2'].map { |rec| fmt_booking( rec ) }                                           

      buf = String.new
      buf <<  "Sent off: "
      buf << bookings.join(', ')
      buf << "\n"

      buf
end

def fmt_booking( rec )
    buf = String.new
    buf << fmt_name( rec )
    buf << ' '
    buf << fmt_minute( rec )
    buf
end




=begin
# matches = worldcup['WC-2022']
# matches = worldcup['WC-1978']
matches = worldcup['WC-2014']
matches.each do |rec|
  puts
  puts
  puts _build_match( rec )
end
=end

## pp worldcup.data.keys


worldcup.data.each do |code, hash|

   ## note - line-up start at 1970
#   next if ['WC-1930', 'WC-1934', 'WC-1938', 
#            'WC-1950', 'WC-1954', 'WC-1958', 'WC-1962', 'WC-1966'
#           ].include?(code)

   matches = hash.values ## note  - matches stored as hash w/ key
 

   stats = { 'teams' => Hash.new(0) 
           }

   matches.each do |rec|
        stats['teams'][rec['team1']['name']] += 1
        stats['teams'][rec['team2']['name']] += 1
   end

   buf = String.new
   buf << "= #{code}\n\n"
   buf << "  \# Matches  #{matches.size}\n"
   buf << "  \# Teams    #{stats['teams'].keys.size}\n"
   buf << "\n"



   matches.each do |rec|
     buf << "\n\n"
     buf << _build_match( rec )
   end

   outpath = "./o/#{code.downcase}.txt"
   write_text( outpath, buf )
end


puts "bye"

