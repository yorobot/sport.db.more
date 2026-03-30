

def build_stadium( h )
     id         = h['IdStadium']
     id_country = h['IdCountry']
 ##    id_city    = h['IdCity']
  
     name      = desc( h['Name'] )
     city_name = desc( h['CityName'] )

     name, city_name = norm_stadium( name, city_name: city_name )
     
   rec = { id:         id,
 ##          id_city:    id_city, 
           name:      name,
           city_name: city_name,
           id_country: id_country, 
        }

  rec
end



class Stadiums
   def initialize
      @recs = {}
      @by_city = {}    ## track by cities
   end

   def add( matches )  ## rename to add_matches - why? why not?
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

          city_rec = @by_city[ new_rec[:city_name]] ||= []
          city_rec << new_rec
      else
          rec[:count] += 1

          ## assert attributes equal - why? why not?
         assert( new_rec[:name]        == rec[:name] &&
                  new_rec[:city_name]  == rec[:city_name] &&
                  new_rec[:id_country] == rec[:id_country],
                  "stadium records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def recs( sort: true )
      recs = @recs.values
      if sort
        recs = recs.sort do |l,r|
                res = l[:id_country] <=> r[:id_country]
                res = l[:city_name]  <=> r[:city_name]  if res == 0
                res
             end
      end
      recs
   end
   def each( sort: true, &blk ) recs( sort: sort ).each( &blk ); end
     
 
   def dump
      recs = recs( sort: true )
      pp recs
      puts "  #{recs.size} stadiums(s)"
   end

   def size() @recs.size; end

   def cities() @by_city.keys; end

end  # class Stadiums





