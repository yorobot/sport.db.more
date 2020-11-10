

module Worldfootball




## todo/check: put in Downloader namespace/class - why? why not?
##   or use Metal    - no "porcelain" downloaders / machinery
class Metal

  BASE_URL = 'https://www.weltfussball.de'


  def self.schedule_url( slug )  "#{BASE_URL}/alle_spiele/#{slug}/";  end
  def self.report_url( slug )    "#{BASE_URL}/spielbericht/#{slug}/"; end


  def self.download_schedule( slug )
    url = schedule_url( slug )
    get( url )
  end

  def self.download_report( slug, cache: true )
    url  = report_url( slug )

    ## check check first
    if cache && Webcache.cached?( url )
       puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
    else
      get( url )
    end
  end





  def self.download_schedule_reports( slug, cache: true ) ## todo/check: rename to reports_for_schedule or such - why? why not?

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


  ### add some "old" (back compat) aliases - keep - why? why not?
  class << self
    alias_method :schedule,          :download_schedule
    alias_method :report,            :download_report
    alias_method :schedule_reports,  :download_schedule_reports
  end


  ##################
  #  helpers
  def self.get( url )  ## get & record/save to cache

    response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)

    ## note: exit on get / fetch error - do NOT continue for now - why? why not?
    exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
  end


end # class Metal
end # module Worldfootball


