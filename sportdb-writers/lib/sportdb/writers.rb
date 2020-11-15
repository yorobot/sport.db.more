##  just use sportdb/catalogs  ?! - why? why not?
#  require 'sportdb/importers'   # -- requires db support
#  require 'sportdb/readers'     # -- requires db support
require 'sportdb/catalogs'


###
# our own code
require 'sportdb/writers/version'
require 'sportdb/writers/config'
require 'sportdb/writers/txt_writer'
require 'sportdb/writers/write'

## setup empty leagues (info) hash
module Writer
  LEAGUES = {}
end

require 'sportdb/leagues/leagues_at'
require 'sportdb/leagues/leagues_de'
require 'sportdb/leagues/leagues_eng'
require 'sportdb/leagues/leagues_es'
require 'sportdb/leagues/leagues_europe'
require 'sportdb/leagues/leagues_it'
require 'sportdb/leagues/leagues_mx'
require 'sportdb/leagues/leagues_south_america'
require 'sportdb/leagues/leagues_world'



puts SportDb::Module::Writers.banner   # say hello
