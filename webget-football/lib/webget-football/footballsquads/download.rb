
module Footballsquads


LEAGUES = {
   ## returns 1) country slug, 2) league slug
   
   ## note - eng.1 uses faprem starting 2017-2018!!
   'eng.1' => ->(season) { 
                  season_slug = season.to_path( :long )
                  if season <= Season( '2017/18' )
                     "eng/#{season_slug}/faprem.htm"
                  else
                     "eng/#{season_slug}/engprem.htm"
                  end
               },
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

   'be.1'   =>  ->(season) { 
                     season_slug = season.to_path( :long )
                     if season <= Season( '2022/23' )
                       "belgium/#{season_slug}/beleers.htm"
                     else
                       "belgium/#{season_slug}/belpro.htm"
                     end
                },

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

   'us.1'   =>  ->(season) { 
                   season_slug = season.to_s
                   if season <= Season( '2016' )
                     "usa/#{season_slug}/usamsl.htm"  # Major Soccer League (MSL)
                   else
                     "usa/#{season_slug}/usamls.htm"   # Major League Soccer (MLS)
                   end
                 },
   ## note - mexico - uses apetura/clausura !!!
   'mx.1.clausura' => %w[mexico mexclaus],  # Liga MX (Clausura)
  
   'uy.1'     => %w[uruguay uruprim],  # Primera División
   
   'au.1'   => %w[australia  ausalge],   # A-League
   'jp.1'   => %w[japan  japjlge],   # J1 League

   ## national leagues
   'euro'   =>  ->(season) { "national/eurocham/euro#{season}.htm" },
   'world'  =>  ->(season) { "national/worldcup/wc#{season}.htm" }, 
}

## pp LEAGUES


   BASE_URL = 'https://www.footballsquads.co.uk'


def self.current_squads( cache: true )
   Page::LeagueSeasons.get( "#{BASE_URL}/squads.htm", 
                            cache: cache )              
end   

def self.archive_squads( cache: true )
   # https://www.footballsquads.co.uk/archive.htm
   Page::LeagueSeasons.get( "#{BASE_URL}/archive.htm", 
                              cache: cache )              
end


## use/rename to national_team_squads - why? why not?
def self.national_squads( cache: true )
   # https://www.footballsquads.co.uk/national.htm
   Page::LeagueSeasons.get( "#{BASE_URL}/national.htm", 
                              cache: cache )              
end


def self.league_url( league:, season: )
   season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

   league_def = LEAGUES[ league.downcase ]

   if league_def.nil?
      puts "!! ERROR - no league found for >#{league}<; sorry"
      exit 1
   end

   relative_url =  if league_def.is_a?( Proc )
                     league_def.call( season ) 
                   else
                      ## assume country slug & league_slug for now
                      country_slug, league_slug = league_def
                      ## season format is 2023-2024  (use .to_path( :long/:l))
                      season_slug = season.to_path( :long )
                      # https://www.footballsquads.co.uk/austria/2023-2024/ausbun.htm  
                      "#{country_slug}/#{season_slug}/#{league_slug}.htm" 
                   end

 
   ## change to LeaguePage (from Page::League) - why? why not?
   ##           SquadPage  (from Page::Squad) etc.
   "#{BASE_URL}/#{relative_url}"
end


def self.league( league:, season:, cache: true )
   url = league_url( league: league, 
                     season: season )
   Page::League.get( url, cache: cache )              
end

end # module Footballsquads
