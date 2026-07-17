
=begin
{"EventId": "120171",
    "IdTeam": "43942",
    "IdPlayer": "95982",
    "Timestamp": "2022-11-14T10:47:50.8028496Z",
    "MatchMinute": "120'",
    "Period": 11,
    "HomeGoals": 2,
    "AwayGoals": 2,
    "Type": 60,
    "Qualifiers": [],
    "TypeLocalized": [{"Locale": "en-GB", "Description": "Penalty missed"}],
    "HomePenaltyGoals": 4,
    "AwayPenaltyGoals": 3,
    "EventDescription":
     [{"Locale": "en-GB",
       "Description":
        "David BATTY (England) misses from the penalty spot!"}]}],
 "Properties": {},
 "IsUpdateable": null}
=end


def build_penalty( h, players:,
                      team1_id:, team2_id: )

    ## note - do NOT care about minutes in penalty shootout
    ##   check for period == 11 (penalty shotout!!)
    ##    period = h['Period']


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

     type = h['Type']    ## (timeline) event type

     assert( [0,41,46,51,60,65].include?(type),
             "event type 0/41/46/51/60/65 expected; got #{type}")


     team =   if h['IdTeam'] == team1_id
                   1
              elsif h['IdTeam'] == team2_id
                   2
              else
                 assert( false, "team1/2_id #{team1_id/team2_id} expected; got #{h.pretty_inspect}")
              end

    rec = { team:    team,     ## 1|2
            score:   [h['HomePenaltyGoals'],
                      h['AwayPenaltyGoals']],
            scored:   [0,41].include?( type ) ? true : false,
          }

     idPlayer = h['IdPlayer']


=begin
  -- try IdSubPlayer - why? why not?
     IdSubPlayer is goalkeeper!!!
    ## what is SubPlayer/SubTeam in event??
!! no idPlayer for penaltyl!
{"EventId"=>"17807200001266",
 "IdTeam"=>"1884426",
 "IdSubPlayer"=>"408948",
 "IdSubTeam"=>"1897032",
=end

      if idPlayer.nil?
         puts "!! no idPlayer for penalty!"
         pp h
          ##exit 1
          ## use 'N.N.'

          rec[ :name ] = 'N.N.'

      else
        rec[ :name ] = players.find!( idPlayer )[:name]
      end

       rec[:meta] = {  type: type,
                       desc: desc(h['EventDescription'])  ## add event desc too - why? why not?
                    }
     rec
end




def build_penalties( recs, players:,
                           team1_id:, team2_id: )
     ################
     ## type:
     ##  check for "old/legacy" format used where?
     ##        not using period 11 ???
     ##   incl. weirdo format with
     ##    6 -  penalty awarded
     ##     0 - goal or 60 - penalty missed!
     ##
     ##  2 - yellow card
     ##  3 - red card
     ##  7 - start time
     ##  8 - end time

     recs = recs.select do |h|
                              if h['Period'] == 11   ## penalty shoot-out
                                assert( [0,2,3,6,7,8,41,46,51,60,65].include?( h['Type'] ),
                                   "expected event type 2/3/7/8/41/46/51/60/65 for pens; got #{h.pretty_inspect}"
                                 )
                                [0,41,46,51,60,65].include?( h['Type'] ) ? true : false
                              else
                                 false
                              end
                        end


    recs = recs.map { |h| build_penalty( h, players: players,
                                            team1_id: team1_id,
                                            team2_id: team2_id ) }
    recs
end
