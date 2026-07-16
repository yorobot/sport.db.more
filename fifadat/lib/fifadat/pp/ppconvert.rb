


##
##
##  fix-fix-fix   -- add (shared)     _build_date_local( m )
##                                         in pphelper-date.rb
###


def convert( slug:, season:,
                indir: '.',
                outdir: './tmp' )

    season = Season(season)

    data = {}

    ## add slug & seasons (add name to be done!!)
    data[:slug]   = slug
    data[:season] = season


   matches =  read_json_v2( "#{indir}/#{slug}/#{season.to_path}_matches.json" )
   matches = matches['Results']  ## only use results (match) array

   ## pp matches
   puts "  #{matches.size} match(es) in season #{season}"


  ## read in stages
  ##   incl.  SequenceOrder, StageLevel (optional)
  stages = Stages.read( "#{indir}/#{slug}/misc/#{season.to_path}_stages.json" )


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



       ## 0 =>   FINISHED/complete (OK)
       ## 1 =>   SCHEDULED/not yet played
       status = m['MatchStatus']
       timed  = m['TimeDefined']

       rec[:status] =  status    if status != 0
       rec[:timed]  =  timed     if status != 0 || timed == false



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




       ##  pass along as is for now - why? why not
       ##   note - Date is date_utc and
       ##      LocalDate is date_local (also in utc BUT different HH:MM or possible day)
       ## note - also in utc, that is, timezone is Z (not +03:00 or such!!!)

       dateTime       = parse_date_utc( m['Date'] )
       localDateTime  = parse_date_utc( m['LocalDate'] )

       ## note - cut-off/remove seconds
       rec[:date_utc]   = dateTime.strftime( '%Y-%m-%dT%H:%M%z' )

       ## note - use  20:30 UTC+1  or 20:30 UTC-3  for timezone format for now
       rec[:date_local] = _fmt_date_local( dateTime, localDateTime )



       team1 =  build_team( m['Home'] )
       team2 =  build_team( m['Away'] )

       rec[:team1] = team1[:name]
       rec[:team2] = team2[:name]


  #####
  #  handle score
  ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc


     ### fix - add postponed
     ##            awarded etc.
     ##    REGULAR - why? why not?
     resultType  = m['ResultType']


     score = _parse_score( m )
     rec[:score] = score      unless score.empty?


       ## check - never in use?
       rec[:home]  = true    if m['IsHome']


       ## add country to stadium too - why? why not?
       stadium = build_stadium( m['Stadium'] )
       rec[:stadium] = {  name:    stadium[:name],
                          city:    stadium[:city] }

       attendance = m['Attendance']
       rec[:attendance] = attendance.to_i(10)   if attendance



   ### get match (live) details
   ###
   ##   check if match report exits
   ##    optional for now!!

   date_str   = localDateTime.strftime('%Y-%m-%d')
   team1_code = team1[:code]
   team2_code = team2[:code]
   idMatch    = m['IdMatch']

   live_path = "#{indir}/#{slug}/matches/#{season.to_path}/#{date_str}_#{team1_code}-#{team2_code}__#{idMatch}.json"

   if File.file?( live_path )

     live = read_json_v2( live_path )

     ## all players (for lookup)
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


     ## players by team1/team2
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
       ## puts "!! WARN no refs / officials found"
    else
         rec[:referees] = officials
    end




      recs << rec
   end
   data[:matches] = recs


    outpath =  "#{outdir}/#{season.to_path}/#{slug}.json"
    write_json( outpath, data)
    puts "  written to >#{outpath}<"

    true
end
