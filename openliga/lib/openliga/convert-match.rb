module Openliga



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

=begin
@ Sportpark Ronhof | Thomas Sommer, Fürth
@ Sportforum "Sojus 31", Zwickau
@ "Allianz Arena, München

  or add into protected_name token - why? why not?
e.g.
@ ‹Sportpark Ronhof | Thomas Sommer›, Fürth
@ ‹Sportforum "Sojus 31"›, Zwickau
@ ‹"Allianz Arena›, München       -- really better FIX typo
=end

def self._clean_geo( str )
   return nil if str.nil?

   str = str.gsub( %r{["|]}, '' )       ## remove "|
   str = str.gsub( %r{[ ]{2,}}, ' ' )   ## squish spaces (maybe move "upstream" to clean)

   _clean( str )
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

           ground:  _clean_geo(location['locationStadium']),
           city:    _clean_geo(location['locationCity']),

           att:     h['numberOfViewers']     ## attendance (as integer number)
    )
end


end  ## module Openliga
