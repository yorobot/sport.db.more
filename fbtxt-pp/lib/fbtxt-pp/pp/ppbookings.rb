
##
## check - use ppcards.rb - why? why not?


## use _pp_cards - why? why not?
def _pp_bookings( bookings )

##
## sort
##
   bookings = bookings.sort do |l,r|
                            l_min,l_offset = _parse_minute( l['minute'])
                            r_min,r_offset = _parse_minute( r['minute'])

                            res = l_min <=> r_min
                            res = (l_offset||0) <=> (r_offset||0)   if res == 0
                            res
                       end

    bookings.map do |b|
      ## todo - fix-fix-fix - build player struct/obj
      name   =  b['name']
      minute =  b['minute']
      "#{name} #{minute}'"
    end.join( ', ')
end


## use pp_cards - why? why not?
def pp_bookings(    yellow, yellowred, red,
                  players:, opts: )

   buf = String.new

   unless yellow.empty?
      buf << "    Yellow: "
      buf <<  _pp_bookings( yellow )
      buf << "\n"
   end

   unless yellowred.empty?
      buf << "    Yellow-Red: "
      buf << _pp_bookings( yellowred )
      buf << "\n"
   end

   unless red.empty?
      buf << "    Red:    "
      buf << _pp_bookings( red )
      buf << "\n"
   end

   buf
end