module Footballdata


#################
##  porcelain "api"
def self.schedule( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = find_league!( league )
  puts "  mapping league >#{league}< to >#{league_code}<"

  Metal.teams(   league_code, season.start_year )
  Metal.matches( league_code, season.start_year )
end


def self.matches( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = find_league!( league )
  puts "  mapping league >#{league}< to >#{league_code}<"
  Metal.matches( league_code, season.start_year )
end


def self.teams( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = find_league!( league )
  puts "  mapping league >#{league}< to >#{league_code}<"
  Metal.teams(   league_code, season.start_year )
end



##################
##  plumbing metal "helpers"

class Metal

  def self.get( url,
                  auth:    true,
                  headers: {} )

    token = ENV['FOOTBALLDATA']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    request_headers = {}
    request_headers['X-Auth-Token'] = token    if auth && token
    request_headers['User-Agent']   = 'ruby'
    request_headers['Accept']       = '*/*'

    request_headers = request_headers.merge( headers )   unless headers.empty?


    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( url, headers: request_headers )

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
    get( competitions_url, auth: auth )
  end


  ## just use matches_url - why? why not?
  def self.competition_matches_url( code, year )   "#{BASE_URL}/competitions/#{code}/matches?season=#{year}";   end
  def self.competition_teams_url( code, year )     "#{BASE_URL}/competitions/#{code}/teams?season=#{year}";     end
  def self.competition_standings_url( code, year ) "#{BASE_URL}/competitions/#{code}/standings?season=#{year}"; end
  def self.competition_scorers_url( code, year )   "#{BASE_URL}/competitions/#{code}/scorers?season=#{year}"; end

  def self.matches( code, year,
                    headers: {} )
      get( competition_matches_url( code, year ),
           headers: headers )
  end

  def self.todays_matches_url( date=Date.today )
    "#{BASE_URL}/matches?"+
    "dateFrom=#{date.strftime('%Y-%m-%d')}&"+
    "dateTo=#{(date+1).strftime('%Y-%m-%d')}"
  end
  def self.todays_matches( date=Date.today )    ## use/rename to matches_today or such - why? why not?
      get( todays_matches_url( date ) )
  end


  def self.teams( code, year )    get( competition_teams_url( code, year )); end
  def self.standings( code, year ) get( competition_standings_url( code, year )); end
  def self.scorers( code, year ) get( competition_scorers_url( code, year )); end

 ################
 ## more
 def self.competition( code )
   get( "#{BASE_URL}/competitions/#{code}" )
 end

 def self.team( id )
   get( "#{BASE_URL}/teams/#{id}" )
 end

 def self.match( id )
   get( "#{BASE_URL}/matches/#{id}" )
 end

 def self.person( id )
  get( "#{BASE_URL}/persons/#{id}" )
 end

 def self.areas
     get( "#{BASE_URL}/areas" )
  end
end  # class Metal
end # module Footballdata

