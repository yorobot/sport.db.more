module Openliga

def self.convert( league:, season: )

    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)


    info = (LEAGUES[ league.downcase ]||{})[ season.to_key ]
    if info.nil?
       puts "!! ERROR - no openliga info found for #{league} #{season}"
       exit 1
    end
    pp info


    data           = Webcache.read_json( Metal.matches_url( info.shortcut, info.season ))
    puts "  #{data.size} match(es)"

    ## data_teams     = Webcache.read_json( Metal.teams_url(   LEAGUES[league.downcase], season.start_year ))
    ## puts "  #{data_teams.size} team(s)"


    body = _convert( data )

###
###  auto-add header
  header =<<TXT
###
#  converted from openligadb.de json to Football.TXT
#    for source, see https://api.openligadb.de/getmatchdata/#{info.shortcut}/#{info.season}

= #{info.name}

TXT

  header + body
end



def self._convert( data )

  recs = []

  matches = data
  matches.each do |h|
      m =  build_match( h )

      ## note - if match is broken e.g. has no team1 or team2
      ##          than skip for now

      if m.team1.nil? || m.team2.nil?
         puts "!! warn - skipping match with team missing:"
         pp h
      else
        recs << m
      end
  end

  ## pp recs

  pp_matches( recs )
end  # method self._convert




end # module Openliga
