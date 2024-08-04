$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'

Webcache.root = '/sports/cache'

Webget.config.sleep = 1  # delay in sec(s)



## 3rd party
require 'nokogiri'



paths = Dir.glob( "./slugs.teams/**/*.json")
puts "   #{paths.size} datafile(s)"



paths.each do |path|
   basename = File.basename( path, File.extname( path ))


   data = read_json( path )
   puts "==> #{data['title']}  -  #{data['clubs'].count} club(s)..."

   ## e.g. https://www.uefa.com/nationalassociations/teams/64277--aberystwyth/


   data['clubs'].each do |rec|
     name = rec['name']
     ref  = rec['ref'] 
     team_url = "https://www.uefa.com/nationalassociations/teams/#{ref}/"

     if Webcache.cached?( team_url )
       puts "  OK #{name}"
     else

      ##  note - only numbers are / lead to valid team pages
      ##    61eplt09k35dsd1f168i7jbop--fc-pas-de-la-casa

       if ref =~ /^\d+--/
         response = Webget.page( team_url )  ## fetch (and cache) html page (via HTTP GET)
         if response.status.nok?    ## e.g.  HTTP status code != 200
             puts "!! HTTP ERROR"
             pp response
             exit 1
         end
        else
           puts "  !! WARN - no team page for ref >#{ref}<"
        end
     end
   end
end


__END__

88371--atletic-escaldes


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


    12 team(s):
[{:name=>"Salzburg", :ref=>"https://www.uefa.com/nationalassociations/teams/50030--salzburg/", :count=>22},
 {:name=>"GAK", :ref=>"https://www.uefa.com/nationalassociations/teams/51152--gak/", :count=>22},
 {:name=>"Tirol", :ref=>"https://www.uefa.com/nationalassociations/teams/2601068--tirol/", :count=>22},
 {:name=>"Altach", :ref=>"https://www.uefa.com/nationalassociations/teams/92382--altach/", :count=>22},
 {:name=>"LASK", :ref=>"https://www.uefa.com/nationalassociations/teams/63405--lask/", :count=>22},
 {:name=>"Hartberg", :ref=>"https://www.uefa.com/nationalassociations/teams/2601074--hartberg/", :count=>22},
 {:name=>"Klagenfurt", :ref=>"https://www.uefa.com/nationalassociations/teams/2602682--klagenfurt/", :count=>22},
 {:name=>"Wolfsberg", :ref=>"https://www.uefa.com/nationalassociations/teams/2603990--wolfsberg/", :count=>22},
 {:name=>"Sturm Graz", :ref=>"https://www.uefa.com/nationalassociations/teams/50111--sturm-graz/", :count=>22},
 {:name=>"Rapid Wien", :ref=>"https://www.uefa.com/nationalassociations/teams/50042--rapid-wien/", :count=>22},
 {:name=>"Austria Wien", :ref=>"https://www.uefa.com/nationalassociations/teams/50110--austria-wien/", :count=>22},
 {:name=>"BW Linz", :ref=>"https://www.uefa.com/nationalassociations/teams/2601061--bw-linz/", :count=>22}]

 12 team(s):
[{:name=>"Grasshoppers", :ref=>"https://www.uefa.com/nationalassociations/teams/50004--grasshoppers/", :count=>22},
 {:name=>"Lugano", :ref=>"https://www.uefa.com/nationalassociations/teams/8538--lugano/", :count=>22},
 {:name=>"Zürich", :ref=>"https://www.uefa.com/nationalassociations/teams/51150--zurich/", :count=>22},
 {:name=>"Yverdon", :ref=>"https://www.uefa.com/nationalassociations/teams/73931--yverdon/", :count=>22},
 {:name=>"St. Gallen", :ref=>"https://www.uefa.com/nationalassociations/teams/51151--st-gallen/", :count=>22},
 {:name=>"Winterthur", :ref=>"https://www.uefa.com/nationalassociations/teams/77919--winterthur/", :count=>22},
 {:name=>"Sion", :ref=>"https://www.uefa.com/nationalassociations/teams/52824--sion/", :count=>22},
 {:name=>"Young Boys", :ref=>"https://www.uefa.com/nationalassociations/teams/50031--young-boys/", :count=>22},
 {:name=>"Basel", :ref=>"https://www.uefa.com/nationalassociations/teams/59856--basel/", :count=>22},
 {:name=>"Lausanne-Sport", :ref=>"https://www.uefa.com/nationalassociations/teams/4251--lausanne-sport/", :count=>22},
 {:name=>"Servette", :ref=>"https://www.uefa.com/nationalassociations/teams/50008--servette/", :count=>22},
 {:name=>"Luzern", :ref=>"https://www.uefa.com/nationalassociations/teams/52808--luzern/", :count=>22}]


 16 team(s):
[{:name=>"Mechelen", :ref=>"https://www.uefa.com/nationalassociations/teams/50075--mechelen/", :count=>30},
 {:name=>"Club Brugge", :ref=>"https://www.uefa.com/nationalassociations/teams/50043--club-brugge/", :count=>30},
 {:name=>"Union SG", :ref=>"https://www.uefa.com/nationalassociations/teams/2605058--union-sg/", :count=>30},
 {:name=>"Dender", :ref=>"https://www.uefa.com/nationalassociations/teams/2600281--dender/", :count=>30},
 {:name=>"Leuven", :ref=>"https://www.uefa.com/nationalassociations/teams/2601220--leuven/", :count=>30},
 {:name=>"Beerschot Wilrijk",
  :ref=>"https://www.uefa.com/nationalassociations/teams/2610263--beerschot-wilrijk/",
  :count=>30},
 {:name=>"Sint-Truiden", :ref=>"https://www.uefa.com/nationalassociations/teams/52883--sint-truiden/", :count=>30},
 {:name=>"Anderlecht", :ref=>"https://www.uefa.com/nationalassociations/teams/50074--anderlecht/", :count=>30},
 {:name=>"Standard Liège", :ref=>"https://www.uefa.com/nationalassociations/teams/52165--standard-liege/", :count=>30},
 {:name=>"Genk", :ref=>"https://www.uefa.com/nationalassociations/teams/61582--genk/", :count=>30},
 {:name=>"Gent", :ref=>"https://www.uefa.com/nationalassociations/teams/4608--gent/", :count=>30},
 {:name=>"Kortrijk", :ref=>"https://www.uefa.com/nationalassociations/teams/68495--kortrijk/", :count=>30},
 {:name=>"Antwerp", :ref=>"https://www.uefa.com/nationalassociations/teams/50113--antwerp/", :count=>30},
 {:name=>"Charleroi", :ref=>"https://www.uefa.com/nationalassociations/teams/52886--charleroi/", :count=>30},
 {:name=>"Cercle Brugge", :ref=>"https://www.uefa.com/nationalassociations/teams/52884--cercle-brugge/", :count=>30},
 {:name=>"Westerlo", :ref=>"https://www.uefa.com/nationalassociations/teams/64124--westerlo/", :count=>30}]


 18 team(s):
[{:name=>"NAC", :ref=>"https://www.uefa.com/nationalassociations/teams/64206--nac/", :count=>34},
 {:name=>"Groningen", :ref=>"https://www.uefa.com/nationalassociations/teams/50144--groningen/", :count=>34},
 {:name=>"Willem II", :ref=>"https://www.uefa.com/nationalassociations/teams/52987--willem-ii/", :count=>34},
 {:name=>"Feyenoord", :ref=>"https://www.uefa.com/nationalassociations/teams/52749--feyenoord/", :count=>34},
 {:name=>"Twente", :ref=>"https://www.uefa.com/nationalassociations/teams/52818--twente/", :count=>34},
 {:name=>"NEC", :ref=>"https://www.uefa.com/nationalassociations/teams/52330--nec/", :count=>34},
 {:name=>"AZ Alkmaar", :ref=>"https://www.uefa.com/nationalassociations/teams/52327--az-alkmaar/", :count=>34},
 {:name=>"Almere City", :ref=>"https://www.uefa.com/nationalassociations/teams/2604167--almere-city/", :count=>34},
 {:name=>"RKC", :ref=>"https://www.uefa.com/nationalassociations/teams/52984--rkc/", :count=>34},
 {:name=>"PSV", :ref=>"https://www.uefa.com/nationalassociations/teams/50062--psv/", :count=>34},
 {:name=>"Heracles", :ref=>"https://www.uefa.com/nationalassociations/teams/89710--heracles/", :count=>34},
 {:name=>"Sparta Rotterdam",
  :ref=>"https://www.uefa.com/nationalassociations/teams/52332--sparta-rotterdam/",
  :count=>34},
 {:name=>"Zwolle", :ref=>"https://www.uefa.com/nationalassociations/teams/77910--zwolle/", :count=>34},
 {:name=>"Utrecht", :ref=>"https://www.uefa.com/nationalassociations/teams/52323--utrecht/", :count=>34},
 {:name=>"Fortuna Sittard",
  :ref=>"https://www.uefa.com/nationalassociations/teams/52325--fortuna-sittard/",
  :count=>34},
 {:name=>"Go Ahead Eagles",
  :ref=>"https://www.uefa.com/nationalassociations/teams/64207--go-ahead-eagles/",
  :count=>34},
 {:name=>"Heerenveen", :ref=>"https://www.uefa.com/nationalassociations/teams/59862--heerenveen/", :count=>34},
 {:name=>"Ajax", :ref=>"https://www.uefa.com/nationalassociations/teams/50143--ajax/", :count=>34}]


 16 team(s):
[{:name=>"Malmö", :ref=>"https://www.uefa.com/nationalassociations/teams/50152--malmo/", :count=>30},
 {:name=>"Norrköping", :ref=>"https://www.uefa.com/nationalassociations/teams/50099--norrkoping/", :count=>30},
 {:name=>"Kalmar", :ref=>"https://www.uefa.com/nationalassociations/teams/54187--kalmar/", :count=>30},
 {:name=>"Hammarby", :ref=>"https://www.uefa.com/nationalassociations/teams/52343--hammarby/", :count=>30},
 {:name=>"Brommapojkarna",
  :ref=>"https://www.uefa.com/nationalassociations/teams/2600094--brommapojkarna/",
  :count=>30},
 {:name=>"GAIS", :ref=>"https://www.uefa.com/nationalassociations/teams/91862--gais/", :count=>30},
 {:name=>"Mjällby", :ref=>"https://www.uefa.com/nationalassociations/teams/74233--mjallby/", :count=>30},
 {:name=>"Häcken", :ref=>"https://www.uefa.com/nationalassociations/teams/69621--hacken/", :count=>30},
 {:name=>"Djurgården", :ref=>"https://www.uefa.com/nationalassociations/teams/52809--djurgarden/", :count=>30},
 {:name=>"Göteborg", :ref=>"https://www.uefa.com/nationalassociations/teams/50066--goteborg/", :count=>30},
 {:name=>"Halmstad", :ref=>"https://www.uefa.com/nationalassociations/teams/53048--halmstad/", :count=>30},
 {:name=>"Sirius", :ref=>"https://www.uefa.com/nationalassociations/teams/2603704--sirius/", :count=>30},
 {:name=>"Västerås", :ref=>"https://www.uefa.com/nationalassociations/teams/64260--vasteras/", :count=>30},
 {:name=>"AIK", :ref=>"https://www.uefa.com/nationalassociations/teams/52341--aik/", :count=>30},
 {:name=>"Värnamo", :ref=>"https://www.uefa.com/nationalassociations/teams/2603706--varnamo/", :count=>30},
 {:name=>"Elfsborg", :ref=>"https://www.uefa.com/nationalassociations/teams/52344--elfsborg/", :count=>30}]


 <h2 slot="primary">
          <div class="pk-d--flex pk-align-items--center">
          <pk-badge alt="Malm&#xF6; FF"
                badge-title="Malm&#xF6; FF"
                src="https://img.uefa.com/imgml/TP/teams/logos/70x70/50152.png"
                fallback-image="club-generic-badge"
                size="70"
                class="team-logo pk-d-sm--none"></pk-badge>
        </div>

      <span itemprop="name" class="team-name pk-d--none pk-d-sm--block">Malm&#xF6; FF</span>
      <span class="team-name pk-d-sm--none">Malm&#xF6;</span>
    </h2>
    <div slot="secondary" class="pk-d--flex pk-flex--column">
          <pk-identifier class="team-country-wrap pk-py--0">
            <pk-badge alt="SWE"
                      badge-title="SWE"
                      fallback-image="club-generic-badge"
                      src="https://img.uefa.com/imgml/flags/70x70/SWE.png"
                      slot="prefix" class="pk-mr--xs2 country-flag"></pk-badge>
            <span slot="primary" class="pk-d--flex pk-align-items--center team-country-name">SWE</span>
          </pk-identifier>
    </div>