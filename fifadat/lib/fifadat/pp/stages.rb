

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
           seq:             seq,
           name:            name,
   }


   if h['StartDate'] && h['EndDate']
     ## note - start/end dates are utc (NOT local)
     start_date = parse_date_utc( h['StartDate'] )   ## expects  ...:00Z format
     end_date   = parse_date_utc( h['EndDate'] )     ## expects  ...:00Z format

     ## check if HH::MM is 00:00
     ##    only use date for now; ignore time
     ##     report warn(ing) if time present!!!
     if start_date.hour != 0 || start_date.min != 0 ||
        end_date.hour != 0   || end_date.min != 0
        ## issue warn   start/end_date with HH:MM (NOT 00:00)
        puts "!! warn:  stage start/end_date with HH:MM  (expected 00:00)"
        pp h
     end

      rec[:start_date] = start_date.strftime('%Y-%m-%d')
      rec[:end_date]   = end_date.strftime('%Y-%m-%d')
   else
       ##    maybe add to log later - why? why not?
       ## puts "!! warn:  stage witouout start/end_date"
       ## pp h
   end

   rec[:count] = 0

  rec[:level] = level   if level

  rec
end



class Stages

   def self.read( path )
       data = read_json_v2( path )
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
