$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'

Webcache.root = '/sports/cache'

Webget.config.sleep = 1  # delay in sec(s)



## 3rd party
require 'nokogiri'


# url = 'https://www.uefa.com/nationalassociations/teams/50152--malmo/'
# Webget.page( url )


require_relative 'leagues'


BASE_URL = 'https://www.uefa.com/nationalassociations'




LEAGUES.each do |league, path|
    ## note - add trailing slash (/) to avoid (301) redirects!!!
    url = "#{BASE_URL}/#{path}/"  
    ## pp url

    if Webcache.cached?( url )
       puts "  OK #{league}"
    else
      response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)
      if response.status.nok?    ## e.g.  HTTP status code != 200
          puts "!! HTTP ERROR"
          pp response
          exit 1
      end
    end
end


puts "bye"



__END__

{"@context"=>"https://schema.org/",
 "@type"=>"SportsEvent",
 "@id"=>"https://www.uefa.com/nationalassociations/aut/domestic/league/1026/#667ea288ebeddc1e3edfd40b",
 "url"=>"https://www.uefa.com#",
 "name"=>"Tirol - Austria Wien",
 "eventAttendanceMode"=>"MixedEventAttendanceMode",
 "description"=>"Austrian Bundesliga 2024/25 : Tirol-Austria Wien",
 "eventStatus"=>"EventScheduled",
 "startDate"=>"2025-03-15T00:00:00+00:00",
 "endDate"=>"2025-03-15T03:00:00+00:00",
 "location"=>
  {"@type"=>"StadiumOrArena",
   "name"=>"Tivoli Stadion Tirol",
   "image"=>"https://img.uefa.com/imgml/stadium/w1/5db01ddbac5f73d9b86bebf8.jpg",
   "address"=>{"@type"=>"PostalAddress"}},
 "awayTeam"=>
  {"@type"=>"SportsTeam",
   "name"=>"Austria Wien",
   "logo"=>"https://img.uefa.com/imgml/TP/teams/logos/70x70/50110.png",
   "sameAs"=>"https://www.uefa.com/nationalassociations/teams/50110--austria-wien/"},
 "homeTeam"=>
  {"@type"=>"SportsTeam",
   "name"=>"Tirol",
   "logo"=>"https://img.uefa.com/imgml/TP/teams/logos/70x70/2601068.png",
   "sameAs"=>"https://www.uefa.com/nationalassociations/teams/2601068--tirol/"},
 "image"=>"https://img.uefa.com/imgml/stadium/w1/5db01ddbac5f73d9b86bebf8.jpg",
 "offers"=>{"@type"=>"Offer", "url"=>"https://row.store.uefa.com/", "priceCurrency"=>"EUR"},
 "organizer"=>{"@type"=>"Organization", "url"=>"https://www.uefa.com", "name"=>"UEFA"},
 "performer"=>
  [{"@type"=>"SportsTeam",
    "name"=>"Tirol",
    "sameAs"=>"https://www.uefa.com/nationalassociations/teams/2601068--tirol/"},
   {"@type"=>"SportsTeam",
    "name"=>"Austria Wien",
    "sameAs"=>"https://www.uefa.com/nationalassociations/teams/50110--austria-wien/"}]}

