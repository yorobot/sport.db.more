


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
