require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.


=begin
Webcache.root =  if File.exist?( '/sports/cache' )
                     puts "  setting web cache to >/sports/cache<"
                     '/sports/cache'
                 else
                     './cache'
                 end
=end




# ApiFootball
#
# https://v3.football.api-sports.io/status
#
#

### try status call here

module ApiFootball
module Metal

  BASE_URL = 'https://v3.football.api-sports.io'


  def self.status
    get( "#{BASE_URL}/status" )
  end

  def self.leagues
    get( "#{BASE_URL}/leagues" )
  end

  def self.venues
    get( "#{BASE_URL}/venues?country=Austria" )
  end

  def self.fixtures( league:, season: )
    get( "#{BASE_URL}/fixtures?league=#{league}&season=#{season}" )
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


