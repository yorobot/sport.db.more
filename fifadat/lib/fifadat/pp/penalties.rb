



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


     period = h['Period']

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
            # timestamp:  h['Timestamp'],
            # period:     h['Period'],   ## note - use 11 (for pen kicks!!!)
          }

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
