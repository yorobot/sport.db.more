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




module Fbref
### add some more config options / settings
class Configuration
   #########
   ## nested configuration classes - use - why? why not?
   class Convert
      def out_dir()       @out_dir || './o'; end
      def out_dir=(value) @out_dir = value; end
   end

  def convert()  @convert ||= Convert.new; end
end # class Configuration

## lets you use
##   Fbref.configure do |config|
##      config.convert.out_dir = './o'
##   end
def self.configure() yield( config ); end
def self.config()    @config ||= Configuration.new;  end

end   # module Fbref



require_relative 'fbref/leagues'
require_relative 'fbref/download'
require_relative 'fbref/page'
require_relative 'fbref/page_schedule'
require_relative 'fbref/build'
require_relative 'fbref/convert'



