
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches(  season:,
                 slug:,
                 opt_country: false,
                 opt_stadium: true,
                 opt_teams: false  )   

   cup =  read_json( "./#{slug}/#{season}_matches.json" )
   cup = cup['Results']  ## only use results (match) array 

   ## pp cup
   puts "  #{cup.size} match(es) in season #{season}"


   cup = sort_matches( cup )


   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   buf << pp_stats( cup, opt_teams: opt_teams )
   buf << "\n"


lastStageName  = nil
lastGroupName  = nil

last_date      = nil

cup.each_with_index do |m, i|
  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

 
  team1 = m['Home'] ? build_team( m['Home'] ) : { name: '?', 
                                                      abbrev: '?',
                                                      country: '?' }
         
  team2 = m['Away'] ? build_team( m['Away'] ) : { name: '?', 
                                                      abbrev: '?',
                                                      country: '?' }
         

   
    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

     assert( dateTime.sec == 0 && localDateTime.sec == 0, 
                "sec 00 expected" )
  
    ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
    diff_in_hours = ((localDateTime - dateTime) * 24).to_f
    diff_in_days  =  localDateTime.jd - dateTime.jd 
    ## pp [diff_in_hours, diff_in_days]
                                                       
   stageName, groupName = norm_stage( stageName, groupName,
                             team1: team1,
                             team2: team2,
                             date: localDateTime.strftime( '%Y-%m-%d') )




  resultType  = m['ResultType']
  assert( [0, 1,2,3,8].include?(resultType), "resultType 1,2,3 expected; got #{resultType}" )

  score = _fmt_score( m )
  
   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchNumber = m['MatchNumber']       # optional
   matchDay  =  m['MatchDay']           # optional 
  
   
 

   stadium = build_stadium( m['Stadium'] )

    attendance = m['Attendance']
    



   if lastStageName.nil? || lastStageName != stageName
  
         buf << "\n" 
      
         buf << "▪ #{stageName}\n"

        lastStageName = stageName
        lastGroupName = nil
       last_date = nil
   end

   if groupName && (lastGroupName.nil? || lastGroupName != groupName)
  
      ## note - skip extra newline on first group
      buf << "\n"    if lastGroupName

      buf << "▪▪ #{groupName}\n"

      lastGroupName = groupName
      last_date = nil
   end
   
   

 ##
 ##  move to ppdebug (or ppdump??) !! 
 #  buf = String.new
 #  buf << "             #{stageName}"
 #  buf <<  ", #{groupName}"  if groupName
 #  buf << " \##{matchDay}" if matchDay
 #  buf << " (#{matchNumber})"  if matchNumber


      if last_date && (last_date.year  == localDateTime.year && 
                       last_date.month == localDateTime.month && 
                       last_date.day   == localDateTime.day)
        ## skip date header if same (local) date
      else
          ## e.g.   Fri Jun 7
       buf << "#{localDateTime.strftime('%a %b %-e')}\n"
      end 
   
     ## use   20:30 UTC+1  or 20:30 UTC-3
     buf <<  "  #{localDateTime.strftime( '%H:%M' )} UTC%+d" % diff_in_hours

     if opt_country
        buf <<  "   #{team1[:name]} (#{team1[:country]})"
        buf <<  "  #{score}  "
        buf <<  "#{team2[:name]} (#{team2[:country]})   "
     else
        buf <<  "   #{team1[:name]}  #{score}  #{team2[:name]}   "
     end

     if opt_stadium
       buf << "@ #{stadium[:name]}, #{stadium[:city_name]}"
     else
       buf << "@ #{stadium[:city_name]}"
     end
      
      buf << "\n"


   last_date = localDateTime
  
   ### get match (live) details
   live = read_json( "./#{slug}/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

    
    buf <<  pp_goals( live, players: players, 
                            indent:  17  )
  end
   
  buf
end

