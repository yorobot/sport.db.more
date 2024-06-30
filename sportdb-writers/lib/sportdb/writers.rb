##  just use sportdb/catalogs  ?! - why? why not?
#  require 'sportdb/importers'   # -- requires db support
#  require 'sportdb/readers'     # -- requires db support
require 'sportdb/catalogs'


module Writer
  class Configuration
     def out_dir()        @out_dir   || './tmp'; end
     def out_dir=(value)  @out_dir = value; end
  end # class Configuration

  ## lets you use
  ##   Write.configure do |config|
  ##      config.out_dir = "??"
  ##   end
  def self.configure()  yield( config ); end
  def self.config()  @config ||= Configuration.new;  end
end   # module Writer

###
# our own code
require_relative 'writers/version'
require_relative 'writers/txt_writer'

require_relative 'writers/teams'
require_relative 'writers/goals'
require_relative 'writers/write'

## setup empty leagues (info) hash
module Writer
  LEAGUES = {}
end

require_relative 'leagues/leagues_at'
require_relative 'leagues/leagues_de'
require_relative 'leagues/leagues_eng'
require_relative 'leagues/leagues_es'
require_relative 'leagues/leagues_europe'
require_relative 'leagues/leagues_it'
require_relative 'leagues/leagues_mx'
require_relative 'leagues/leagues_south_america'
require_relative 'leagues/leagues_world'


puts SportDb::Module::Writers.banner   # say hello
