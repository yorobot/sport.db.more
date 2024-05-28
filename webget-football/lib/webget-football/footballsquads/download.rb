
module Footballsquads

LEAGUES = {
   ## returns 1) country slug, 2) league slug
   'eng.1' => ['eng',     'engprem' ], 
   'de.1'  => ['ger',     'gerbun'  ],   # e.g. ger/2023-2024/gerbun.htm
   'es.1'  => ['spain',   'spalali' ],   # e.g. spain/2023-2024/spalali.htm
   'it.1'  => ['italy',   'seriea' ],    # e.g. italy/2023-2024/seriea.htm
   'fr.1'  => ['france',  'fralig1'],    # e.g. france/2023-2024/fralig1.htm

   'at.1'  => ['austria', 'ausbun' ],
}



def self.league( league:, season:, cache: true )
   season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)
   ## season format is 2023-2024  (use .to_path( :long/:l))
   season_slug = season.to_path( :long )

   country_slug, league_slug = LEAGUES[ league.downcase ]
   unless country_slug && league_slug
      puts "!! ERROR - no league found for >#{league}<"
      exit 1
   end

   ## change to LeaguePage (from Page::League) - why? why not?
   ##           SquadPage  (from Page::Squad) etc.
   Page::League.get(
                    country: country_slug,
                    league:  league_slug,
                    season:  season_slug,
                    cache:   cache
                 )              
end


##################
##  plumbing metal "helpers"

## todo/check: put in Downloader namespace/class - why? why not?
##   or use Metal    - no "porcelain" downloaders / machinery
class Metal < ::Metal::Base

    BASE_URL = 'https://www.footballsquads.co.uk'

    
   def self.league_url( country:, league:, season: )
      ## https://www.footballsquads.co.uk/austria/2023-2024/ausbun.htm  

      "#{BASE_URL}/#{country}/#{season}/#{league}.htm" 
   end 

   def self.league( country:, league:, season:,
                             cache: true )
      url = league_url( country: country, league: league, season: season )

      ## check check first
      if cache && Webcache.cached?( url )
        puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
      else
        download_page( url )
      end
   end


   def self.squad_url( country:, league:, season:,
                       team: )
      ## https://www.footballsquads.co.uk/austria/2023-2024/bundes/austvien.htm  
      "#{BASE_URL}/#{country}/#{season}/#{league}/#{team}.htm"
   end

   def self.squad( country:, league:, season:,
                            team:,
                            cache: true )
     url = squad_url( country: country, league: league, season: season,
                      team: team ) 

     ## check check first
     if cache && Webcache.cached?( url )
        puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
     else
        download_page( url )
     end
   end
end # class Metal
end # module Footballsquads
