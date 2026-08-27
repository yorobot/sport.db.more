module Openliga




def self.convert_csv( league:, season: )

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


  recs = []

  matches = data
  matches.each do |m|

    team1 = m['team1']['teamName']
    team2 = m['team2']['teamName']

    status_finished = m['matchIsFinished']
    score = m['score']  = results( m['matchResults'] )

    # local time
    date = m['matchDateTime']  # "2024-06-17T15:00:00",

    ## group / round e.g. "1. Runde Gruppenphase"
    round = m['group']['groupName']

=begin
    "location": {
      "locationID": 34,
      "locationCity": "München",
      "locationStadium": "Allianz Arena"
    },
    "numberOfViewers": 61591
=end

     location = m['location'] || {}

    ground = location['locationStadium']
    city   = location['locationCity']

    tz     = m['timeZoneID']  # e.g "W. Europe Standard Time"


    ## attendance
    att    = m['numberOfViewers']

    recs << [
              date,
              tz,
              team1,
              score,
              team2,
              round,
              ground,
              city,
              att,
              status_finished
            ]
  end
  recs
end  # method self.convert

end # module Openliga
