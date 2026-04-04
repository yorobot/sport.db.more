
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches_min(  season:,
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
   buf << pp_stats( cup, opt_teams: opt_teams,
                         opt_stadiums: false )
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
                                                               
   dateTime       = parse_date( m['Date'] )    ## utc   
   localDateTime  = parse_date( m['LocalDate'] )

     assert( dateTime.sec == 0 && localDateTime.sec == 0, 
                "sec 00 expected" )
 

  resultType  = m['ResultType']
  assert( [0, 1,2,3,8].include?(resultType), "resultType 1,2,3 expected; got #{resultType}" )

  score = _fmt_score( m )
  
   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchNumber = m['MatchNumber']       # optional
   matchDay  =  m['MatchDay']           # optional 
  
   
  stageName, groupName = norm_stage( stageName, groupName,
                             team1: team1,
                             team2: team2,
                             date: localDateTime.strftime( '%Y-%m-%d') )


    

   if lastStageName.nil? || lastStageName != stageName
  
         buf << "\n" 
      
         buf << "▪ #{stageName}\n"

        lastStageName = stageName
        lastGroupName = nil
   end

   if groupName && (lastGroupName.nil? || lastGroupName != groupName)
  
      ## note - skip extra newline on first group
      buf << "\n"    if lastGroupName

      buf << "▪▪ #{groupName}\n"

      lastGroupName = groupName
   end
   

   
     if opt_country
        line = "#{team1[:name]} (#{team1[:country]})"
        line <<  " v "
        line <<  "#{team2[:name]} (#{team2[:country]})"
        
        buf <<  "  %-40s  " % line
        buf <<  "#{score}"
     else
        line = "#{team1[:name]} v #{team2[:name]}"
        
        buf <<  "  %-30s  " % line
        buf <<  "#{score}"
     end
    
      buf << "\n"  
  end
   
  buf
end

