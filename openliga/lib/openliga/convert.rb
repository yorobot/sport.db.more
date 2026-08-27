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


  recs = []

  matches = data
  matches.each do |h|
    recs << build_match( h )
  end

  recs


  buf = pp_matches( recs )
  buf
end  # method self.convert




def self.build_score( h )
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

{"resultID"=>127243,
 "resultName"=>"Halbzeit",
 "pointsTeam1"=>0,
 "pointsTeam2"=>10,
 "resultOrderID"=>1,
 "resultTypeID"=>1,
 "resultTypeKind"=>"HalfTime",
 "resultDescription"=>"Ergebnis nach Ende der ersten Halbzeit"}

=end

   ht  = nil
   ft  = nil
   et  = nil
   pen = nil

   h.each do |result|
       ## note - assume extra time for both options nows
       ##   assert ft is nil - why? why not?

     ### resultName check - why? why not?
     ###    are legacy or not?

        ###
        ##  todo - check copa america
        ##            if extra time excluded on penalties???


        if result['resultTypeKind'] == 'HalfTime'  ## ||
          ## result['resultName'] == 'Halbzeitergebnis' ||
          ## result['resultName'] == 'Halbzeit'
            ## desc = >Ergebnis nach Ende der ersten Halbzeit
            ht = [
                result['pointsTeam1'],
                result['pointsTeam2'],
           ]
        elsif result['resultTypeKind'] == 'After90Minutes' ## ||
          ##    result['resultName'] == 'Endergebnis' ##  ||
          ##  result['resultName'] == 'nach Nachspielzeit'   ## !!!!
          ## desc => Ergebnis nach Ende der offiziellen Spielzeit
         ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
         ]
        elsif result['resultTypeKind'] == 'AfterExtraTime' ## ||
           ##   result['resultName'] == 'Verlängerung' ||
           ##   result['resultName'] == 'nach Verlängerung'
           ## desc: Ergebnis nach Verlängerung
           et = [
            result['pointsTeam1'],
            result['pointsTeam2'],
           ]
        elsif  result['resultTypeKind'] == 'AfterPenalties' ## ||
            ##   result['resultName'] == 'Elfmeterschießen'  ||
            ##   result['resultName'] == 'nach Elfmeterschießen'
           ## desc: Ergebnis nach Elfmeterschießen
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



   Score.new( ht: ht, ft: ft, et: et, pen: pen )
end


def self._clean( str )
  ## note - accept nil
  ##   turn blank strings e.g "" or "  " into nil
  ##    remove leading and trailing spaces
   return nil if str.nil?

    str = str.strip
    if str.empty?
       nil
    else
      str
    end
end


def self.build_match( h )

=begin
    "location": {
      "locationID": 34,
      "locationCity": "München",
      "locationStadium": "Allianz Arena"
    },
    "numberOfViewers": 61591
-or-
   "location": {
      "locationID": 184,
      "locationCity": "Dortmund",
      "locationStadium": "Signal-Iduna-Park"
    },
    "numberOfViewers": 300
-or-
     "location": {
      "locationID": 1091,
      "locationCity": "",
      "locationStadium": null
    },

  },

=end

     results = h['matchResults']
     score = if results.is_a?(Array)
                if results.empty?
                   nil   ## note - return nil on empty array e.g. []
                else
                   build_score( results )
                end
             else
                raise ArgumentError,  "matchResults array expected; got #{results}"
             end

     location = h['location'] || {}

     ##
     ## note - ALWAYS parse datetime for now  !!!
     ##         note ruby's time (always incl. local timezone!!)
     ##   thus split into date (class Date!!) and time(string)
     ##   e.g.   # "2024-06-17T15:00:00",
     datetime = Time.strptime( _clean(h['matchDateTime']), "%Y-%m-%dT%H:%M:%S")

     date  =   Date.new( datetime.year, datetime.month, datetime.day )
     time  =   "%02d:%02d" % [datetime.hour, datetime.min]



     Match.new(
           team1: _clean(h['team1']['teamName']),
           team2: _clean(h['team2']['teamName']),

           finished:  h['matchIsFinished'],  ## assume bool
           score:     score,

           # local time
           date: date,
           time: time,
           timezone:  _clean(h['timeZoneID']),     # e.g "W. Europe Standard Time" or often nil!!

           ## group / round e.g. "1. Runde Gruppenphase"
           round:   _clean(h['group']['groupName']),

           ground:  _clean(location['locationStadium']),
           city:    _clean(location['locationCity']),

           att:     h['numberOfViewers']     ## attendance (as integer number)
    )
end



end # module Openliga
