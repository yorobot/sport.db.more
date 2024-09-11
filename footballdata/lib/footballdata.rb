## 3rd party (our own)
require 'football/timezones'  # note - pulls in season/formats, cocos & tzinfo
require 'webget'           ## incl. webget, webcache, webclient, etc.


module Footballdata
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
  ##   Footballdata.configure do |config|
  ##      config.convert.out_dir = './o'
  ##   end
  def self.configure()  yield( config ); end
  def self.config()  @config ||= Configuration.new;  end
end   # module Footballdata




###
# our own code
require_relative 'footballdata/version'
require_relative 'footballdata/leagues'

require_relative 'footballdata/download'
require_relative 'footballdata/prettyprint'

require_relative 'footballdata/mods'
require_relative 'footballdata/convert'
require_relative 'footballdata/convert-score'
require_relative 'footballdata/teams'




puts FootballdataApi.banner  ## say hello
