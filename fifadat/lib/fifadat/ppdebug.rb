


def pp_debug( data )

   errors = []


   matches = data['Results']  ## only use results (match) array

   ## get SeasonName from first match
   m = matches[0]
   competitionName = desc( m['CompetitionName'])
   seasonName      = desc( m['SeasonName'])


   ## pp data
   puts "  #{matches.size} match(es) in  #{competitionName} / #{seasonName}"


   buf = String.new

matches.each_with_index do |m, i|


## todo -- log match details
##          if matchstatus   not 0,1
##      or result type       not 0,1,2,3,4,5  !!!


   buf << "==> [#{i+1}/#{matches.size}]  "
   buf << pp_match(m)


   idMatch =  m['IdMatch']

   matchStatus = m['MatchStatus']
   resultType  = m['ResultType']

  ## add aggregate score too
  score        = [m['HomeTeamScore'],        m['AwayTeamScore']].compact
  penScore = [m['HomeTeamPenaltyScore'], m['AwayTeamPenaltyScore']].compact
  aggScore = [m['AggregateHomeTeamScore'],m['AggregateAwayTeamScore']].compact


  if resultType == 0 && !score.empty?
       ##  pachuca vs salzburg in cwc 2025??
       ##  double check if score present
     ##  raise ArgumentError,
     ##    " resultType == 0 but score present idMatch #{m['IdMatch']} #{m['HomeTeamScore']}-#{m['AwayTeamScore']}"

     msg = " resultType == 0 but score present idMatch #{idMatch} #{score.inspect}"
     errors << msg
  end

   if ![0,1,9].include?(matchStatus)
      msg =  "matchStatus 0-END,1-SCHED,9-AWD expected; got #{matchStatus} in: #{m.pretty_inspect}"
      errors << msg
   end

  if ![0,1,2,3,4,5,8,12].include?(resultType)
     msg = "resultType 0,1,2,3,4,5,8,12 expected; got #{resultType} in: #{m.pretty_inspect}"
     errors << msg
  end
end


   [buf, errors]
end