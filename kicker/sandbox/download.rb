$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'
require 'season/formats'

Webcache.root = '/sports/cache'

Webget.config.sleep = 1  # delay in sec(s)



## 3rd party
require 'nokogiri'



require_relative 'leagues'


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



SEASONS = %w[2024/25 2023/24 2022/23 2021/22 2020/21]
DATASETS = [
    ['at.1', SEASONS],
    ['at.2', SEASONS],
    ['at.3.o', SEASONS],
    ['at.cup', SEASONS],
    
    ['de.1', SEASONS],
    ['de.2', SEASONS],
    ['de.3', SEASONS],
    ['de.4.bayern', SEASONS - %w[2020/21]],
    ['de.cup', SEASONS],

    ['ch.1', SEASONS],
    ['ch.2', SEASONS],
    ['ch.cup', SEASONS],

    ['be.1', SEASONS],
    ['nl.1', SEASONS],

    ['tr.1', SEASONS],

    ['eng.1', SEASONS],
    ['es.1', SEASONS],
    ['it.1', SEASONS],
    ['fr.1', SEASONS],
  
    ['uefa.cl',   SEASONS - %w[2024/25]], 
    ['uefa.el',   SEASONS - %w[2024/25]], 
    ['uefa.conf', SEASONS - %w[2024/25 2020/21]], 
]


datasets = DATASETS
datasets.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season, j|
       download( league: league, season: season )
   end 
end


puts "bye"

