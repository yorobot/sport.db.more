

def build_stadium( h )
     id = nil      ## h['IdStadium']

     name      =  h['name']
     city      =  h['city']
     country   =  h['country']
     street    =  h['street']

     if name.nil?
       puts "stadium without name:"
       pp h
       exit 1
     end

    ##  name, city_name = norm_stadium( name, city_name: city_name )

     if id.nil?
        ## auto-generate id
        ##  use slug of name plus id_city
        ## add city name
        id  =       name.downcase.gsub( /[^a-z0-9]/, '' )
        id += "_" + city.downcase.gsub( /[^a-z]/, '' )
     end


   rec = { id:         id,
           name:      name,
           city:      city,
           country:     country,
           count:       0,
        }

    rec[:street] = street    if street

  rec
end



class Stadiums
   def initialize
      @recs    = {}
      @by_city = {}    ## track by cities
   end


   def add( recs )
      recs.each do |rec|
        _add( build_stadium(  rec ) )
      end
   end


   def add_matches( matches )  ## rename to add_matches - why? why not?
      ## fix/fix/fix
      ## todo be done - lookup & update (match count
   end




   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          @recs[ new_rec[:id]] = new_rec

          city_rec = @by_city[ new_rec[:city]] ||= []
          city_rec << new_rec
      else
         raise ArgumentError,
            "duplicate stadium records  #{rec.pretty_inspect} == #{new_rec.pretty_inspect}"
      end
   end


   def find!( h )
       ## quick & dirty verion
        name = h['name']
        city = h['city']

        id  =       name.downcase.gsub( /[^a-z0-9]/, '' )
        id += "_" + city.downcase.gsub( /[^a-z]/, '' )

        rec =  @recs[ id ]
        raise ArgumentError, "no stadium found for #{h.inspect} using id >#{id}<"  if rec.nil?
        rec
   end



   def each( sort: true, &blk )
      recs = if sort
                @recs.values.sort do |l,r|
                   res = l[:country] <=> r[:country]
                   res = l[:city]  <=> r[:city]  if res == 0
                   res
                end
             else
                 @recs.values
             end

      recs.each( &blk )
   end


   def size() @recs.size; end

   def cities() @by_city.keys; end

end  # class Stadiums
