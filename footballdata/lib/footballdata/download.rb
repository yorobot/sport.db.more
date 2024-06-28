module Footballdata


#################
##  porcelain "api"
def self.schedule( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = LEAGUES[ league.downcase ]
  puts "  mapping league >#{league}< to >#{league_code}<"

  Metal.teams(   league_code, season.start_year )
  Metal.matches( league_code, season.start_year )
end


def self.matches( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = LEAGUES[ league.downcase ]
  puts "  mapping league >#{league}< to >#{league_code}<"
  Metal.matches( league_code, season.start_year )
end

def self.teams( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = LEAGUES[ league.downcase ]
  puts "  mapping league >#{league}< to >#{league_code}<"
  Metal.teams(   league_code, season.start_year )
end



##################
##  plumbing metal "helpers"

class Metal

  def self.get( url, auth: true )
    token = ENV['FOOTBALLDATA']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    headers = {}
    headers['X-Auth-Token'] = token    if auth && token
    headers['User-Agent']   = 'ruby'
    headers['Accept']       = '*/*'

    @@requests ||= 0

    if @@requests > 0  ## wait/sleep/delay on second request
       ## todo/fix - make configurable 
       ##  free tier (tier one) plan - 10 requests/minute ??  (one request every 6 seconds 6*10=60 secs)
       ## fix!!!!! (re)use webget delay - do NOT duplicate !!!!
       delay_in_s = 10
       puts "...sleeping #{delay_in_s} sec(s) - request count #{@@requests} ..."
       sleep( delay_in_s )  
    end

    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( url, headers: headers )

    @@requests += 1

    ## for debugging print pretty printed json first 400 chars
    puts response.json.pretty_inspect[0..400]

    exit 1  if response.status.nok?   # e.g. HTTP status code != 200

    response.json
  end



  BASE_URL = 'http://api.football-data.org/v4'


  def self.competitions_url
    "#{BASE_URL}/competitions"
  end

  def self.competitions( auth: false )
    get( competions_url, auth: auth )
  end


  ## just use matches_url - why? why not?
  def self.competition_matches_url( code, year )  "#{BASE_URL}/competitions/#{code}/matches?season=#{year}"; end
  def self.competition_teams_url( code, year )    "#{BASE_URL}/competitions/#{code}/teams?season=#{year}";   end
    
  def self.teams( code, year )   get( competition_teams_url( code, year )); end
  def self.matches( code, year ) get( competition_matches_url( code, year )); end


  def self.standings( code, year )
    get( "#{BASE_URL}/competitions/#{code}/standings?season=#{year}" )
  end


  def self.match( id )
    get( "#{BASE_URL}/matches/#{id}" )
  end
end  # class Metal
end # module Footballdata

