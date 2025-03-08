# ApiFootball
#
# https://v3.football.api-sports.io/status
#
#

### try status call here
module ApiFootball
  def self.root
     File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))))     
  end


  def self.leagues  ## assume - try always cache first
    url = Metal.leagues_url 
    get( url )
  end

  def self.fixtures( league:, season: )
    season    = Season( season )
    league_id = find_league!( league )

    url = Metal.fixtures_url( league: league_id, 
                              season: season.start_year )
    get( url )
  end

  def self.teams( league:, season: )
    season    = Season( season )
    league_id = find_league!( league )

    url = Metal.teams_url( league: league_id, 
                           season: season.start_year )
    get( url )
  end



  def self.get( url )
    if Webcache.cached?( url )
      Webcache.read_json( url )
    else
      Metal.get( url )  ## same as Metal.leagues
    end
  end


  def self.find_league!( league )
     @leagues ||= begin
                     recs = read_csv( "#{ApiFootball.root}/config/leagues.csv" )
                     leagues = {}
                     recs.each do |rec|
                        leagues[ rec['key'] ] = rec['id'].to_i(10)
                     end
                     leagues
                  end

     key = league.downcase
     id =  @leagues[ key ]
     if id.nil?
        puts "!! ERROR - no code/mapping found for league >#{league}<"
        puts "     mappings include:"
        pp @leagues
        exit 1
     end
     id
  end





module Metal

  BASE_URL = 'https://v3.football.api-sports.io'


  def self.status
    get( "#{BASE_URL}/status" )
  end

  def self.leagues_url() "#{BASE_URL}/leagues"; end
  def self.leagues() get( leagues_url ); end

  def self.venues
    get( "#{BASE_URL}/venues?country=Austria" )
  end

  def self.teams_url( league:, season: )
    "#{BASE_URL}/teams?league=#{league}&season=#{season}"
  end

  def self.fixtures_url( league:, season: )
    "#{BASE_URL}/fixtures?league=#{league}&season=#{season}"
  end

  def self.fixtures( league:, season: )
    get( fixtures_url( league: league, 
                       season: season ) )
  end



  def self.get( url,
                  headers: {} )

    token = ENV['API-FOOTBALL_KEY']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    request_headers = {}
    request_headers['x-apisports-key'] = token    if token
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


end  # module Metal
end  # module ApiFootball

