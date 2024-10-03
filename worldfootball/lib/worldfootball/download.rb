

module Worldfootball

#################
##  porcelain "api"
def self.schedule( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  pages = find_league_pages!( league: league, season: season )
  pages.each do |slug, _|
    Metal.download_schedule( slug )
  end # each page
end


def self.reports( league:, season:, cache: true ) ## todo/check: rename to reports_for_schedule or such - why? why not?
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  pages = find_league_pages!( league: league, season: season )
  pages.each do |slug, _|
    Metal.download_reports_for_schedule( slug, cache: cache )
  end # each page
end




##################
##  plumbing metal "helpers"

## todo/check: put in Downloader namespace/class - why? why not?
##   or use Metal    - no "porcelain" downloaders / machinery
class Metal

  BASE_URL = 'https://www.weltfussball.de'


  def self.schedule_url( slug )  "#{BASE_URL}/alle_spiele/#{slug}/";  end
  def self.report_url( slug )    "#{BASE_URL}/spielbericht/#{slug}/"; end
  def self.team_url( slug )   "#{BASE_URL}/teams/#{slug}/"; end

##
## note:
##   do NOT allow redirects for now - report error!!!
##   does NOT return 404 page not found errors; always redirects (301) to home page
##    on missing pages:
##      301 Moved Permanently location=https://www.weltfussball.de/
##      301 Moved Permanently location=https://www.weltfussball.de/


def self.download_team( slug, cache: true )
  url  = team_url( slug )

  ## check check first
  if cache && Webcache.cached?( url )
     puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
  else
    download_page( url )
  end
end



# url = "https://www.weltfussball.de/alle_spiele/eng-league-one-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/eng-league-two-#{season}/"
#        https://www.weltfussball.de/alle_spiele/eng-national-league-2019-2020/
#        https://www.weltfussball.de/alle_spiele/eng-fa-cup-2018-2019/
#        https://www.weltfussball.de/alle_spiele/eng-league-cup-2019-2020/

#        https://www.weltfussball.de/alle_spiele/fra-ligue-2-2019-2020/
#        https://www.weltfussball.de/alle_spiele/ita-serie-b-2019-2020/
#        https://www.weltfussball.de/alle_spiele/rus-premier-liga-2019-2020/
#        https://www.weltfussball.de/alle_spiele/rus-1-division-2019-2020/
#        https://www.weltfussball.de/alle_spiele/tur-sueperlig-2019-2020/
#        https://www.weltfussball.de/alle_spiele/tur-1-lig-2019-2020/

  def self.download_schedule( slug )
    url = schedule_url( slug )
    download_page( url )
  end

  def self.download_report( slug, cache: true )
    url  = report_url( slug )

    ## check check first
    if cache && Webcache.cached?( url )
       puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
    else
      download_page( url )
    end
  end


  def self.download_reports_for_schedule( slug, cache: true ) ## todo/check: rename to reports_for_schedule or such - why? why not?

    page = Page::Schedule.from_cache( slug )
    matches = page.matches

    puts "matches - #{matches.size} rows:"
    pp matches[0]

    puts "#{page.generated_in_days_ago}  - #{page.generated}"

    ## todo/fix: restore sleep to old value at the end!!!!
    ## Webget.config.sleep = 8    ## fetch 7-8 pages/min

    matches.each_with_index do |match,i|
       est = (Webget.config.sleep * (matches.size-(i+1)))/60.0   # estimated time left

       puts "fetching #{i+1}/#{matches.size} (#{est} min(s)) - #{match[:round]} | #{match[:team1]} v #{match[:team2]}..."
       report_ref = match[:report_ref ]
       if report_ref
         download_report( report_ref, cache: cache )
       else
         puts "!! WARN: report ref missing for match:"
         pp match
       end
    end
  end


  def self.download_page( url )  ## get & record/save to cache
    response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)

    ## note: exit on get / fetch error - do NOT continue for now - why? why not?
    exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
  end

end # class Metal
end # module Worldfootball


