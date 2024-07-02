## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.


require 'cocos'   ## check if webget incl. cocos ??


require 'tzinfo'


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
require_relative 'footballdata/leagues'
require_relative 'footballdata/download'
require_relative 'footballdata/prettyprint'

require_relative 'footballdata/mods'
require_relative 'footballdata/convert'
require_relative 'footballdata/teams'


require_relative 'footballdata/generator'



### for processing tool
##   (auto-)add sportdb/writer  (pulls in sportdb/catalogs and gitti)
require 'sportdb/writers'

