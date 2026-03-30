
def _fmt_score( m )

  ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

  resultType  = m['ResultType']
 
  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = if resultType == 2   ## aet, win on pens 
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}" +
             " a.e.t., #{m['HomeTeamPenaltyScore']}-#{m['AwayTeamPenaltyScore']} pen."
           elsif resultType == 3 || resultType == 8  ## aet
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']} a.e.t."
           elsif  resultType == 1  ||  ## assume 1 - regular (90 mins+stoppage/injury time)
                  m['IdMatch'] == '400019191'  ##  fix for pachuca vs salzburg  
              "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}"
           elsif  resultType == 0
              ##  pachuca vs salzburg in cwc 2025??
               ##  double check if score present
               raise ArgumentError, 
                  " resultType == 0 but score present idMatch #{m['IdMatch']} #{m['HomeTeamScore']}-#{m['AwayTeamScore']}"  if m['HomeTeamScore'] &&
                                                                                                                               m['AwayTeamScore']
              ""
           else
              raise ArgumentError, "unknown/unexpected result type #{resultType}"
           end       
  
  score
end
  

