


def pp_matches_full( season:,
                     slug:,
                     country: false  )

   cup =  read_json( "./#{slug}/#{season}_matches.json" )
   cup = cup['Results']  ## only use results (match) array 

   ## pp cup
   puts "  #{cup.size} match(es) in season #{season}"


   cup = sort_matches( cup )


   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   buf << pp_stats( cup )
   buf << "\n"



lastStageName  = nil
lastGroupName  = nil


cup.each_with_index do |m, i|
  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

  stageName   = desc( m['StageName'] )

  team1 = m['Home'] ? build_team( m['Home'] ) : { name: '?', 
                                                  abbrev: '?' }
         
  team2 = m['Away'] ? build_team( m['Away'] ) : { name: '?', 
                                                  abbrev: '?' }
         


  resultType  = m['ResultType']
  assert( [0, 1,2,3,8].include?(resultType), "resultType 1,2,3 expected; got #{resultType}" )

  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = _fmt_score( m ) 
  

   matchNumber = m['MatchNumber']       # optional
   matchDay    =  m['MatchDay']           # optional 
   groupName   =  desc( m['GroupName'] )  # optional
  
 
   # "Date": "2026-06-12T19:00:00Z",
   # "LocalDate": "2026-06-12T15:00:00Z",
   
    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

     assert( dateTime.sec == 0 &&
            localDateTime.sec == 0, "sec 00 expected" )
  
    
 
    date       = "%d/%d/%d" % [dateTime.day, dateTime.month, dateTime.year] 
    date_local = localDateTime.strftime( '%b %-e' )

    wday_local = localDateTime.strftime( '%a' )
    time       = dateTime.strftime( '%H:%M' )
    time_local = localDateTime.strftime( '%H:%M' ) 

    ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
    diff_in_hours = ((localDateTime - dateTime) * 24).to_f
    diff_in_days  =  localDateTime.jd - dateTime.jd 
    ## pp [diff_in_hours, diff_in_days]

    if !(dateTime.month == localDateTime.month &&
         dateTime.day   == localDateTime.day) 
      ## puts "   !!! daytime border - date #{dateTime} != localDate #{localDateTime}" 
    end


    stadium = build_stadium( m['Stadium'] )

    attendance = m['Attendance']
    


   if lastStageName.nil? || lastStageName != stageName
      
         buf << "▪ #{stageName}\n"

        lastStageName = stageName
        lastGroupName = nil
   end

   if groupName && (lastGroupName.nil? || lastGroupName != groupName)
  
      buf << "▪▪ #{groupName}\n"

      lastGroupName = groupName
   end
   
   


     use_date_utc = false # true 

   if use_date_utc
         ###  use  20:30 +200 (18:30 UTC)
     buf << "#{wday_local} #{date_local} #{time_local} %+d00" % diff_in_hours
     if time != time_local
       buf << " (#{time} UTC" 
       buf << ", %+dd" % -diff_in_days   if diff_in_days != 0   
       buf << ")"
     end
   else 
        ## use   20:30 UTC+1  or 20:30 UTC-3
     buf << "#{wday_local} #{date_local} #{time_local} UTC%+d" % diff_in_hours
   end

   
   buf << " @ #{stadium[:name]}, #{stadium[:city_name]}"
   buf << ", Att: #{attendance}"   if attendance
   buf << "\n"
    
   buf <<  "  #{team1[:name]} v #{team2[:name]}  #{score}"
   buf << "\n"
  
  
   ### get match (live) details
   live = read_json( "./#{slug}/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

    
    buf <<  pp_goals( live, players: players, 
                            indent:  4 )
 
    ##
    ##  add team line-ups
    puts "  #{team1[:name]} v #{team2[:name]}  #{score}   - #{localDateTime}"
    

   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players1.add_subs( live['HomeTeam']['Substitutions'])
   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )
   players2.add_subs( live['AwayTeam']['Substitutions'])
   players2.add_bookings( live['AwayTeam']['Bookings'])





   ##########
   ##   add penalty kicks / penalties

   if resultType == 2   ## aet, win on pens
      ### get timeline with penalty shoot-out details
      timeline = read_json( "./#{slug}/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

      pens = build_penalties( timeline['Event'], players: players )
      pp pens

      buf << "\n"
      buf << "Penalties: #{pppenalties( pens, indent: 11 )}\n" 
   end


   lineup1 = players1.lineup
   lineup2 = players2.lineup


   if !( team1[:name] == 'Turkey' &&
         team2[:name] == 'South Korea')  ## 1954-06-20  - only 10 player in south koera team listed!!
     
     [lineup1,lineup2].each do |lineup|
       if lineup.size != 11

         players1.dump
         puts "---"
         players2.dump
         puts "---"

         pp lineup

        puts " in match #{team1[:name]} v #{team2[:name]}  #{score}"
        puts "   #{localDateTime}"
      end

      assert( lineup.size == 11, "expected 11 players, got #{lineup.size}" )
     end
   end

   buf << "\n"
   buf << "#{team1[:name]}: "+ pplineup( lineup1 ) + "\n"
   buf << "#{team2[:name]}: "+ pplineup( lineup2 ) + "\n"
   buf << "\n"


###
##  add referees
    officials = build_officials( m['Officials'] )
    
    buf << "Refs: " + ppofficials( officials )
    buf << "\n"

    
    buf << "\n\n"  
end
   

  buf
end


