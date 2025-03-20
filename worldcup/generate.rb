###
# to run use:
#    $ ruby ./generate.rb



require 'cocos'


require_relative 'helper'



app_recs = read_csv( "#{DATA_DIR}/player_appearances.csv" )
puts "  #{app_recs.size } app record(s)"
# pp recs[0]

sub_recs = read_csv( "#{DATA_DIR}/substitutions.csv" )
puts "  #{sub_recs.size } sub record(s)"
# pp recs[0]
# pp recs[1]

goal_recs = read_csv( "#{DATA_DIR}/goals.csv" )
puts "  #{goal_recs.size } goal record(s)"
# pp recs[0]

pen_recs = read_csv( "#{DATA_DIR}/penalty_kicks.csv" )
puts "  #{pen_recs.size } pen record(s)"
# pp recs[0]


card_recs = read_csv( "#{DATA_DIR}/bookings.csv" )
puts "  #{card_recs.size } card record(s)"
# pp recs[0]


more_app_recs = read_csv( "#{DATA_DIR}/player_appearances_more.csv" )
puts "  #{more_app_recs.size } more app record(s)"
# pp recs[0]

more_card_recs = read_csv( "#{DATA_DIR}/bookings_more.csv" )
puts "  #{more_card_recs.size } more card record(s)"


match_recs = read_csv( "#{DATA_DIR}/matches.csv" )
puts "  #{match_recs.size } match record(s)"
# pp recs[0]
 



worldcup = Worldcup.new
worldcup.collect_lineups( app_recs )
worldcup.collect_lineups( more_app_recs )

worldcup.collect_subs( sub_recs )
worldcup.collect_goals( goal_recs )
worldcup.collect_penalties( pen_recs )
worldcup.collect_matches( match_recs )

worldcup.collect_bookings( card_recs )
worldcup.collect_bookings( more_card_recs )




$LAST_ROUND = nil
$LAST_YEAR  = nil

def _build_match( rec )


   ### assert rec lineup
   if rec['team1']['starter'].size == 0 ||
      rec['team2']['starter'].size == 0 
      pp rec
      raise ArgumentError, "lineup(s) missing in match record"
   end


   buf = String.new

##
##   add round

    stage_name = rec['stage_name']
    ## upcase first letter e.g. group stage to Group stage etc.
    stage_name[0] = stage_name[0].upcase

    round =  if rec['group_stage']  
                  group_name = rec['group_name']               
                 if  group_name != 'not applicable' 
                   "#{stage_name} - #{group_name}"
                 else
                   "#{stage_name}"
                 end
             elsif rec['knockout_stage']
                 "#{stage_name}"
             else
              pp rec
              raise ArgumentError, "unknown stage; expected group_stage|knockout_stage"
             end

   round += " - Replay"   if rec['replay']   ## add replay

=begin
"match_date"=>"1930-07-13",
"match_time"=>"15:00",
"stadium_id"=>"S-240",
"stadium_name"=>"Estadio Pocitos",
"city_name"=>"Montevideo",
"country_name"=>"Uruguay",
=end

### todo - check for last_round (only print if different)

   if $LAST_ROUND != round
     buf << "» #{round}\n"
   end

   $LAST_ROUND = round


   ## parse date
   ##  move "upstream" on collect - why? why not?
   date = Date.strptime( rec['date'], '%Y-%m-%d' )


###  todo - check last_date  (only print year if different)
   if $LAST_YEAR != date.year
      buf << "#{date.strftime('%a %b/%-d %Y')}"
   else
      buf << "#{date.strftime('%a %b/%-d')}"
   end

   $LAST_YEAR = date.year

   buf << " @ "
   buf << "#{rec['stadium_name']}"
   buf << " › #{rec['city_name']}"
   buf << ", #{rec['country_name']}"  
   buf << "\n"
   
   buf << "  #{rec['team1']['name']} v #{rec['team2']['name']}"
   buf << "  #{rec['score']}"

=begin
"score"=>"4–1",
"extra_time"=>"0",
"penalty_shootout"=>"0",
"score_penalties"=>"0-0",

## check golden goal  in extra time - how modeled???
##   what world cup season is golden goal??
=end
   
   if rec['extra_time'] 
      if rec['penalty_shootout']
        buf << " [aet; #{rec['score_penalties']} on pens]"
      else
        buf << " [aet]"
      end
   elsif !rec['extra_time'] && rec['penalty_shootout']
      ## possible  
      raise ArgumentError, "fix penalty shoout without extratime!!!"
   else
      ## do nothing
   end

   buf << "\n"
   

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
                  lines.add( "#{player}, " )  ## lines.add( "#{player} - " )
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
      buf << (' '*4)   ## indent by 4
      buf << goals1.join(' ')
      if goals2.size == 0
         buf << "\n"
      else
         buf << ";\n"
      end
   end
   
   if goals2.size != 0
      buf << (' '*4)  ## indent by 4
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
   buf << "(og)"  if rec['own_goal']
   buf << "(p)" if rec['penalty']
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

   ## get year from  WC-1930
   year = code[3..-1].to_i(10)


   matches = hash.values ## note  - matches stored as hash w/ key
 

   stats = { 'teams' => Hash.new(0) 
           }

   matches.each do |rec|
        stats['teams'][rec['team1']['name']] += 1
        stats['teams'][rec['team2']['name']] += 1
   end

   buf = String.new
   buf << "= World Cup #{year}\n\n"
   buf << "  \# Matches  #{matches.size}\n"
   buf << "  \# Teams    #{stats['teams'].keys.size}\n"
   buf << "\n"



   matches.each do |rec|
     buf << "\n\n"
     buf << _build_match( rec )
   end

   outdir = './o'
   # outdir = '/sports/openfootball/worldcup.more/worldcup'
   outpath = "#{outdir}/#{year}_worldcup.txt"
   write_text( outpath, buf )
end


puts "bye"

