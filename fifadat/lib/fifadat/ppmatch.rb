

## todo/check:
##    use: fomat:  full/fuller, short/long or such - why? why not?
def pp_match( m, season: false )

   competitionName = desc( m['CompetitionName'])
   seasonName      = desc( m['SeasonName'])


  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchDay    = m['MatchDay']           # optional

   matchNumber = m['MatchNumber']        # optional

   team1 = m['Home'] ? { name:    desc( m['Home']['TeamName'] ),
                        abbrev:  m['Home']['Abbreviation'],
                        country: m['Home']['IdCountry'],
                       }
                    :  { name: '?',  abbrev: '?',  country: '?'  }

   team2 = m['Away'] ? { name:    desc( m['Away']['TeamName'] ),
                        abbrev:  m['Away']['Abbreviation'],
                        country: m['Away']['IdCountry'],
                       }
                     : { name: '?', abbrev: '?', country: '?' }


  matchStatus  = m['MatchStatus']
  resultType  = m['ResultType']

  ## add aggregate score too
  score        = [m['HomeTeamScore'],        m['AwayTeamScore']].compact
  penScore = [m['HomeTeamPenaltyScore'], m['AwayTeamPenaltyScore']].compact
  aggScore = [m['AggregateHomeTeamScore'],m['AggregateAwayTeamScore']].compact



   buf = String.new


   if season
     ## beautify
     ##   possible rm competitionName from season

     seasonNameAlt = seasonName.sub( competitionName, '').gsub( /[ ]{2,}/,' ').strip
    buf << "== #{competitionName}"
    buf << " | #{seasonNameAlt}"
    buf << "\n"
   end


   buf << "#{matchStatus}-#{MATCH_STATUS[matchStatus]||'??'}  "
   buf << "  ▪ #{stageName}"
   buf <<  ", #{groupName}"    if groupName
   buf << " - #{matchDay}"     if matchDay
   buf << " (#{matchNumber})"  if matchNumber

   buf <<  "   #{team1[:name]} | #{team1[:abbrev]} (#{team1[:country]})"
   buf <<  " v "
   buf <<  "#{team2[:name]} | #{team2[:abbrev]} (#{team2[:country]})  "
   buf << "\n"

   buf <<  "  "
   buf <<  " (#{resultType}-#{RESULT_TYPE[resultType]||'??'})"
   buf <<  "  score: #{score.inspect}"   unless score.empty?
   buf <<  " pen: #{penScore.inspect}"   unless penScore.empty?
   buf <<  " agg: #{aggScore.inspect}"   unless aggScore.empty?
   buf <<  "\n"

   buf
end
