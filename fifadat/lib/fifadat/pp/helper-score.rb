
#
# add quick fix for club world cup?!
#      elsif  resultType == 1  ||  ## assume 1 - regular (90 mins+stoppage/injury time)
#              resultType == 4  ||
#        m['IdMatch'] == '400019191'  ##  fix for pachuca vs salzburg !!!
#   has resultType == 0!!!


def _parse_score( m )
   h = { }


  resultType  = m['ResultType']

  score =  if m['HomeTeam'] && m['AwayTeam']  ## assume inside (match) report
             [m['HomeTeam']['Score'], m['AwayTeam']['Score']].compact
          else   ## assume (seasons) matches list
            ## note - report has no "inline/flat" HomeTeamScore/AwayTeamScore
             [m['HomeTeamScore'], m['AwayTeamScore']].compact
          end


   ## is score after extra-time or not?
   ##    note - CANNOT tell for resultType 2!!!

   if score.empty?
       ## do nothing
   else
     if [1,4].include?( resultType )
        ##  1 - regular - 90min
        ##  4 - regular - 90min (on aggregate)
        h[:ft] = score
     elsif [3,5,8].include?( resultType )
         ## 3 - aet (for sure)
         ## 5 - aet [on aggregate] (for sure)
         ## 8 -  golden goal in extra time  (aet/gg)
        h[:et] = score   ## assume after extra-time !!!
     elsif resultType == 2
         ### note - 2 win on pens
         ## 2 - win on pens  (with or WITHOUT aet!!)

        ## check for competition for now
        ##    incl. south american
        if false   ## add some competitions here
           h[:ft] = score
        else
           h[:et] = score
        end
     else
        h[:score] = score
     end
    end


    penScore = [m['HomeTeamPenaltyScore'],  m['AwayTeamPenaltyScore']].compact
    aggScore = [m['AggregateHomeTeamScore'],m['AggregateAwayTeamScore']].compact


    ## note - worldcup has penScore [0,0] for all matches, for example!!!
     if penScore.empty? || penScore == [0,0]
     else
        h[:p] = penScore
     end

     h[:agg] = aggScore   if !aggScore.empty?
     h
end





__END__

  score = if resultType == 2   ## aet, win on pens
             { et: [m['HomeTeamScore'],m['AwayTeamScore']],
               p:  [m['HomeTeamPenaltyScore'],m['AwayTeamPenaltyScore']] }
           elsif resultType == 3 || resultType == 8  ## aet
             { et: [m['HomeTeamScore'], m['AwayTeamScore']] }
           elsif  resultType == 1  ||  ## assume 1 - regular (90 mins+stoppage/injury time)
                  resultType == 4  ||
                  m['IdMatch'] == '400019191'  ##  fix for pachuca vs salzburg !!!
             { ft: [m['HomeTeamScore'],m['AwayTeamScore']] }
           elsif  resultType == 12
               ## fix/fix/fix - check for score too
                nil
           elsif  resultType == 0
              ##  pachuca vs salzburg in cwc 2025??
               ##  double check if score present
               raise ArgumentError,
                  " resultType == 0 but score present idMatch #{m['IdMatch']} #{m['HomeTeamScore']}-#{m['AwayTeamScore']}"  if m['HomeTeamScore'] &&
                                                                                                                               m['AwayTeamScore']
              nil
           else
              raise ArgumentError, "unknown/unexpected result type #{resultType}"
           end
