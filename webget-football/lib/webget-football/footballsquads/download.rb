
module Footballsquads

LEAGUES = {
   ## returns 1) country slug, 2) league slug
   'eng.1' => %w[eng engprem], 
   'eng.2' => %w[eng flcham], # Football League Championship
   'eng.3' => %w[eng flone],  # Football League One
   'eng.4' => %w[eng fltwo],  # Football League Two
   'eng.5' => %w[eng national],  # National League

   'de.1'  => %w[ger     gerbun],   # e.g. ger/2023-2024/gerbun.htm
   'de.2'  => %w[ger     gerbun2],  # e.g. 2. Bundesliga

   'es.1'  => %w[spain   spalali],   # e.g. spain/2023-2024/spalali.htm
   'es.2'  => %w[spain   spalali2], # La Liga 2

   'it.1'  => %w[italy   seriea],    # e.g. italy/2023-2024/seriea.htm
   'it.2'  => %w[italy   serieb],  # Serie B

   'fr.1'  => %w[france  fralig1],    # e.g. france/2023-2024/fralig1.htm
   'fr.2'  => %w[france  fralig2],    # Ligue 2

   'at.1'  => %w[austria ausbun],

   'sco.1'  => %w[scots scotsp],   # Premiership
   'sco.2'  => %w[scots scotsch],  # Championship
   
   'pt.1'   => %w[portugal porprim], # Primeira Liga
   'nl.1'   => %w[netherl nethere],  # Eredivisie

   'be.1'   => %w[belgium belpro],  # Pro League
   'tr.1'   => %w[turkey  tursuper], # Süper Lig
   'gr.1'   => %w[greece  gresuper], # Super League

   'ru.1'   =>  %w[russia  russiapl],  # Premier League
   'ua.1'   =>  %w[ukraine  ukrainepl],  # Premier League
   'pl.1'   =>  %w[poland  polekstr],   # Ekstraklasa

   'dk.1'   =>  %w[denmark  densuper],  # Superliga
   'ch.1'   =>  %w[switz  switzsup],   # Super League

   'cz.1'   =>  %w[czech  cze1liga],  # 1.Liga
   'hr.1'   =>  %w[croatia  cro1hnl],  # 1.HNL
   'hu.1'   =>  %w[hungary  hungnb1],  # Nemzeti Bajnokság I
   
   'no.1'   =>  %w[norway  norelite],  # Eliteserien
   'se.1'   =>  %w[sweden swedalls],  # Allsvenskan
   'ie.1'   =>  %w[ireland  ireprm],  # Premier Division
   
   'br.1'   =>  %w[brazil  bracamp], # Série A
   'ar.1'   =>  %w[arg  argprim],   # Primera División
   'cl.1'   =>  %w[chile  chileprm],  # Primera División

   'us.1'   =>  %w[usa usamls],  # Major League Soccer
   ## note - mexico - uses apetura/clausura !!!
   'mx.1.clausura' => %w[mexico mexclaus],  # Liga MX (Clausura)
   'uy.1'     => %w[uruguay uruprim],  # Primera División
   
   'au.1'   => %w[australia  ausalge],   # A-League
   'jp.1'   => %w[japan  japjlge],   # J1 League
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
