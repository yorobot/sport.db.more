
def convert_reports( slug:, season:,
                         indir: '.',
                         outdir: './tmp' )

   season = Season(season)

   matches =  read_json_v2( "#{indir}/#{slug}/#{season.to_path}_matches.json" )
   matches = matches['Results']  ## only use results (match) array

   ## pp matches
   puts "  #{matches.size} match(es) in season #{season}"
   matches.each_with_index do |m, i|

      next   if m['Home'].nil? && m['Away'].nil?



      localDateTime  = parse_date( m['LocalDate'] )

      ### get match (live) details
      date_str = localDateTime.strftime('%Y-%m-%d')
      team1_code = m['Home']['Abbreviation']
      team2_code = m['Away']['Abbreviation']
      idMatch    = m['IdMatch']

      live_path = "#{indir}/#{slug}/matches/#{season.to_path}/#{date_str}_#{team1_code}-#{team2_code}__#{idMatch}.json"
      live = read_json_v2( live_path )


      rec = {}

      rec[:name] =  desc(live['SeasonName'])

       status = live['MatchStatus']
       timed  = live['TimeDefined']

       rec[:status] =  status    if status != 0
       rec[:timed]  =  timed     if status != 0 || timed == false


      team1 = live['HomeTeam'] ? build_team( live['HomeTeam'] ) : { name: '?',
                                                             abbrev: '?',
                                                              country: '?' }

      team2 = live['AwayTeam'] ? build_team( live['AwayTeam'] ) : { name: '?',
                                                          abbrev: '?',
                                                          country: '?' }


       rec[:stage]  = desc( live['StageName'] )

       matchday  = live['MatchDay']           # optional
       rec[:matchday]  = matchday.to_i(10)  if matchday   ## convert to int if str - why? why not??

       group = desc( live['GroupName'] )  # optional
       rec[:group]  = group   if group


       num  = live['MatchNumber']        # optional
       rec[:num]  = num   if num    ## convert to int if string?


       ##  use datetime_utc/local - why? why not?
       rec[:date_utc]   = live['Date']     ## utc

       ### fix/fix/fix - change to   UTC+-2/3/etc format!!!
       dateTime       = parse_date( live['Date'] )    ## utc
       localDateTime  = parse_date( live['LocalDate'] )

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


  resultType  = live['ResultType']

  score = _parse_score( live )
  rec[:score] = score    if !score.empty?


        stadium  = build_stadium( live['Stadium'] )

        rec[:stadium] = {  name: stadium[:name],
                           city: stadium[:city],
                           street: stadium[:street],
                           country: stadium[:country] }

       attendance = live['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance


##  add goals
   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )


   rec[:goals1] = build_goals( live['HomeTeam']['Goals'], players: players )
   rec[:goals2] = build_goals( live['AwayTeam']['Goals'], players: players )

##
##  add players
   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )


   rec[:formation1] = live['HomeTeam']['Tactics']   ## e.g. "Tactics": "3-1-4-2"
   rec[:lineup1] = players1.lineup   ## starter XI
   rec[:bench1]  = players1.bench    ## substitutes

   rec[:formation2] = live['AwayTeam']['Tactics']
   rec[:lineup2] = players2.lineup
   rec[:bench2]  = players2.bench



## add bookings (yellow/red/red-yellow cards)


## add substitutions (off/on - in/out)
   rec[:subs1] = build_subs( live['HomeTeam']['Substitutions'], players: players )
   rec[:subs2] = build_subs( live['AwayTeam']['Substitutions'], players: players )



## add referees
   officials = build_officials( live['Officials'] )

    if officials.size == 0
      puts "!! WARN no refs / officials found"
    else
         rec[:referees] = officials
    end


      outpath = "#{outdir}/#{season.to_path}/#{slug}/#{date_str}_#{team1_code}-#{team2_code}.json"
      write_json( outpath, rec )
   end
end
