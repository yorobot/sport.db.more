module Openliga



def self.build_match( h )


     score = if h['matchResults'].is_a?(Array)
                if h['matchResults'].empty?
                   nil   ## note - return nil on empty array e.g. []
                else
                   build_score( h['matchResults'] )
                end
             else
                raise ArgumentError,  "matchResults array expected; got #{h['matchResults']}"
             end


     goals = if h['goals'].is_a?(Array)
                if h['goals'].empty?
                   nil   ## note - return nil on empty array e.g. []
                else
                   build_goals( h['goals'], team1: h['team1']['teamId'],
                                            team2: h['team2']['teamId'] )
                end
             else
                raise ArgumentError,  "goals array expected; got #{h['goals']}"
             end


     ##
     ## note - ALWAYS parse datetime for now  !!!
     ##         note ruby's time (always incl. local timezone!!)
     ##   thus split into date (class Date!!) and time(string)
     ##   e.g.   # "2024-06-17T15:00:00",
     datetime = Time.strptime( _clean(h['matchDateTime']), "%Y-%m-%dT%H:%M:%S")

     date  =   Date.new( datetime.year, datetime.month, datetime.day )
     time  =   "%02d:%02d" % [datetime.hour, datetime.min]


     location = h['location'] || {}


     Match.new(
           team1: _clean(h['team1']['teamName']),
           team2: _clean(h['team2']['teamName']),

           finished:  h['matchIsFinished'],  ## assume bool
           score:     score,
           goals:     goals,

           # local time
           date: date,
           time: time,
           timezone:  _clean(h['timeZoneID']),     # e.g "W. Europe Standard Time" or often nil!!

           ## group / round e.g. "1. Runde Gruppenphase"
           round:   _clean(h['group']['groupName']),

           ground:  _clean_geo(location['locationStadium']),
           city:    _clean_geo(location['locationCity']),

           att:     h['numberOfViewers']     ## attendance (as integer number)
    )
end


end  ## module Openliga



__END__


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
