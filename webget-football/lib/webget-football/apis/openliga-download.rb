module Openliga

##################
##  plumbing metal "helpers"

class Metal

  BASE_URL = 'https://api.openligadb.de'

 
  def self.leagues
    get( "#{BASE_URL}/getavailableleagues" )
  end  
 
  def self.teams( code, year )
    get( "#{BASE_URL}/getavailableteams/#{code}/#{year}" )
  end

  def self.matches( code, year )
    get( "#{BASE_URL}/getmatchdata/#{code}/#{year}" )
  end
 
  def self.goalgetters( code, year )
    get( "#{BASE_URL}/getgoalgetters/#{code}/#{year}" )
  end

  
  def self.get( url )
    headers = {}
    headers['User-Agent']   = 'ruby'
    headers['Accept']       = '*/*'

    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( url, headers: headers )

    ## for debugging print pretty printed json first 400 chars
    puts response.json.pretty_inspect[0..400]

    exit 1  if response.status.nok?   # e.g. HTTP status code != 200
  end
end  # class Metal
end # module Footballdata

