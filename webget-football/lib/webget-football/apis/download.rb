module Footballdata

## todo/check: put in Downloader namespace/class - why? why not?
##   or use Metal    - no "porcelain" downloaders / machinery
class Metal
  BASE_URL = 'http://api.football-data.org/v2'


  def self.competitions_url( plan )  "#{BASE_URL}/competitions?plan=#{plan}"; end

  ## just use matches_url - why? why not?
  def self.competition_matches_url( code, year )  "#{BASE_URL}/competitions/#{code}/matches?season=#{year}"; end
  def self.competition_teams_url( code, year )    "#{BASE_URL}/competitions/#{code}/teams?season=#{year}";   end



  def self.competitions_tier_one
    get( competitions_url( 'TIER_ONE' ))
  end

  def self.competitions_tier_two
    get( competions_url( 'TIER_TWO' ))
  end

  def self.competitions_tier_three
    get( competions_url( 'TIER_THREE' ))
  end

  def self.competition( code, year )
    get( competition_matches_url( code, year ))
    get( competition_teams_url( code, year ))
  end


=begin
  def self.matches
    # note: Specified period must not exceed 10 days.

    ## try query (football) week by week - tuesday to monday!!
    ##  note: TIER_ONE does NOT include goals!!!
    code       = 'FL1'
    start_date = '2019-08-09'
    end_date   = '2019-08-16'

    get( "matches?competitions=#{code}&dateFrom=#{start_date}&dateTo=#{end_date}" )
  end
=end


  def self.get( url )
    token = ENV['FOOTBALLDATA']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    headers = {}
    headers['X-Auth-Token'] = token    if token
    headers['User-Agent']   = 'ruby'
    headers['Accept']       = '*/*'

    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( url, headers: headers )

    ## for debugging print pretty printed json first 400 chars
    puts response.json.pretty_inspect[0..400]

    exit 1  if response.status.nok?   # e.g. HTTP status code != 200
  end


end  ## class Metal
end # module Footballdata

