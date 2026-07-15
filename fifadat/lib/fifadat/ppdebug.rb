


def pp_debug( data )

   errors = []


   stats = {
            ## match stats
              'MatchStatus' => Hash.new(0),
              'ResultType'  => Hash.new(0),
              'TimeDefined' => Hash.new(0),
              'Leg'         => Hash.new(0),
              'IsHomeMatch' => Hash.new(0),
              'MatchDay'    => Hash.new(0),
              'MatchNumber' => Hash.new(0),
              'Attendance'  => Hash.new(0),
              'Weather'     => Hash.new(0),

              ## add stage & group
              ##  add agg score and pen score!!

            ## team stats
              'TeamType'     => Hash.new(0),
              'AgeType'      =>  Hash.new(0),
              'FootballType' => Hash.new(0),
            }

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
      msg =  "matchStatus 0-FIN,1-SCHED,9-AWD expected; got #{matchStatus} in: #{m.pretty_inspect}"
      errors << msg
   end

  if ![0,1,2,3,4,5,8,12].include?(resultType)
     msg = "resultType 0,1,2,3,4,5,8,12 expected; got #{resultType} in: #{m.pretty_inspect}"
     errors << msg
  end



   ##
   ## check usage
   stats[ 'MatchStatus' ][m['MatchStatus']] +=1
   stats[ 'ResultType'][m['ResultType']] +=1

   stats[ 'TimeDefined'][m['TimeDefined']] +=1

   stats[ 'Leg'][m['Leg']] +=1
   stats[ 'IsHomeMatch'][m['IsHomeMatch']] +=1

   stats[ 'MatchDay'][!m['MatchDay'].nil?] +=1
   stats[ 'MatchNumber'][!m['MatchNumber'].nil?] +=1
   stats[ 'Attendance'][!m['MatchDay'].nil?] +=1
   stats[ 'Weather'][!m['Weather'].nil?] +=1

=begin
    if m['Home']
      stats[ 'TeamType'][m['Home']['TeamType']] +=1
      stats[ 'AgeType'][m['Home']['AgeType']] +=1
      stats[ 'FootballType'][m['Home']['FootballType']] +=1
    end
    if m['Away']
      stats[ 'TeamType'][m['Away']['TeamType']] +=1
      stats[ 'AgeType'][m['Away']['AgeType']] +=1
      stats[ 'FootballType'][m['Away']['FootballType']] +=1
    end
=end
end



   ## note - move stats up-front into header
   # header = String.new
   # header << "stats:\n"
   # header <<  stats.pretty_inspect
   # header << "\n"


   [buf, stats, errors]
end