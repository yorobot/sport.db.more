module Openliga



def self.results( data )
=begin   
   "matchResults": [
      {
        "resultID": 110926,
        "resultName": "Halbzeitergebnis",
        "pointsTeam1": 3,
        "pointsTeam2": 0,
        "resultOrderID": 1,
        "resultTypeID": 1,
        "resultDescription": "Ergebnis zur Halbzeitpause"
      },
      {
        "resultID": 110927,
        "resultName": "Endergebnis",
        "pointsTeam1": 5,
        "pointsTeam2": 1,
        "resultOrderID": 2,
        "resultTypeID": 2,
        "resultDescription": "Ergebnis nach Ende der offiziellen Spielzeit"
      }
=end

   ht = nil
   ft = nil
   et = nil
   pen = nil

   data.each do |result|
       ## note - assume extra time for both options nows
       ##   assert ft is nil - why? why not?
       if result['resultName'] == 'Endergebnis'  ||
          result['resultName'] == 'nach Nachspielzeit'  
         ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
         ]
        elsif result['resultName'] == 'Halbzeitergebnis'
            ht = [
                result['pointsTeam1'],
                result['pointsTeam2'],
           ]
        elsif result['resultName'] == 'nach Verlängerung'  
           et = [
            result['pointsTeam1'],
            result['pointsTeam2'],       
           ]
        elsif result['resultName'] == 'nach Elfmeterschießen'
            pen = [
                result['pointsTeam1'],
                result['pointsTeam2'],
           ]    
        else
            puts "!! ERROR - unknown result type:"
            pp result
            exit 1
        end
   end


   buf = String.new
    if pen
        buf << "#{pen[0]}-#{pen[1]} pen."
        buf << " #{et[0]}-#{et[1]} a.e.t."  if et
        if ft
          buf << " (#{ft[0]}-#{ft[1]}"  
          buf << ",#{ht[0]}-#{ht[1]}"  if ht
          buf << ")"
        end
    elsif et
        buf << "#{et[0]}-#{et[1]} a.e.t."
        if ft
            buf << " (#{ft[0]}-#{ft[1]}"  
            buf << ",#{ht[0]}-#{ht[1]}"  if ht
            buf << ")"
          end  
    elsif ft
       buf << "#{ft[0]}-#{ft[1]}"     
       buf << " (#{ht[0]}-#{ht[1]})"  if ht
    else
        buf << "-"
    end

    buf
end



def self.convert( league:, season: )

    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)
  
    data           = Webcache.read_json( Metal.matches_url( LEAGUES[league.downcase], season.start_year ))
    data_teams     = Webcache.read_json( Metal.teams_url(   LEAGUES[league.downcase], season.start_year ))
  
    puts "  #{data.size} match(es)"
    puts "  #{data_teams.size} team(s)"

  
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
