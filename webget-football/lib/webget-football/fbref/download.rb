
module Fbref

def self.download_schedule( league:, season: )
  url = schedule_url( league: league, season: season )
  get( url )
end

### add some "old" (back compat) aliases - keep - why? why not?
class << self
  alias_method :schedule,  :download_schedule
end


##################
#  helpers
#
#  move into Metal namespace/module - why? why not?
def self.get( url )  ## get & record/save to cache
  response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)

  ## note: exit on get / fetch error - do NOT continue for now - why? why not?
  exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
end
end  ## module Fbref

