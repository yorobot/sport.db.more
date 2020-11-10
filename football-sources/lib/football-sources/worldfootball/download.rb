

module Worldfootball

##
## note/fix!!!!
##   do NOT allow redirects for now - report error!!!
##   does NOT return 404 page not found errors; always redirects (301) to home page
##    on missing pages:
##      301 Moved Permanently location=https://www.weltfussball.de/
##      301 Moved Permanently location=https://www.weltfussball.de/




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



  def self.schedule( league:, season: )
    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

    league  = find_league( league )

    pages =  league.pages( season: season )

    ## if single (simple) page setup - wrap in array
    pages = pages.is_a?(Array) ? pages : [pages]
    pages.each do |page_meta|
      Metal.schedule( page_meta[:slug] )
    end # each page
  end


  def self.schedule_reports( league:, season:, cache: true ) ## todo/check: rename to reports_for_schedule or such - why? why not?
    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

    league  = find_league( league )

    pages =  league.pages( season: season )

    ## if single (simple) page setup - wrap in array
    pages = pages.is_a?(Array) ? pages : [pages]
    pages.each do |page_meta|
      Metal.schedule_reports( page_meta[:slug], cache: cache )
    end # each page
  end


end # module Worldfootball
