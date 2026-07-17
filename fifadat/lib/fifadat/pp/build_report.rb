


def _build_report( live, timeline=nil )
       rec = {}

####
##  add goals
   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

   rec[:goals1] = build_goals( live['HomeTeam']['Goals'], players: players )
   rec[:goals2] = build_goals( live['AwayTeam']['Goals'], players: players )


      ##########
      ##   add penalty kicks / penalties
      if live['ResultType'] == 2   ## aet, win on pens
         if timeline.nil?
            ##
            team1_code = live['HomeTeam']['Abbreviation']
            team2_code = live['AwayTeam']['Abbreviation']
            puts "!! ERROR - no timeline for match #{team1_code} v #{team2_code} with win on penalties!!"
            exit 1
         else
            ### get timeline with penalty shoot-out details
            ##     note - requires team1/2_ids!!!
            team1_id = live['HomeTeam']['IdTeam']
            team2_id = live['AwayTeam']['IdTeam']

            pens = build_penalties( timeline['Event'],
                                     players: players,
                                     team1_id: team1_id,
                                     team2_id: team2_id )
            pp pens

            rec[:penalties] = pens
         end
      end


##
##  add players by team1/team2
   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )


   rec[:formation1] = live['HomeTeam']['Tactics']   ## e.g. "Tactics": "3-1-4-2"
   rec[:lineup1] = players1.lineup   ## starter XI
   rec[:bench1]  = players1.bench    ## substitutes

   rec[:formation2] = live['AwayTeam']['Tactics']
   rec[:lineup2] = players2.lineup
   rec[:bench2]  = players2.bench


#####
## add bookings (yellow/red/red-yellow cards)
   players1.add_bookings( live['HomeTeam']['Bookings'])
   players2.add_bookings( live['AwayTeam']['Bookings'])


   yellow1    = players1.yellowcards
   red1       = players1.redcards
   yellowred1 = players1.yellowredcards
   rec[:yellow1]     = yellow1    unless yellow1.empty?
   rec[:red1]        = red1       unless red1.empty?
   rec[:yellowred1]  = yellowred1 unless yellowred1.empty?

   yellow2    = players2.yellowcards
   red2       = players2.redcards
   yellowred2 = players2.yellowredcards
   rec[:yellow2]     = yellow2    unless yellow2.empty?
   rec[:red2]        = red2       unless red2.empty?
   rec[:yellowred2]  = yellowred2 unless yellowred2.empty?



## add substitutions (off/on - in/out)
   rec[:subs1] = build_subs( live['HomeTeam']['Substitutions'], players: players1 )
   rec[:subs2] = build_subs( live['AwayTeam']['Substitutions'], players: players2 )


## add referees
   officials = build_officials( live['Officials'], id: false )

    if officials.empty?
      ## puts "!! WARN no refs / officials found"
    else
         rec[:referees] = officials
    end

    rec
end
