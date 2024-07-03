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
require_relative 'footballdata/version'
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



module Footballdata 

class Job     ## todo/check: use a module (NOT a class) - why? why not?
def self.download( datasets )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "downloading [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      Footballdata.schedule( league: league,
                             season: season )
    end
  end
end

def self.convert( datasets )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "converting [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      Footballdata.convert( league: league,
                            season: season )
    end
  end
end
end  # class Job


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
    ## use default - do not set here - why? why not?
    Writer.config.out_dir = './tmp'
  end

  Writer::Job.write( datasets,
                     source: Footballdata.config.convert.out_dir )

  ## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
  gh.git_push_if_changes     if push
end  
end  # module Footballdata



puts FootballdataApi.banner  ## say hello
