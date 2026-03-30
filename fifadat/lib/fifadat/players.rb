
  
    
def build_penalty( h, players: )
    ## split into minute
    ##  and offset (stoppage/injury time)    
    ##  e.g. 90'+11'

    minute_str = h['MatchMinute']

    if minute_str.nil? || minute_str.empty?
       ## puts "!! minute in penaltiy is nil or empty:"
       ## pp h
       ## exit 1
       minute_str = "121'"  ## quick hack - use 121' - allow nil in future!!
                            ##  minute not really used (check for period is 11)
    end

    minute, offset = _parse_minute( minute_str )

     type = h['Type']

     ##########
     ##  0 - goal   (when penalty awared used before)
     ## 41 - penalty goal
     ## 46 - penalty missed
     ##   Dragan STOJKOVIC (Yugoslavia) rattles the crossbar from the spot!
     ## 51 - penalty missed
     ##    JULIO CESAR (Brazil) hits the post from the spot!
     ## 60 - penalty missed
     ##    COMAN (France) sees his penalty saved by the goalkeeper. 
     ##    Maxime BOSSIS (France) misses from the penalty spot! and many more
     ## 65 - penalty missed
     ##      TCHOUAMENI (France) misses from the penalty spot!
  
  
     assert( [0,41,46,51,60,65].include?(type), 
             "event type 0/41/46/51/60/65 expected; got #{type}")


    rec = { type:      type,
            pen: [h['HomePenaltyGoals'], 
                  h['AwayPenaltyGoals']],
            minute:    minute,
            # timestamp:  h['Timestamp'], 
            # period:     h['Period'],   ## note - use 11 (for pen kicks!!!)
          }
    rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)
 

     idPlayer = h['IdPlayer'] || h['IdSubPlayer']

=begin   
  -- try IdSubPlayer - why? why not?
    ## what is SubPlayer/SubTeam in event??
!! no idPlayer for penaltyl!
{"EventId"=>"17807200001266",
 "IdTeam"=>"1884426",
 "IdSubPlayer"=>"408948",
 "IdSubTeam"=>"1897032",
=end

      if idPlayer.nil?
         puts "!! no idPlayer for penaltyl!"
         pp h
          ##exit 1
          ## use 'N.N.'

          rec[ :player ] = {
                             name: 'N.N.',
                           }
                     
      else
        rec[ :player ] = players.find!( idPlayer ) 
      end
   
     rec    
end

def build_penalties( recs, players: )
     ################
     ## type:
     ##  6 -  penalty awarded
     ##       weirdo format - followed by 0 - goald or 60 - penalty missed!
     ## 2 -   yellow card
     ## 3 -   red card
     ## 7 -   start time (The penalty shoot-out is about to begin) 
     ## 8 -   end time

     recs = recs.select do |h|
                              if h['Period'] == 11   ## penalty shoot-out
                                assert( [0,2,3,6,7,8,41,46,51,60,65].include?( h['Type'] ),
                                   "expected event type 2/3/7/8/41/46/51/60/65 for pens; got #{h.pretty_inspect}"
                                 )
                                [0,41,46,51,60,65].include?( h['Type'] ) ? true : 
                                                                   false
                              else
                                 false
                              end
                        end


    recs = recs.map { |h| build_penalty( h, players: players ) }
    recs
end



def build_goal( h, players: )

    ## split into minute
    ##  and offset (stoppage/injury time)    
    ##  e.g. 90'+11'

     minute_str = h['Minute']

     if minute_str.nil? || minute_str.empty?



      ## todo/fix - find minute
      ##   in interconti cup 2024-12-1
        if h['Period'] == 11    ## realy penalty shoot out!!!
                                   ## skip - why? why not?
            minute_str =  "121'"                       
        else
           puts "!! minute in goal is nil or empty:"
           pp h
           exit 1
        end
      end


    minute, offset = _parse_minute( minute_str )

    ## check for weird minute 0 e.g.
    ##   Germany-Austria 1934 
    minute = 1  if h['Minute'] == "0'" 

  
    rec = { type:      h['Type'],
            minute:    minute, 
          }

     rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)

      idPlayer = h['IdPlayer']

      if idPlayer.nil?
         puts "!! no idPlayer for goal!"
         pp h
          ##exit 1
          ## use 'N.N.'

          rec[ :player ] = {
                             name: 'N.N.',
                           }
                     
      else
        rec[ :player ] = players.find!( idPlayer ) 
      end
     rec    
end


def build_goals( recs, players:,  penalties: false )
    recs = recs.map  { |h| build_goal( h, players: players ) }

    ## note - filter out penalties (from shoot-out)!!
    ##    min > 120  (e.g. 121, etc.)
    if penalties == false
       recs = recs.select { |rec| rec[:minute] <= 120 }
    end

    ## sort by minutes
    ##  may not be sorted

    recs = recs.sort do |l,r|
                 res = l[:minute] <=> r[:minute]
                 res = (l[:offset]||0) <=> (r[:offset]||0)  if res == 0 && 
                                                              (l[:minute] == 45 ||
                                                               l[:minute] == 90 ||
                                                               l[:minute] == 105 ||  ## check - if possible stoppage in 1st half extra-time??
                                                               l[:minute] == 120)
                 res
           end
    recs
end



=begin
  "Officials": 
     [{"IdCountry": "URU",
       "OfficialId": "61038",
       "NameShort": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "Name": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "OfficialType": 1,
       "TypeLocalized": [{"Locale": "en-GB", "Description": "Referee"}]},
      {"IdCountry": "BEL",
       "OfficialId": "60664",
       "NameShort": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "Name": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "OfficialType": 2,
       "TypeLocalized": 
        [{"Locale": "en-GB", "Description": "Assistant Referee 1"}]},
      {"IdCountry": "BRA",
       "OfficialId": "61289",
       "NameShort": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "Name": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "OfficialType": 3,
       "TypeLocalized": 
        [{"Locale": "en-GB", "Description": "Assistant Referee 2"}]}],
  
=end

def build_official( h )
    name = desc( h['Name'] )

    ## fix - use norm_official
    name = norm_official( name )

    idCountry = h['IdCountry']
    type      = h['OfficialType']


    assert( is_alpha?( name), "official name alpha expected; got #{name.inspect}" )
    assert( [1,2,3,4,5,6,7,8,9,10].include?( type ), "official type 1/2/3/4/5/6/7/8/9/10 expected; got #{type}" )

    rec = {
            id: h['OfficialId'],
            name:      name,
            idCountry: idCountry,
            type:      type
          }

    rec
   end


def build_officials( recs )  ## use referees?
    recs = recs.map  { |h| build_official( h ) }
   
    ## skip fourth official (4) for now
    recs = recs.select { |h|  [1,2,3].include?( h[:type] ) }

    ## sort by type 1/2/3
    ##  1 - referee
    ##  2 - assistant referee 1
    ##  3 - assistant referee 2
    ##  4 - fourth official
    ##  5 - video assistant referee (var)  
    ##  6 - reserve referee
    ##  7 - offside var
    ##  8 - assistant var
    ##  9 - support var
    ## 10 - reserve assistant referee
    

    recs = recs.sort { |l,r|  l[:type] <=> r[:type] }  
   
    recs
end




def build_player( h )
   name       = desc( h['PlayerName'] )
   name = norm_player( name )

   short_name = desc( h['ShortName'] )

   ##
   ##  todo/check - add IdCountry if available??

   rec = { id:      h['IdPlayer'],
           name:        name,
           short_name:  short_name,
           status:     h['Status'],
           pos:        h['Position'],
        }

    rec[:captain]  = true   if h['Captain']

  rec
end



class Players
   def initialize
      @recs = {}
   end

   def add( recs )    ## rename to collect - why? why not?
      recs.each { |h| _add( build_player(h)) }
   end


   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec

      else
          rec[:count] += 1
          ## assert attributes equal - why? why not?

          assert( new_rec[:name] == rec[:name] &&
                  new_rec[:short_name] == rec[:short_name],
                  "player records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end

   def find!( id_player )
       rec = @recs[ id_player ]
       raise ArgumentError, "no player w/ id >#{id_player}< found; sorry"  if rec.nil?
       rec
   end


   ###
   ## todo/check
   ##    add alias (or rename) starter  ??
   ##   add new subs to  status == 2  - why? why not?
   def lineup
      recs = @recs.values.select { |rec| rec[:status] == 1 }

      recs
   end

   def add_bookings( bookings )  ##  yellow/red cards
      bookings.each do |b|
     
         card = b['Card']
         assert( [0,1,2,3].include?( card ), "card 0/1/2/3 expected; got #{b.pretty_inspect}")

         ##
         ## what is card 0?  ignore for now
         ##  Palmeiras v FC Porto  0-0   - 2025-06-15T18:00:00+00:00
         ## !! ASSERT FAILED - card 1/2/3 expected; got {"Card"=>0,
         ## "Period"=>5,
         ## "IdEvent"=>nil,
         ## "EventNumber"=>nil,
         ## "IdPlayer"=>"495048",
         ## "IdCoach"=>nil,
         ## "IdTeam"=>"1884426",
         ## "Minute"=>"72'",
         ## "Reason"=>nil}
         next if card == 0


         idPlayer = b['IdPlayer']

         ## booking (card) for coach!!!!
         ##   skip for now
         next   if idPlayer.nil? && b['IdCoach']
  

         player = @recs[ idPlayer ]
         assert( player, "booking player not found; sorry- #{b.pretty_inspect}" )
   
           ## note - parse & reformat minute for keep same format 
          minute =   _fmt_minute( *_parse_minute( b['Minute'] ))

          if card == 1      ## yellow
             player[ :y ] = { minute: minute }
          elsif card == 2   ## red
             player[ :r ] = { minute: minute }
          elsif card == 3   ## yellow/red
             player[ :yr ] = { minute: minute }
          end
      end
   end



   def add_subs( subs )
        subs.each do |sub|

          idPlayerOff = sub['IdPlayerOff']
          idPlayerOn  = sub['IdPlayerOn']
         
          ## note - parse & reformat minute for keep same format 
          minute_str = sub['Minute']
          if minute_str.nil? || minute_str.empty?
            if sub['Period'] == 4  ## quick fix - use 46' half-time sub??
                minute_str = "46'"
            elsif sub['Period'] == 8 ## quick fix - use 116' 1st half-time extra time?
                minute_str = "116'"
##  "SubstitutePosition"=>2,
## "IdPlayerOff"=>"403319",
## "IdPlayerOn"=>"436537",
## "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"NASSER ALDAWSARI"}],
## "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"MUSAB ALJUWAYR"}],
## "Minute"=>"",
## "IdTeam"=>"1943992"}
               elsif sub['Period'] == 17  ## quick fix- what is period 17 beyond pens??
                minute_str = "121'"

 ##"Period"=>17,
 ## "SubstitutePosition"=>2,
 ## "IdPlayerOff"=>"473062",
 ## "IdPlayerOn"=>"418961",
 ## "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Emiliano MARTINEZ"}],
 ## "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Anibal MORENO"}],
 ## "Minute"=>"",
 ## "IdTeam"=>"1884426"}
            else
              puts "!! minute in sub is nil or empty:"
              pp sub
              exit 1
            end
          end
          minute =   _fmt_minute( *_parse_minute( minute_str ))

          player_off = @recs[ idPlayerOff ]
          player_on  = @recs[ idPlayerOn ]
          
##
##   note - skip special case for now
##              with NO PLAYER ON (e.g. idPlayerOn is nil!!)
           next if idPlayerOn.nil?
           ##  todo/fix - report/log warning!!!


          if player_off.nil?
             puts "!! player_off >#{idPlayerOff}< not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end

          if player_on.nil?
             puts "!! player_on >#{idPlayerOn}< not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end
       
          assert( player_off && player_on, 
                  "subs player_off or player_on not found; sorry" )
          
          player_off[ :sub ] = { minute: minute, 
                                 player_ref: player_on }
          ## id:     player_on[:id],
          ##         name:   player_on[:name] 

        end
   end
 


   def dump
      pp @recs.values
      puts "  #{@recs.size} player(s)"
   end

   def size() @recs.size; end

end  # class Players






