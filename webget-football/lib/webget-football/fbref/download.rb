
module Fbref

#################
##  porcelain "api"
def self.schedule( league:, season: )
  url = Metal.schedule_url( league: league, season: season )
  Metal.download_page( url )
end




##################
##  plumbing metal "helpers"
class Metal < ::Metal::Base

  BASE_URL = 'https://fbref.com/en'


  def self.schedule_url( league:, season: )
    season = Season( season )

    pages = LEAGUES[ league ]
    if pages.nil?
      puts "!! ERROR - no pages (urls) configured for league >#{league}<"
      exit 1
    end
    page = pages[ season.key ]
    if pages.nil?
      puts "!! ERROR - no page (url) configured for season >#{season}< for league >#{league}<; available seasons include:"
      pp pages
      exit 1
    end

    "#{BASE_URL}/#{page}"
  end


end # module Metal
end # module Fbref
