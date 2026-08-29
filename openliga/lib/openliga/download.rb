module Openliga


def self.download( league:, season: )

    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

    info = (LEAGUES[ league.downcase ]||{})[ season.to_key ]
    if info.nil?
       puts "!! ERROR - no openliga info found for #{league} #{season}"
       exit 1
    end
    pp info


    Metal.matches( info.shortcut, info.season )
    Metal.teams(   info.shortcut, info.season )

    true   ## return true on success (instead of latest response json data/payload)
end


##################
##  plumbing metal "helpers"

class Metal

  BASE_URL = 'https://api.openligadb.de'


  ### api call - /getavailableleagues
  def self.leagues
    get( "#{BASE_URL}/getavailableleagues" )
  end


###
#  note - MUST escape URL path  e.g.  /getmatchdata/BLÖ/2026
#                                =>   /getmatchdata/BL%C3%96/2026
#
#  Extra Tip:
#  use CGI.escape !!
#    Avoid URI.encode_www_form_component here
#    While URI.encode_www_form_component is also built into Ruby,
#    it turns spaces into plus signs (+) instead of %20.
#    For URL paths (the parts between the slashes /),
#     CGI.escape is usually the safer choice because it strictly
#      uses percent-encoding (%).


  ## api call - /getavailableteams/{code}/{year}
  def self.teams( code, year )
    get( teams_url( code, year ) )
  end
  def self.teams_url( code, year )
    "#{BASE_URL}/getavailableteams/#{CGI.escape(code)}/#{year}"
  end

  ## api call - /getmatchdata/{code}/{year}
  def self.matches( code, year )
    get( matches_url( code, year ) )
  end
  def self.matches_url( code, year )
    "#{BASE_URL}/getmatchdata/#{CGI.escape(code)}/#{year}"
  end

  ## api call - /getgoalgetters/{code}/{year}
  def self.goalgetters( code, year )
    get( "#{BASE_URL}/getgoalgetters/#{CGI.escape(code)}/#{year}" )
  end






  def self.get( url )
    headers = {}
    headers['User-Agent']   = 'ruby'
    headers['Accept']       = '*/*'

    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( url, headers: headers )

    exit 1  if response.status.nok?   # e.g. HTTP status code != 200


    data = response.json
    ## for debugging print pretty printed json first 400 chars
    puts data.pretty_inspect[0..400]


    data     ## note - return json data response (on success)
  end
end  # class Metal
end # module Footballdata
