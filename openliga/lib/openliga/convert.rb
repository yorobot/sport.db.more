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

  recs


  header = "= #{info.name}\n\n"
  body = pp_matches( recs )


  header + body
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


or
!! ERROR - unknown result type:
{"resultID"=>118424,
 "resultName"=>"Nachspielzeit",
 "pointsTeam1"=>1,
 "pointsTeam2"=>2,
 "resultOrderID"=>3,
 "resultTypeID"=>3,
 "resultTypeKind"=>"Unknown",
 "resultDescription"=>"Ergebnis nach Nachspielzeit"}


  DFB Pokal 2025/2026
=end




   ht  = nil
   ft  = nil
   et  = nil
   pen = nil

   maybe_ft = nil
   maybe_et = nil

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
        ##
        ##  note if resultName is Endergebnis this might actually
        ##   be   after penalty shootout or extra time!!!
        ##    check if      "resultName": "nach 90 Minuten"
        ##    is present too!!
        elsif result['resultTypeKind'] == 'After90Minutes' ## ||
          ##    result['resultName'] == 'Endergebnis' ##  ||
          ##  result['resultName'] == 'nach Nachspielzeit'   ## !!!!
          ## desc => Ergebnis nach Ende der offiziellen Spielzeit
         ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
         ]
        ### note:
        ##   for now resultName: "nach 90 Minutes"  overwrites
        ##          first After90Minutes!!! (assuming this is kind of Endergebnis really incl. extra-time or penalty shootout)
        elsif result['resultTypeKind'] == 'Unknown' &&
              result['resultName'] == 'nach 90 Minuten'
            puts "!! warn - weirdo Unknown/nach 90 Minuten result found"
         ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
         ]
        elsif result['resultTypeKind'] == 'Unknown' &&
              result['resultName'] == 'Endergebnis'
            puts "!! warn - weirdo Unknown/Endergebnis result found"
         maybe_ft = [
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
          elsif  result['resultTypeKind'] == 'Unknown' &&
                 result['resultName'] == 'Nachspielzeit'
            puts "!! warn - weirdo Unknown/Nachspielzeit result found"
            maybe_et = [
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

## note -   DFB Pokal 2025/2026
###   requires hack
##       if     Nachspielzeit  (et) present
##      only accept if different from ft  or pen is present!!!

    if maybe_et
      if pen || maybe_et != ft
        et = maybe_et
      else
         puts "!! WARN - ignoring et (Unknown/Nachspielzeit) result in:"
         pp h
      end
    end

    if maybe_ft
       if ft.nil?
          ft = maybe_ft
       else
         puts "!! WARN - ignoring ft (Unknown/Endergebnis) result in:"
         pp h
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

=begin
@ Sportpark Ronhof | Thomas Sommer, Fürth
@ Sportforum "Sojus 31", Zwickau
@ "Allianz Arena, München
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



end # module Openliga
