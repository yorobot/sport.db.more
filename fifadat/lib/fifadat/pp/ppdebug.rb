
def pp_debug(  season:, slug:,
               indir: )

   season = Season(season)

   stats = {
            ## match stats
              'MatchStatus' => Hash.new(0),
              'ResultType'  => Hash.new(0),
              'Leg'         => Hash.new(0),
              'IsHomeMatch' => Hash.new(0),
              'MatchDay'    => Hash.new(0),
              'MatchNumber' => Hash.new(0),
              'Attendance'  => Hash.new(0),
              'Weather'     => Hash.new(0),

            ## team stats
              'TeamType'     => Hash.new(0),
              'AgeType'      =>  Hash.new(0),
              'FootballType' => Hash.new(0),
            }


   data =  read_json( "#{indir}/#{slug}/#{season.to_path}_matches.json" )
   matches = data['Results']  ## only use results (match) array

   ## pp data
   puts "  #{matches.size} match(es) in season #{season}"


   buf = String.new

matches.each_with_index do |m, i|
  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

   stageName   = desc( m['StageName'] )
   groupName   = desc( m['GroupName'] )  # optional
   matchDay    = m['MatchDay']           # optional

   matchNumber = m['MatchNumber']        # optional


   buf << "==> [#{i+1}/#{matches.size}]"
   buf << "  #{m['MatchStatus']}  "
   buf << "  #{stageName}"
   buf <<  ", #{groupName}"  if groupName
   buf << " \##{matchDay}" if matchDay
   buf << " (#{matchNumber})"  if matchNumber



  team1 = m['Home'] ? { name:    desc( m['Home']['TeamName'] ),
                        abbrev:  m['Home']['Abbreviation'],
                        country: m['Home']['IdCountry'],
                      } : { name: '?', abbrev: '?', country: '?' }

  team2 = m['Away'] ? { name:    desc( m['Away']['TeamName'] ),
                        abbrev:  m['Away']['Abbreviation'],
                        country: m['Away']['IdCountry'],
                      }  : { name: '?', abbrev: '?', country: '?' }


  buf <<  "   #{team1[:name]} | #{team1[:abbrev]} (#{team1[:country]})"
  buf <<  " v "
  buf <<  "#{team2[:name]} | #{team2[:abbrev]} (#{team2[:country]})  "
  buf <<   _fmt_score(m)
  buf <<  " (#{m['ResultType']})"


   buf << "\n"


   ##
   ## check usage
   stats[ 'MatchStatus' ][m['MatchStatus']] +=1
   stats[ 'ResultType'][m['ResultType']] +=1

   stats[ 'Leg'][m['Leg']] +=1
   stats[ 'IsHomeMatch'][m['IsHomeMatch']] +=1

   stats[ 'MatchDay'][!m['MatchDay'].nil?] +=1
   stats[ 'MatchNumber'][!m['MatchNumber'].nil?] +=1
   stats[ 'Attendance'][!m['MatchDay'].nil?] +=1
   stats[ 'Weather'][!m['Weather'].nil?] +=1


    if m['Home']
      stats[ 'TeamType'][m['Home']['TeamType']] +=1
      stats[ 'AgeType'][m['Home']['AgeType']] +=1
      stats[ 'FootballType'][m['Home']['FootballType']] +=1
    end
    if m['Away']
      stats[ 'TeamType'][m['Away']['TeamType']] +=1
      stats[ 'AgeType'][m['Away']['AgeType']] +=1
      stats[ 'FootballType'][m['Away']['FootballType']] +=1
    end
end



   ## note - move stats up-front into header
   header = String.new
   header << "stats:\n"
   header <<  stats.pretty_inspect
   header << "\n"


   header + buf
end