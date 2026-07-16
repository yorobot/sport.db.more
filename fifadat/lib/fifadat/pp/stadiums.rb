

def build_stadium( h )
   if h
     id         = h['IdStadium']
     id_country = h['IdCountry']
 ##    id_city    = h['IdCity']

     name      = desc( h['Name'] )
     city_name = desc( h['CityName'] )


     if name.nil?
       puts "stadium without name:"
       pp h
       exit 1
     end

     ## name, city_name = norm_stadium( name, city_name: city_name )


     if id.nil?
        ## auto-generate id
        ##  use slug of name plus id_city
        ## add city name
        ##  fix- add   0-9 & dash(-) to name too - why? why not?
        id  =       name.downcase.gsub( /[^a-z]/, '' )
        id += "_" + city_name.downcase.gsub( /[^a-z]/, '' )
     end


   rec = { id:        id,
           name:      name,
           city:      city_name
         }

   rec[:street] = h['Street']   if h['Street']

   rec[:country] = id_country    ### fix - change to cc/country code - why? why not?

   rec
  else    ## assume nil - dummy record
     rec =  {
         id:      '<nil>',
         name:    '?',
         city:    '?',   ## use nil - why? why not?
         country: '?'    ## use nil - why? why not?
            }
      rec
   end
end




class Stadiums
   def initialize
      @recs = {}
   end

   def add_matches( matches )  ## rename to add_matches - why? why not?
     matches.each_with_index do |m|
       stadium = build_stadium( m['Stadium'] )
       _add( stadium )
     end
   end



   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec
      else
          rec[:count] += 1

          ## assert attributes equal - why? why not?
         assert( new_rec[:name]     == rec[:name] &&
                  new_rec[:city]    == rec[:city] &&
                  new_rec[:country] == rec[:country],
                  "stadium records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def as_json( id: false )
      if id
        @recs.values
      else
        @recs.values.map { |rec| rec.except(:id ) }
      end
   end


   def size() @recs.size; end

end  # class Stadiums
