
=begin

note - for address "null null null",
   is   street + city + postal_code/


 {"area"=>{"id"=>2061, "name"=>"Cyprus", "code"=>"CYP", "flag"=>nil},
    "id"=>11034,
    "name"=>"Paphos FC",
    "shortName"=>"Paphos FC",
    "tla"=>"AEP",
    "address"=>"null null null",
    "website"=>nil,
    "founded"=>nil,
    "clubColors"=>nil,
    "venue"=>"Alphamega Stadium",

 {"area"=>{"id"=>2119, "name"=>"Kazakhstan", "code"=>"KAZ", "flag"=>nil},
    "id"=>10601,
    "name"=>"FK Kairat",
    "shortName"=>"FK Kairat",
    "tla"=>"KAI",
    "address"=>"null null null",
    "website"=>nil,
    "founded"=>nil,
    "clubColors"=>nil,
    "venue"=>nil,

     {"area"=>{"id"=>2060, "name"=>"Curaçao", "code"=>"CUW", "flag"=>"https://crests.football-data.org/curacao.svg"},
    "id"=>9460,
    "name"=>"Curaçao",
    "shortName"=>"Curaçao",
    "tla"=>"CUW",
    "address"=>"null null null",
    "website"=>nil,
    "founded"=>nil,
    "clubColors"=>nil,
    "venue"=>nil,



=end



def build_team( h )

      rec = { id:         h['id'],
              name:       h['name'],
              short_name: h['shortName'],
              code:       h['tla'],
              address:    h['address'],    ###  street / city / postal_code
              founded:    h['founded'],
              ground:     h['venue'],     ### use stadium or venue ??

              ##
              ##  or use country { code:, name }
              ## change to cc (country code) - why? why not?
              country:   {  code: h['area']['code'],
                            name: h['area']['name'] },

              count:      0,   ## track - match counts
        }

     rec
end


class Teams
   def initialize
      @recs    = []
      @by_name = {}
   end


   def add( recs )
       recs.each do |h|
            rec = build_team( h )
            @recs << rec

            ## todo/fix - make sure team name is uniq!!!!
            @by_name[rec[:name]]       = rec
            @by_name[rec[:short_name]] = rec
       end
   end



   def find_by!( name: )
        rec = @by_name[ name ]
        raise ArgumentError, "team >#{name}< not found; sorry"   if rec.nil?
        rec
   end


   def add_matches( matches )  ## use/rename to add_matches - why? why not?
      matches.each do |m|

        ## note - skip teams without name (e.g. N.N.)
        if m['homeTeam']['name']
          rec = find_by!( name: m['homeTeam']['name'] )
          rec[:count] += 1
        end

        if m['awayTeam']['name']
          rec = find_by!( name: m['awayTeam']['name'] )
          rec[:count] += 1
        end
      end
   end


   def as_json( id: false )
      if id
        @recs
      else
        @recs.map { |rec| rec.except(:id ) }
      end
   end

   def size() @recs.size; end

end  # class Teams
