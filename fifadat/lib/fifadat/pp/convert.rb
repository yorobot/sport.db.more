


def convert( slug:, season:,
                indir: '.',
                outdir: './tmp' )

    season = Season(season)

    ## fix - change data to top or ??? - why? why not?
    data = {}

    ## add slug & seasons (add name to be done!!)
    data[:meta] = { slug:      slug,
                    season:    season.to_s,
                    generated: Time.now.to_s,
                  }


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


   ## for match-by-match live reports
   report_dir = "#{indir}/#{slug}/matches/#{season.to_path}"


   recs = []
   matches.each_with_index do |m, i|

       ## add/track id too - why? why not?
       ##  rec[:id]  = m['IdMatch']


        ## add/fill-up match basic
       rec = _build_match( m )


   ### get match (live) details
   ###
   ##   check if match report exits
   ##    optional for now!!

      live = _read_report( m, report_dir: report_dir )


      ## if live.nil?
      ##   puts "warn no match report for #{_report_basename(m)}"
      ## end



   if live
       ## reuse generated output from report
        report = _build_report( live )

        goals1 = report[:goals1]
        goals2 = report[:goals2]


       if goals1.empty? && goals2.empty?
          ## skip if no goals
       else
         rec[:goals1] = goals1
         rec[:goals2] = goals2
       end


     ##  add penalties !!!
     ##  fix-fix-fix


     ## fix-fix-fix  move into _build_report!!
     ## players by team1/team2
     ##  add sent-off (red & yellow-red cards!)

     ##
     ##  change to sentoff1 and sentoff2
     ##   use report  (merge red1+yellowred1, red2+yellowred2) !!!

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
