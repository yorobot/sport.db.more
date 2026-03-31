require_relative '../helper'


###
## fetch matches today (by date)


date = Date.new( 2026, 3, 29 )

from = date-1
to   = date+1

pp from
pp to

__END__



## use +/-1 day (to get matches by local date NOT utc)
from = '2026-03-30T00:00:00Z'
to   = '2026-04-01T23:59:59Z'

fetch_json( Fifa.search_matches_url( from: from, to: to), 
                  "./upcoming/2026-03-31.json" )



puts "bye"