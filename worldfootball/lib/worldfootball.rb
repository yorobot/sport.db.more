## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

require 'cocos'

## 3rd party
require 'nokogiri'



###
# our own code
require_relative 'worldfootball/leagues'
require_relative 'worldfootball/download'
require_relative 'worldfootball/page'
require_relative 'worldfootball/page_schedule'
require_relative 'worldfootball/page_report'


require_relative 'worldfootball/mods'
require_relative 'worldfootball/vacuum'
require_relative 'worldfootball/build'
require_relative 'worldfootball/convert'
require_relative 'worldfootball/convert_reports'

require_relative 'worldfootball/jobs'




module Worldfootball

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
##   Worldfootball.configure do |config|
##      config.convert.out_dir = './o'
##   end
def self.configure() yield( config ); end
def self.config()    @config ||= Configuration.new;  end

end   # module Worldfootball




### for processing tool
##   (auto-)add sportdb/writer  (pulls in sportdb/catalogs and gitti)
require 'sportdb/writers'


module Worldfootball



## change download? to cache - true/false - why? why not?   
##  change push: to sync - true/false - why? why not?
def self.process( datasets,
                     download: false,
                     push:     false )
 

  Job.download( datasets )   if download

  ## always pull before push!! (use fast_forward)
  gh = SportDb::GitHubSync.new( datasets )
  gh.git_fast_forward_if_clean    if push


  Job.convert( datasets )


  if push
    Writer.config.out_dir = SportDb::GitHubSync.root   # e.g. "/sports/openfootball"
  else
    Writer.config.out_dir = './tmp'
  end

  Writer::Job.write( datasets,
                     source: Worldfootball.config.convert.out_dir )

  ## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
  gh.git_push_if_changes     if push
end
end  # module Worldfootball

