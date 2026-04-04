


def pp_matches_full( season:,
                     slug:,
                     opt_country: false,
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
         


  resultType  = m['ResultType']
  assert( [0,1,2,3,8].include?(resultType), 
            "resultType 0,1,2,3 expected; got #{resultType}" )

  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = _fmt_score( m ) 
  

   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchNumber = m['MatchNumber']         # optional
   matchDay    =  m['MatchDay']           # optional 
  
  
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


 
    ##
    ##  for debugging output match line (before goals, line-up, penalties, etc)
    puts "  #{team1[:name]} v #{team2[:name]}  #{score}   - #{localDateTime}"
 


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
   
   

     use_date_utc = false    # true 

##
## e.g. sample with DAY SHIFT!!! 
##          Sat Jan 6 22:00 -300 (01:00 UTC, +1d)
 
   if use_date_utc
    ##  Fri Jan 7 20:30 +200 (18:30 UTC)
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " %+d00" % diff_in_hours

     if localDateTime.hour    != dateTime.hour &&
        localDateTime.minutes != dateTime.minutes
       buf << " (#{dateTime.strftime( '%H:%M')} UTC" 
       buf << ", %+dd" % -diff_in_days   if diff_in_days != 0   
       buf << ")"
     end
   else 
        ## use Fir Jan 7 20:30 UTC+1  or 20:30 UTC-3
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " UTC%+d" % diff_in_hours
   end

   
   buf << " @ #{stadium[:name]}, #{stadium[:city_name]}"
   buf << ", Att: #{attendance}"   if attendance
   buf << "\n"
    
   if opt_country
     buf <<  "  #{team1[:name]} (#{team1[:country]}) v #{team2[:name]} (#{team2[:country]})"
     buf <<  "  #{score}"  
   else
     buf <<  "  #{team1[:name]} v #{team2[:name]}  #{score}"
   end   
    
   buf << "\n"
  
  
   ### get match (live) details
   live = read_json( "./#{slug}/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

    
    buf <<  pp_goals( live, players: players, 
                            indent:  4 )
 
    
   ##########
   ##   add penalty kicks / penalties

   if resultType == 2   ## aet, win on pens
      ### get timeline with penalty shoot-out details
      timeline = read_json( "./#{slug}/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

      pens = build_penalties( timeline['Event'], players: players )
      ## pp pens

      buf << "\n"
      buf << "Penalties: #{pp_penalties( pens, indent: 11 )}\n" 
   end






   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players1.add_subs( live['HomeTeam']['Substitutions'])
   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )
   players2.add_subs( live['AwayTeam']['Substitutions'])
   players2.add_bookings( live['AwayTeam']['Bookings'])


   lineup1 = players1.lineup
   lineup2 = players2.lineup

   if players1.size == 0 &&
      players2.size == 0
      puts "!! WARN - no players available - skipping line-ups for teams!!!!!"
   else
     if !((team1[:name] == 'Turkey' &&
           team2[:name] == 'South Korea')  ||  ## 1954-06-20  - only 10 player in south koera team listed!!
          (team1[:name] == 'Palmeiras' &&
           team2[:name] == 'Tigres UANL')  ||     ##  2021-02-07T21:00:00+00:00 expected 11 players, got 10
          (team1[:name] == 'Al Ahly FC' &&
           team2[:name] == 'Palmeiras')    ##      2021-02-11T18:00:00+00:00 expected 11 players, got 10
         )
         
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
     buf << "#{team1[:name]}: "+ pp_lineup( lineup1 ) + "\n"
     buf << "#{team2[:name]}: "+ pp_lineup( lineup2 ) + "\n"
     buf << "\n"
   end

###
##  add referees
    officials = build_officials( m['Officials'] )

    if officials.size == 0
      puts "!! WARN no refs / officials found"
    else    
      buf << "Refs: " + pp_officials( officials )
      buf << "\n"
    end

    
    buf << "\n\n"  
end
   

  buf
end


