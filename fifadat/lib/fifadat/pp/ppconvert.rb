

=begin
  -- collect--
stages:
teams:
stadiums:
matches:
=end

def pp_convert( slug:, season: )
  data = {}

   matches =  read_json( "./#{slug}/#{season}_matches.json" )
   matches = matches['Results']  ## only use results (match) array

   ## pp matches
   puts "  #{matches.size} match(es) in season #{season}"


  ## read in stages
  ##   incl.  SequenceOrder, StageLevel (optional)
  stages = Stages.read( "./#{slug}/misc/#{season}_stages.json" )


  stages.add_matches( matches )
  data[:stages] = stages.as_json


   teams = Teams.new
   teams.add_matches( matches )
   data[:teams] = teams.as_json


   stadiums = Stadiums.new
   stadiums.add_matches( matches )
   data[:stadiums] = stadiums.as_json



   recs = []
   matches.each_with_index do |m, i|
      rec = {}

      team1 = m['Home'] ? build_team( m['Home'] ) : { name: '?',
                                                      abbrev: '?',
                                                      country: '?' }

      team2 = m['Away'] ? build_team( m['Away'] ) : { name: '?',
                                                      abbrev: '?',
                                                      country: '?' }


       rec[:stage]  = desc( m['StageName'] )

       matchday  = m['MatchDay']           # optional
       rec[:matchday]  = matchday.to_i(10)  if matchday   ## convert to int if str - why? why not??

       group = desc( m['GroupName'] )  # optional
       rec[:group]  = group   if group


       num  = m['MatchNumber']        # optional
       rec[:num]  = num   if num    ## convert to int if string?

       ##  use datetime_utc/local - why? why not?
       rec[:date_utc]   = m['Date']     ## utc

       ### fix/fix/fix - change to   UTC+-2/3/etc format!!!
       rec[:date_local] = m['LocalDate']


       rec[:team1] = team1[:name]
       rec[:team2] = team2[:name]

#####
#  handle score
 ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

  resultType  = m['ResultType']

  # resultType
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR


  #
  #  check for  two-leg plays
  ##           resultType 4 & 8 ???
  ##          add flag  - aggregate true|flase or such

  score = if resultType == 2   ## aet, win on pens
             { et: [m['HomeTeamScore'],m['AwayTeamScore']],
               p:  [m['HomeTeamPenaltyScore'],m['AwayTeamPenaltyScore']] }
           elsif resultType == 3 || resultType == 8  ## aet
             { et: [m['HomeTeamScore'], m['AwayTeamScore']] }
           elsif  resultType == 1  ||  ## assume 1 - regular (90 mins+stoppage/injury time)
                  resultType == 4  ||
                  m['IdMatch'] == '400019191'  ##  fix for pachuca vs salzburg !!!
             { ft: [m['HomeTeamScore'],m['AwayTeamScore']] }
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


        rec[:score] = score     if score



       stadium = build_stadium( m['Stadium'] )
       rec[:stadium] = {  name: stadium[:name],
                          city: stadium[:city_name] }

       attendance = m['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance


       ## add/track id too - why? why not?
       ##  rec[:id]  = m['IdMatch']


       ### add status
       ##    1 -  complete ??
       ##    0 -  future   ???
       ##    abd.
       ##    cancelled
       ##    etc.


      recs << rec
   end
   data[:matches] = recs

  data
end
