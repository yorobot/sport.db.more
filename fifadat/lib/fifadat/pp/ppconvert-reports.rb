

##
##   read & build match report



## use mk/build_report_basename - why? why not?
def _report_basename( m )
      ### get match (live) details
      team1_code = m['Home']['Abbreviation']
      team2_code = m['Away']['Abbreviation']
      localDateTime  = parse_date_utc( m['LocalDate'] )

      ##  e.g.  2020-06-24_RAP-AUS__54545454
      basename = String.new
      basename += localDateTime.strftime('%Y-%m-%d')    ##   i) date
      basename += "_#{team1_code}-#{team2_code}"        ##  ii) team1 v team2

      basename
end

def _read_report( m, report_dir: )
      return nil     if m['Home'].nil? || m['Away'].nil?

      ##  e.g.  2020-06-24_RAP-AUS__54545454
      #   note - add match id for "raw" match reports!!!
      basename = _report_basename( m )
      basename += "__#{m['IdMatch']}"

      ## #{indir}/#{slug}/matches/#{season.to_path}
      live_path = "#{report_dir}/#{basename}.json"

      ## note - skip if no match report available!!!
      if File.file?( live_path )
         live = read_json_v2( live_path )
         live
      else
         nil
      end
end


def _build_report( live )
       rec = {}


       status = live['MatchStatus']
       timed  = live['TimeDefined']

       if status == 1 && timed    ## note: use TIMED (instead of SCHEDULED)
          rec[:status] = 'TIMED'
       else
          rec[:status] = MATCH_STATUS[ status ] || "#{status}-???"
       end


       rec[:stage]  = desc( live['StageName'] )

       ## group, matchday, (match)num  optional
       group = desc( live['GroupName'] )  # optional
       rec[:group]  = group   if group

       matchday  = live['MatchDay']
       rec[:matchday]  = matchday.to_i(10)   if matchday   ## convert to int if str - why? why not??

       num  = live['MatchNumber']        # optional
       rec[:num]  = num   if num


       ##  use datetime_utc/local - why? why not?
       rec[:date_utc]   = live['Date']     ## utc

       dateTime       = parse_date_utc( live['Date'] )
       localDateTime  = parse_date_utc( live['LocalDate'] )

       if timed
          rec[:datetime_utc]   = dateTime.strftime( '%Y-%m-%dT%H:%MZ' )
          rec[:datetime_local] = _fmt_date_local( dateTime, localDateTime )
       else
          rec[:date]           = dateTime.strftime( '%Y-%m-%d' )
       end


       team1 = build_team( live['HomeTeam'] )
       team2 = build_team( live['AwayTeam'] )


       ##  use full team details here (via lookup) - why? why not?
       rec[:team1] = team1[:name]
       rec[:team2] = team2[:name]


        ### fix - add postponed
        ##            awarded etc.
        ##    REGULAR - why? why not?
        resultType  = live['ResultType']


        score = _parse_score( live )
        rec[:score] = score      unless score.empty?


        stadium  = build_stadium( live['Stadium'] )

         ##  use full stadium details here (via lookup) - why? why not?
        rec[:stadium] = {  name: stadium[:name],
                           city: stadium[:city],
                           street: stadium[:street],
                           country: stadium[:country] }

       attendance = live['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance


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




def convert_reports( slug:, season:,
                         indir: '.',
                         outdir: './tmp' )

   season = Season(season)

   data =  read_json_v2( "#{indir}/#{slug}/#{season.to_path}_matches.json" )
   matches = data['Results']  ## only use results (match) array
   puts "  #{matches.size} match(es) in season #{season}"


   report_dir = "#{indir}/#{slug}/matches/#{season.to_path}"

   matches.each_with_index do |m, i|
      live = _read_report( m, report_dir: report_dir )

      ## no report found; continue
      next  if live.nil?

      rec = {
               name: desc(live['SeasonName'])
            }.merge( _build_report( live ))

      ## build basename e.g  2026-07-15_ARG-ENG
      basename = _report_basename( m )
      outpath = "#{outdir}/#{season.to_path}/#{slug}/#{basename}.json"
      write_json( outpath, rec )
   end
end
