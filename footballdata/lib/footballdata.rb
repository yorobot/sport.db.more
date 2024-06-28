## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.


require 'cocos'   ## check if webget incl. cocos ??


module Footballdata
  class Configuration
    ## note: nothing here for now
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




