$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'
require 'season/formats'

Webcache.root = '/sports/cache'

Webget.config.sleep = 1  # delay in sec(s)



require_relative 'leagues'
require_relative 'datasets'


def download( league:, season: )
   season = Season( season )

   tmpl = LEAGUES[league]
   path = tmpl.sub( '{season}', season.to_path )
   url = "#{BASE_URL}/#{path}/"

   if Webcache.cached?( url )
     puts "  OK #{league} #{season}"
   else
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
end




datasets = DATASETS
datasets.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season, j|
       download( league: league, season: season )
   end 
end


puts "bye"

