##########
# note: use a shared base Metal class - why? why not?


module Metal
  class Base
    ##################
    #  helpers
    #

    ## todo/check:  rename to get_page or such - why? why not?
    def self.download_page( url )  ## get & record/save to cache
      response = Webget.page( url )  ## fetch (and cache) html page (via HTTP GET)

      ## note: exit on get / fetch error - do NOT continue for now - why? why not?
      exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
    end
  end # class Base
end # module Metal
