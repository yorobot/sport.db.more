
require_relative 'helper'



###
#  get matches and stages per season

seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]

outdir = "./tmp3"



seasons.each do |season|
  fetch_json_if( Fifa.worldcup_matches_url( season: season ), 
              "#{outdir}/worldcup/#{season}_matches.json" )
 
  fetch_json_if( Fifa.worldcup_stages_url( season: season ),  
              "#{outdir}/worldcup/misc/#{season}_stages.json" )
  
  fetch_json_if( Fifa.worldcup_squads_url( season: season ), 
               "#{outdir}/worldcup/misc/#{season}_squads.json" )
end




## download match reports (via live/football)


seasons.each do |season|
  cup = read_json( "#{outdir}/worldcup/#{season}_matches.json" )

  ## pp cup['Results']
  match_count = cup['Results'].size

  puts "  #{match_count} match(es) in season #{season}"


  cup['Results'].each_with_index do |m, i|
    idCompetition = m['IdCompetition']
    idSeason      = m['IdSeason']
    idStage       = m['IdStage']
    idMatch       = m['IdMatch']

    stageName   = desc( m['StageName'] )

    teamName1   = desc( m['Home']['TeamName'] ) 
    teamCode1   = m['Home']['Abbreviation']
      
    teamName2   = desc( m['Away']['TeamName'] )
    teamCode2   = m['Away']['Abbreviation']
                 

    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

    
     puts "[#{i+1}/#{match_count}]  #{teamName1} #{teamName2}, #{stageName}, #{localDateTime}"


    outpath = "#{outdir}/worldcup/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"   

    url = Fifa::Metal.live_url( idCompetition: idCompetition, 
                               idSeason:      idSeason,
                               idStage:       idStage, 
                               idMatch:       idMatch )
   
     fetch_json_if( url, outpath )

   ###
   ##   add timeline (only)  if score incl. penalty shoot-out
    resultType = m['ResultType']
    if resultType == 2 ## aet, win on pens
     
      ## download timeline
      outpath = "#{outdir}/worldcup/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"   
    
     url = Fifa::Metal.timeline_url( idCompetition: idCompetition, 
                              idSeason:      idSeason,
                              idStage:       idStage, 
                              idMatch:       idMatch )
   
     fetch_json_if( url, outpath )
    end
   end
end
            


puts "bye"



