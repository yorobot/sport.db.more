###
#  get matches and stages per season
##
##  download / prepare (fill-up local) cache


def prepare( name:,
             season:,
             outdir: '.' )

 ###
 ### rename name to slug or such
 ##   e.g.   worldcup, clubworldcup, interconticup or such expected!!!

    season = Season(season)

    idComp   = Fifa._idComp_by!( name: name )

    idSeason = Fifa._idSeason_by!( name: name, season: season )

    fetch_json_if( Fifa::Metal.matches_url( idSeason: idSeason ),
                "#{outdir}/#{name}/#{season.to_path}_matches.json" )

    fetch_json_if( Fifa::Metal.stages_url( idSeason: idSeason ),
               "#{outdir}/#{name}/misc/#{season.to_path}_stages.json" )

    fetch_json_if( Fifa::Metal.squads_url( idCompetition: idComp,
                                         idSeason:      idSeason ),
               "#{outdir}/#{name}/misc/#{season.to_path}_squads.json" )

end



def prepare_reports( name:,
                     season:,
                     outdir: '.' )

  ## download match reports (via live/football)
    season = Season(season)

     data = read_json( "#{outdir}/#{name}/#{season.to_path}_matches.json" )
     matches = data['Results']


    puts "  #{matches.size} match(es) in season #{season}"


    matches.each_with_index do |m, i|
      idCompetition = m['IdCompetition']
      idSeason      = m['IdSeason']
      idStage       = m['IdStage']
      idMatch       = m['IdMatch']

      stageName   = desc( m['StageName'] )


      ## note - skip if teams not yet know
      ##  e.g. Home & Away is null
      ##  e.g.    "Home": null,
      ##          "Away": null,

      ## todo/fix - check for MatchStatus and ResultType too
      ##  e.g. MatchStatus = 1  -- future
      ##       ResultType  = 0  -- not played yet

      if m['Home'].nil? || m['Away'].nil?
         puts "[#{i+1}/#{matches.size}]  ??  ??, #{stageName}  (SKIPPED - TO BE DONE)"
         next
      end


      dateTime       = parse_date( m['Date'] )    ## utc
      localDateTime  = parse_date( m['LocalDate'] )


      ## pp m['Home']
      teamName1   = desc( m['Home']['TeamName'] )
      teamCode1   = m['Home']['Abbreviation']

      ## pp m['Away']
      teamName2   = desc( m['Away']['TeamName'] )
      teamCode2   = m['Away']['Abbreviation']


      puts "[#{i+1}/#{matches.size}]  #{teamName1} #{teamName2}, #{stageName}, #{localDateTime}"


      outpath = "#{outdir}/#{name}/matches/#{season.to_path}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"

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
        outpath = "#{outdir}/#{name}/timelines/#{season.to_path}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"

        url = Fifa::Metal.timeline_url( idCompetition: idCompetition,
                                idSeason:      idSeason,
                                idStage:       idStage,
                                idMatch:       idMatch )

       fetch_json_if( url, outpath )
    end
  end
end
