module Openliga



def self.build_score( h )
   ht  = nil
   ft  = nil
   et  = nil
   pen = nil

   maybe_ft = nil
   maybe_et = nil

   h.each do |result|
       ## note - assume extra time for both options now
       ##   assert ft is nil - why? why not?

     ### resultName check - why? why not?
     ###    are legacy or not?

        ###
        ##  todo - check copa america
        ##            if extra time excluded on penalties???

        case result['resultTypeKind']
        when  'HalfTime'
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
        when 'After90Minutes'
          ##    result['resultName'] == 'Endergebnis' ##  ||
          ##  result['resultName'] == 'nach Nachspielzeit'   ## !!!!
          ## desc => Ergebnis nach Ende der offiziellen Spielzeit
         ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
         ]
        when 'AfterExtraTime'
           ##   result['resultName'] == 'Verlängerung' ||
           ##   result['resultName'] == 'nach Verlängerung'
           ## desc: Ergebnis nach Verlängerung
           et = [
            result['pointsTeam1'],
            result['pointsTeam2'],
           ]
        when 'AfterPenalties'
            ##   result['resultName'] == 'Elfmeterschießen'  ||
            ##   result['resultName'] == 'nach Elfmeterschießen'
           ## desc: Ergebnis nach Elfmeterschießen
            pen = [
                result['pointsTeam1'],
                result['pointsTeam2'],
           ]
        when 'Unknown'
          ### note:
          ##   for now resultName: "nach 90 Minutes"  overwrites
          ##          first After90Minutes!!! (assuming this is kind of Endergebnis really incl. extra-time or penalty shootout)
          if result['resultName'] == 'nach 90 Minuten'
            puts "!! warn - weirdo Unknown/nach 90 Minuten result found"
            ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
            ]
          elsif result['resultName'] == 'Endergebnis'
            puts "!! warn - weirdo Unknown/Endergebnis result found"
            maybe_ft = [
              result['pointsTeam1'],
              result['pointsTeam2'],
            ]
          elsif result['resultName'] == 'Nachspielzeit'
            puts "!! warn - weirdo Unknown/Nachspielzeit result found"
            maybe_et = [
              result['pointsTeam1'],
              result['pointsTeam2'],
            ]
          else
            puts "!! ERROR - unknown <Unknown> result type:"
            pp result
            exit 1
          end
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


end  ## module Openliga



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
