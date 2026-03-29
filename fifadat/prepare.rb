
require_relative 'helper'



###
#  get matches and stages per season


def prepare( name:, 
             seasons:, 
             outdir: "." )

 ###
 ### rename name to slug or such
 ##   e.g.   worldcup, clubworldcup, interconticup or such expected!!!

  idComp   = Fifa._idComp_by_name!( name )

  seasons.each do |season|
    idSeason = Fifa._idSeason_by_year!( name: name, season: season )

    fetch_json_if( Fifa::Metal.matches_url( idSeason: idSeason ), 
                "#{outdir}/#{name}/#{season}_matches.json" )
 
    fetch_json_if( Fifa::Metal.stages_url( idSeason: idSeason ),  
               "#{outdir}/#{name}/misc/#{season}_stages.json" )
  
    fetch_json_if( Fifa::Metal.squads_url( idCompetition: idComp,
                                         idSeason:      idSeason ), 
               "#{outdir}/#{name}/misc/#{season}_squads.json" )
  end


  ## download match reports (via live/football)

  seasons.each do |season|
    cup = read_json( "#{outdir}/#{name}/#{season}_matches.json" )

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


      outpath = "#{outdir}/#{name}/matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"   

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
        outpath = "#{outdir}/#{name}/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"   
    
        url = Fifa::Metal.timeline_url( idCompetition: idCompetition, 
                                idSeason:      idSeason,
                                idStage:       idStage, 
                                idMatch:       idMatch )
   
       fetch_json_if( url, outpath )
      end
    end
  end
end





