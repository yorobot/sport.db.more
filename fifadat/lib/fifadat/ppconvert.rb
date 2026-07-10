

=begin
  -- collect--
stages:
teams:
stadiums:
matches:
=end


def pp_convert( slug:, season: )
  data = {}

    ## add slug & seasons (add name to be done!!)
    data[:slug]   = slug
    data[:season] = season


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



       ## add/track id too - why? why not?
       ##  rec[:id]  = m['IdMatch']


       ### add status
       ##    1 -  complete ??
       ##    0 -  future   ???
       ##    abd.
       ##    cancelled
       ##    etc.

       ## 0 =>   complete (OK)
       ## 1 =>   not yet played
       status = m['MatchStatus']
       timed  = m['TimeDefined']

       rec[:status] =  status    if status != 0
       rec[:timed]  =  timed     if status != 0 || timed == false



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

       dateTime       = parse_date( m['Date'] )    ## utc
       localDateTime  = parse_date( m['LocalDate'] )

        assert( dateTime.sec == 0 && localDateTime.sec == 0,
                  "sec 00 expected" )

        ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
        diff_in_hours = ((localDateTime - dateTime) * 24).to_f
        diff_in_days  =  localDateTime.jd - dateTime.jd
        ## pp [diff_in_hours, diff_in_days]


     ## use   20:30 UTC+1  or 20:30 UTC-3
     rec[:date_local] = "#{localDateTime.strftime( '%Y-%m-%d %H:%M' )} UTC%+d" % diff_in_hours




       rec[:team1] = team1[:name]
       rec[:team2] = team2[:name]

#####
#  handle score
 ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

  resultType  = m['ResultType']

  assert( [0, 1,2,3,4,8].include?(resultType), "resultType 1,2,3,4 expected; got #{resultType}" )


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


       rec[:home]  = true    if m['IsHome']

       stadium = build_stadium( m['Stadium'] )
       rec[:stadium] = {  name: stadium[:name],
                          city: stadium[:city] }

       attendance = m['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance



if m['Home'] && m['Away']

   ### get match (live) details
   date_str = localDateTime.strftime('%Y-%m-%d')
   team1_code = m['Home']['Abbreviation']
   team2_code = m['Away']['Abbreviation']
   idMatch    = m['IdMatch']

   live_path = "./#{slug}/matches/#{season}/#{date_str}_#{team1_code}-#{team2_code}__#{idMatch}.json"
   live = read_json( live_path )


   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

   ##   add goals
   ##
   goals1 = build_goals( live['HomeTeam']['Goals'], players: players )
   goals2 = build_goals( live['AwayTeam']['Goals'], players: players )

   rec[:goals1] = goals1
   rec[:goals2] = goals2

   ##  add penalties !!!
   ##  fix-fix-fix

   ##  add sent-off (red & yellow-red cards!)
   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )
   players2.add_bookings( live['AwayTeam']['Bookings'])

   reds1 = players1.sentoff
   reds2 = players2.sentoff
   rec[:reds1] = reds1    unless reds1.empty?
   rec[:reds2] = reds2    unless reds2.empty?
end


=begin
   "Officials":
     [{"IdCountry": "BRA",
       "OfficialId": "361561",
       "NameShort": [{"Locale": "en-GB", "Description": "Wilton SAMPAIO"}],
       "Name": [{"Locale": "en-GB", "Description": "Wilton SAMPAIO"}],
       "OfficialType": 1,
       "TypeLocalized": [{"Locale": "en-GB", "Description": "Referee"}]},
      {"IdCountry": "PAR",
       "OfficialId": "416159",
       "NameShort":
        [{"Locale": "en-GB", "Description": "Juan Gabriel BENITEZ"}],
       "Name": [{"Locale": "en-GB", "Description": "Juan Gabriel Benítez"}],
       "OfficialType": 4,
       "TypeLocalized":
        [{"Locale": "en-GB", "Description": "Fourth official"}]}],
=end

###
##  add referees
    officials = build_officials( m['Officials'], id: false )

    if officials.size == 0
      puts "!! WARN no refs / officials found"
    else
         rec[:referees] = officials
    end




      recs << rec
   end
   data[:matches] = recs

  data
end
