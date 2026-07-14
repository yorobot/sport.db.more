

##
##  fix/fix/fix - use only name for lookup
##    short name may incl. duplicates in same tournament e.g.
##  duplicate team (short) name -
## {"area"=>{"id"=>2049, "name"=>"Colombia", "code"=>"COL",
##   "id"=>7119, "name"=>"CD Independiente Medellín",
##               "shortName"=>"Independiente",
##   -- and some other Independiente !!!
##    e.g  CS Independiente Rivadavia
##         CAR Independiente del Valle
##
##  will crash on copa liberatores!!
##    e.g. fbdat copa.l --cache

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

  ##
  ## note:  convert country code to "standard" fifa code
  ##        use official fifa country code
   country_name = h['area']['name']

   country = Fifa.world.find_by_name( country_name )
   if country.nil?
     raise ArgumentError, "[fifa world] no country record found for #{country_name} for: #{h.inspect}"
   end

   country_code =  country.code


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
              country:   {   name: country_name,
                             code: country_code,
                             code_bak: h['area']['code'] },

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

            ## note - assert/make sure team name is uniq
            if @by_name.has_key?(rec[:name])
              raise ArgumentError, "duplicate team name - #{h.inspect}"
            else
              @by_name[rec[:name]] = rec
            end

            if rec[:name] != rec[:short_name]
              if @by_name.has_key?(rec[:short_name])
                 raise ArgumentError, "duplicate team (short) name - #{h.inspect}"
              else
                @by_name[rec[:short_name]] = rec
              end
            end
       end
   end



   def find_by!( name: )
        rec = @by_name[ name ]
        if rec.nil?
          raise ArgumentError, "team >#{name}< not found; sorry"
        end

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

   def each( &blk) @recs.each( &blk); end



   def as_json( id: false )
      if id
        @recs
      else
        @recs.map { |rec| rec.except(:id ) }
      end
   end

   def size() @recs.size; end

end  # class Teams
