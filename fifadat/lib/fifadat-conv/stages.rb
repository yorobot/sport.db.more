

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

   rec = {
        ##  id:          h['IdStage'],   ## convert to number - why? why not?
           seq:         seq,
           name:        name,
           count:       0,
        }

  rec[:level] = level   if level

  rec
end


class Stages

   def self.read( path )
       data = read_json( path )
       obj = new
       obj.add( data['Results'] )
       obj
   end


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


   ## add match stats
   def add_matches( matches )
        matches.each do |m|
          name = desc( m['StageName'] )
          rec  = find!( name )
          rec[:count] += 1
        end
   end


   def find!( name )
       rec = @recs[ name ]
       raise ArgumentError, "no stage w/ name >#{name}< found; sorry"  if rec.nil?
       rec
   end

   def as_json
        ## note - sort by seq

        @recs.values.sort do |l,r|
             l[:seq] <=> r[:seq]
         end
   end

   def size() @recs.size; end

end  # class Stages
