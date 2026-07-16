


def _build_match( m )   ## use _fill/build_match_basics() or such ???
    rec = {}

    ## 0 =>   FINISHED/complete (OK)
       ## 1 =>   SCHEDULED/not yet played
       status = m['MatchStatus']
       timed  = m['TimeDefined']

       if status == 1 && timed    ## note: use TIMED (instead of SCHEDULED)
          rec[:status] = 'TIMED'
       else
          rec[:status] = MATCH_STATUS[ status ] || "#{status}-???"
       end



       rec[:stage]  = desc( m['StageName'] )

       ## check optional  group, matchday, (match) num
       ##    note - matchday is a string!! (check if always a number)
       ##      ## convert to int if str - why? why not??
       group = desc( m['GroupName'] )
       rec[:group]  = group   if group

       matchday  = m['MatchDay']
       rec[:matchday]  = matchday.to_i(10)  if matchday

       num  = m['MatchNumber']
       rec[:num]  = num   if num


       dateTime       = parse_date_utc( m['Date'] )
       localDateTime  = parse_date_utc( m['LocalDate'] )

       if timed
         ##  pass along as is for now - why? why not
         ##   note - Date is date_utc and
         ##      LocalDate is date_local (also in utc BUT different HH:MM or possible day)
         ## note - also in utc, that is, timezone is Z (not +03:00 or such!!!)

         ## note - use datetime  - why? why not?
         ##
         ## note - cut-off/remove seconds
         rec[:datetime_utc]   = dateTime.strftime( '%Y-%m-%dT%H:%MZ' )

         ## note - use  20:30 UTC+1  or 20:30 UTC-3  for timezone format for now
         rec[:datetime_local] = _fmt_date_local( dateTime, localDateTime )
       else
         rec[:date]      = dateTime.strftime( '%Y-%m-%d' )
       end



       if m['HomeTeam'] && m['AwayTeam']   ## assume match reports
         team1 = build_team( m['HomeTeam'] )
         team2 = build_team( m['AwayTeam'] )
          ##  use full team details here (via lookup)
         ##         when report (mode) - why? why not?
         rec[:team1] = team1[:name]
         rec[:team2] = team2[:name]
       else
         team1 =  build_team( m['Home'] )
         team2 =  build_team( m['Away'] )
         rec[:team1] = team1[:name]
         rec[:team2] = team2[:name]
       end



  #####
  #  handle score
  ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

     score = _parse_score( m )
     rec[:score] = score      unless score.empty?


       ## check - never in use?
       rec[:home]  = true    if m['IsHome']


       ## add country to stadium too - why? why not?
       stadium = build_stadium( m['Stadium'] )


       if m['HomeTeam'] && m['AwayTeam']   ## assume match reports
         rec[:stadium] = {  name: stadium[:name],
                            city: stadium[:city],
                            street: stadium[:street],
                            country: stadium[:country] }
       else
          rec[:stadium] = {  name:    stadium[:name],
                              city:    stadium[:city] }
       end

       attendance = m['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance


      rec
end



def _build_report( live )
       rec = _build_match( live )


####
##  add goals
   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

   rec[:goals1] = build_goals( live['HomeTeam']['Goals'], players: players )
   rec[:goals2] = build_goals( live['AwayTeam']['Goals'], players: players )



##
##  add players by team1/team2
   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )
   players2.add_bookings( live['AwayTeam']['Bookings'])


   rec[:formation1] = live['HomeTeam']['Tactics']   ## e.g. "Tactics": "3-1-4-2"
   rec[:lineup1] = players1.lineup   ## starter XI
   rec[:bench1]  = players1.bench    ## substitutes

   rec[:formation2] = live['AwayTeam']['Tactics']
   rec[:lineup2] = players2.lineup
   rec[:bench2]  = players2.bench


## add bookings (yellow/red/red-yellow cards)
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
   officials = build_officials( live['Officials'] )

    if officials.size == 0
      ## puts "!! WARN no refs / officials found"
    else
         rec[:referees] = officials
    end

    rec
end
