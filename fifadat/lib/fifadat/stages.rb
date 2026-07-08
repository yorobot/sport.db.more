

=begin
[{"IdStage": "286472",
    "Name": [{"Locale": "en-GB", "Description": "Final"}],
    "IdSeason": "286466",
    "SeasonName":
     [{"Locale": "en-GB", "Description": "FIFA Club World Cup Morocco 2022™"}],
    "IdCompetition": "107",
    "StageLevel": null,
    "StartDate": "2023-02-11T19:00:00Z",
    "EndDate": "2023-02-11T19:00:00Z",
    "Type": 0,
    "SequenceOrder": 6,
    "Properties": {"IdIFES": "286472"},
    "IsUpdateable": null},
=end


def build_stage( h )
   name       = desc( h['Name'] )
   seq        = h['SequenceOrder']
   level      = h['StageLevel']      ## note - is optional

   rec = { id:          h['IdStage'],   ## convert to number - why? why not?
           name:        name,
           seq:         seq,
           level:       level
        }
  rec
end


class Stages
   def initialize
      @recs = {}
   end

   def add( recs )    ## rename to collect - why? why not?
      recs.each { |h| _add( build_stage(h)) }
   end


   def _add( new_rec )
      rec =  @recs[ new_rec[:name] ]
      if rec.nil?
          @recs[ new_rec[:name]] = new_rec
      else
          raise ArgumentError, "duplicate stage entry: #{new_rec.pretty_inspect}"
      end
   end


   def find!( name )
       rec = @recs[ name ]
       raise ArgumentError, "no stage w/ name >#{name}< found; sorry"  if rec.nil?
       rec
   end


   def dump
      pp @recs.values
      puts "  #{@recs.size} stage(s)"
   end

   def size() @recs.size; end

end  # class Stages
