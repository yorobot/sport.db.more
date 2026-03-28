require_relative 'helper'



## pretty print matches



def sort_results( cup )
  ###
  ##   sort results by group if present

  ## add "old" sort index
  cup['Results'] = cup['Results'].each_with_index.map {|m,i| m['sort']=i+1; m }


  cup['Results'] =  cup['Results'].sort do |l,r|

   lhs_stageName =  desc( l['StageName'] )
   rhs_stageName =  desc( r['StageName'] )

   lhs_groupName  = desc( l['GroupName'] )  # optional
   rhs_groupName  = desc( r['GroupName'] )  # optional


   if lhs_groupName && rhs_groupName && (lhs_stageName == rhs_stageName) 
       res = lhs_groupName <=> rhs_groupName
       ## same group; sort by old index (or) date??
       res = l['sort'] <=> r['sort']   if res == 0
       res 
   else
       l['sort'] <=> r['sort']   ## keep as is
   end
  end

   cup
end


def collect_dates( cup, dates )
  ## collect min/max dates (duration - start/end)

  cup['Results'].each_with_index do |m, i|

    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

    ## note - alway use local datetime for now

   if dates[:start].nil? || localDateTime < dates[:start] 
        dates[:start] = localDateTime
   end

   if dates[:end].nil? || localDateTime > dates[:end] 
        dates[:end] = localDateTime
   end
  end
end



def pp_matches( cup, name:, season:  )

   cup = sort_results( cup )


   buf = String.new
   buf << "= #{name}\n"
   buf <<  "\n"


## add stats
##   number of teams
##   start/end dates and duration in days
##   number of matches

    dates = { start: nil, end: nil }
    collect_dates( cup, dates )

    diff_in_days =   dates[:end].jd - dates[:start].jd  
    buf << "# Dates    #{dates[:start].strftime('%a %b %-e')} - #{dates[:end].strftime('%a %b %-e %Y')} (#{diff_in_days}d)\n"

    teams = Teams.new
    collect_teams( cup, teams )

    buf << "# Teams    #{teams.size}\n"

    buf << "# Matches  #{cup['Results'].size}\n"

    ### get all stadiums
    stadiums = Stadiums.new
    collect_stadiums( cup, stadiums )

    buf << "# Venues   #{stadiums.size}"
    cities = stadiums.cities
    buf << (cities.size == 1 ? " (in 1 city)" : " (in #{cities.size} cities)")
    buf << "\n"


    stadiums.recs.each do |rec|
       buf << "#   #{rec[:name]}, #{rec[:city_name]} (#{rec[:id_country]})\n"
    end
    buf << "\n"


lastStageName  = nil
lastGroupName  = nil

last_date      = nil

cup['Results'].each_with_index do |m, i|
  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

  stageName   = desc( m['StageName'] )

  team1 = m['Home'] ? build_team_rec( m['Home'] ) : { name: '?', 
                                                      abbrev: '?' }
         
  team2 = m['Away'] ? build_team_rec( m['Away'] ) : { name: '?', 
                                                      abbrev: '?' }
         


  resultType  = m['ResultType']
  assert( [0, 1,2,3,8].include?(resultType), "resultType 1,2,3 expected; got #{resultType}" )

  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = if resultType == 2   ## aet, win on pens 
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}" +
             " a.e.t., #{m['HomeTeamPenaltyScore']}-#{m['AwayTeamPenaltyScore']} pen."
           elsif resultType == 3 || resultType == 8  ## aet
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']} a.e.t."
           elsif  resultType == 1  ## assume 1 - regular (90 mins+stoppage/injury time)
              "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}"
           elsif  resultType == 0
              ""
           else
              raise ArgumentError, "unknown/unexpected result type #{resultType}"
           end       
  

   matchNumber = m['MatchNumber']       # optional
   matchDay  =  m['MatchDay']           # optional 
   groupName =  desc( m['GroupName'] )  # optional
  
  ### todo/check MatchNumber  ## optional  (see 2022!!)

 # "Date": "2026-06-12T19:00:00Z",
 #   "LocalDate": "2026-06-12T15:00:00Z",
   
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

  # "HomeTeamPenaltyScore"=>3,
  # "AwayTeamPenaltyScore"=>4,


   stadium = build_stadium_rec( m['Stadium'] )

    attendance = m['Attendance']
    


##
## e.g. sample with DAY SHIFT!!! 
##          Sat 14/6/2014 22:00 -300 (01:00 UTC, +1d)
   use_date_header =   false #  true
 

   if lastStageName.nil? || lastStageName != stageName
  
         buf << "\n"  if use_date_header
      
         buf << "▪ #{stageName}\n"

        lastStageName = stageName
        lastGroupName = nil
       last_date = nil
   end

   if groupName && (lastGroupName.nil? || lastGroupName != groupName)
  
      ## note - skip extra newline on first group
      buf << "\n"    if use_date_header && lastGroupName

      buf << "▪▪ #{groupName}\n"

      lastGroupName = groupName
      last_date = nil
   end
   
   


 #  buf = String.new
 #  buf << "             #{stageName}"
 #  buf <<  ", #{groupName}"  if groupName
 #  buf << " \##{matchDay}" if matchDay
 #  buf << " (#{matchNumber})"  if matchNumber

   if use_date_header

      if last_date && (last_date.year  == localDateTime.year && 
                       last_date.month == localDateTime.month && 
                       last_date.day   == localDateTime.day)
        ## skip date header if same (local) date
      else
        ## use   20:30 UTC+1  or 20:30 UTC-3
       buf << "#{wday_local} #{date_local}\n"
      end 

     puts "  last_date #{last_date}  localDateTime #{localDateTime}"

      
      last_date = localDateTime
   
     buf <<  "  #{time_local} UTC%+d" % diff_in_hours
     buf <<  "   #{team1[:name]}  #{score}  #{team2[:name]}   "
     buf << "@ #{stadium[:name]}, #{stadium[:city_name]}"
     buf << "\n"
   else
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
  end

  

   ### get match (live) details
   live = read_json( "./worldcup/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )

   goals1 = build_goals( live['HomeTeam']['Goals'], players: players )
   goals2 = build_goals( live['AwayTeam']['Goals'], players: players )
  
  
  puts
   puts "  #{goals1.size}-#{goals2.size}  "
   pp goals1
   pp goals2


    buf_goals1 = pp_goals( goals1 )
    puts buf_goals1
    buf_goals2 = pp_goals( goals2 )
    puts buf_goals2

    if use_date_header
       goal_indent = ' ' * 17
    else
       goal_indent = ' ' * 4
    end

    if goals1.size == 0 && goals2.size == 0
        ## do nothing
    elsif goals1.size > 0 && goals2.size == 0
        buf << "#{goal_indent} (#{buf_goals1})\n"
    elsif goals1.size == 0 && goals2.size > 0
        buf << "#{goal_indent} (#{buf_goals2})\n"
    elsif (goals1.size == 1 && goals2.size == 1)  
        buf << "#{goal_indent} (#{buf_goals1}; #{buf_goals2})\n"
    else  ## both sides with goals
        buf << "#{goal_indent} (#{buf_goals1};\n"
        buf << "#{goal_indent}  #{buf_goals2})\n"
    end
    

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
      timeline = read_json( "./worldcup/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

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

    if use_date_header
    else 
        buf << "\n\n"
    end
end
   
  buf
end





seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]

## outdir = "../../openfootball/worldcup"
outdir = "./"


seasons.each do |season|

  cup = read_json( "./worldcup/#{season}_matches.json" )

   ## pp cup['Results']
   match_count = cup['Results'].size
   puts "  #{match_count} match(es) in season #{season}"


   buf =  pp_matches( cup, name: "World Cup #{season}",
                           season: season )
   puts buf
   write_text( "#{outdir}/more/#{season}_full.txt", buf )
end


puts "bye"