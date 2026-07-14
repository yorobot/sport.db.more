

MATCH_STATUS = {
  0 => 'FIN',     # finished
  1 => 'SCHED',   # scheduled
  2 => 'LIVE',
  ## ???

  9 => 'AWD',    # awarded !!!
}


##
## Result: Al Duhail awarded a 3–0 walkover victory.
## Reason: Auckland City FC withdrew from the tournament
## due to strict COVID-19 pandemic quarantine and isolation measures
##  enforced by New Zealand authorities.

##
## check 2  is only win on pens!!!
##   might be WITHOUT extra time e.g. copa liber.
##  [28/142]  0-FIN    3rd Round   Sporting Cristal | SCL (PER) v Carabobo FC | CRB (VEN)
##                 (2-AET_WIN_ON_PENS)  score: [1, 2] pen: [3, 2] agg: [2, 2]
##   and others!!!
##
##   how to check if  extra time was played?? (use period??)


RESULT_TYPE = {
  0 => 'NO',
  1 => 'REGULAR',
  ## note - cannot tell if
  ##          win on penalties
  ##    is  after extra-time!!!
  ##      used many times in copa libertadores
  ##       check gold cup too
  2 => 'AET_WIN_ON_PENS',  ## or REG_WIN_ON_PENS or AGG_WIN_ON_PENS
  3 => 'AET',
  ##
  ## note - agg - used for 1st & 2nd leg
  4 => 'REGULAR/AGG',  ##  aggregate (1st/2nd leg) - regular
  5 => 'AET/AGG',      ##   aggregate  - after extra-time
  ## e.g.
  ## 2nd LegFeb 25, 2026 Juventus 3–2 (AET) Galatasaray
  ##                is/was    3-0 (REG)!!!

  12 => 'AWD',  ## AWARDED
}


##
## note - matchStatus  for 12-AWD should also be 9-AWD!!!

## resultType 12
## The Clausura 2022 match between Querétaro and Atlas on March 5, 2022,
##  was officially suspended in the 62nd minute
## and later recorded as a 3–0 victory for Atlas
##    : Atlas was leading 1–0 at the time of suspension.
##    Forfeit Victory: Atlas was officially awarded a 3–0 walkover win.


=begin
             0 =>  no result / not played yet
              1 => regular (90 mins)
              2 => aet (120 mins), win on pens
              3 => aet (120 mins)

              8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

              4 =>    aggregate  leg 1/2 ?? e.g.
                    "AggregateHomeTeamScore": 2,
                    "AggregateAwayTeamScore": 4,
=end



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


  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchDay    = m['MatchDay']           # optional

   matchNumber = m['MatchNumber']        # optional


   buf << "==> [#{i+1}/#{matches.size}]"
   buf << "  #{m['MatchStatus']}-#{MATCH_STATUS[m['MatchStatus']]||'??'}  "
   buf << "  #{stageName}"
   buf <<  ", #{groupName}"  if groupName
   buf << " \##{matchDay}" if matchDay
   buf << " (#{matchNumber})"  if matchNumber



  team1 = m['Home'] ? { name:    desc( m['Home']['TeamName'] ),
                        abbrev:  m['Home']['Abbreviation'],
                        country: m['Home']['IdCountry'],
                      } : { name: '?', abbrev: '?', country: '?' }

  team2 = m['Away'] ? { name:    desc( m['Away']['TeamName'] ),
                        abbrev:  m['Away']['Abbreviation'],
                        country: m['Away']['IdCountry'],
                      }  : { name: '?', abbrev: '?', country: '?' }


  buf <<  "   #{team1[:name]} | #{team1[:abbrev]} (#{team1[:country]})"
  buf <<  " v "
  buf <<  "#{team2[:name]} | #{team2[:abbrev]} (#{team2[:country]})  "
   buf << "\n"

  ###
  ## check score

  # resultType
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR


  resultType  = m['ResultType']

  ## add aggregate score too
  score        = [m['HomeTeamScore'],        m['AwayTeamScore']].compact
  penScore = [m['HomeTeamPenaltyScore'], m['AwayTeamPenaltyScore']].compact
  aggScore = [m['AggregateHomeTeamScore'],m['AggregateAwayTeamScore']].compact


   buf <<  "                "
   buf <<  " (#{resultType}-#{RESULT_TYPE[resultType]||'??'})"
   buf <<  "  score: #{score.inspect}"   unless score.empty?
   buf <<  " pen: #{penScore.inspect}"  unless penScore.empty?
   buf <<  " agg: #{aggScore.inspect}"  unless aggScore.empty?


  if resultType == 0 && !score.empty?
       ##  pachuca vs salzburg in cwc 2025??
       ##  double check if score present
     ##  raise ArgumentError,
     ##    " resultType == 0 but score present idMatch #{m['IdMatch']} #{m['HomeTeamScore']}-#{m['AwayTeamScore']}"

     msg = " resultType == 0 but score present idMatch #{m['IdMatch']} #{score.inspect}"
     errors << msg
  end



##
## "MatchStatus"=>9,  cancelled!!!!
##
##  "ResultType"=>12,
##  21:30  CD Independiente Medellín (COL) v CR Flamengo (BRA)        [cancelled]
##

  if ![0,1,2,3,4,5,8,12].include?(resultType)
     msg = "resultType 1,2,3,4,5,8,12 expected; got #{resultType} in: #{m.pretty_inspect}"
     errors << msg
  end

       ### add status
       ##    0 -  FINISHED
       ##    1 -  SCHEDULED
       ##    abd.
       ##    cancelled
       ##    etc.


       ## 0 =>   finished/complete (OK)
       ## 1 =>   not yet played
   matchStatus = m['MatchStatus']

   if ![0,1,9].include?(matchStatus)
      msg =  "matchStatus 0-FIN,1-SCHED,9-AWD expected; got #{matchStatus} in: #{m.pretty_inspect}"
      errors << msg
   end


  # resultType
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR



  buf <<  "\n"



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
end



   ## note - move stats up-front into header
   # header = String.new
   # header << "stats:\n"
   # header <<  stats.pretty_inspect
   # header << "\n"


   [buf, stats, errors]
end