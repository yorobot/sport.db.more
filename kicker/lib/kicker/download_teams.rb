
module Kicker

def self.download_teams( league:, season: )
   season = Season( season )

   tmpl = LEAGUES[league]
   path = tmpl.sub( '{season}', season.to_path )
   url = "#{BASE_URL}/#{path}/"

   if Webcache.cached?( url )
      puts "  OK #{league} #{season}"
   else
      download_page( url )
   end
end


def self.download_page( url )
    response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)
    if response.status.nok?    ## e.g.  HTTP status code != 200
        puts "!! HTTP ERROR"
        pp response

        if response.status.code == 301
            response.headers.each do |k,v|
                puts ">#{k}<  =>  >#{v}<"
            end
        end
        exit 1
    end
end
end # module Kicker

