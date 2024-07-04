

# require 'sportdb/formats'   ## for Season etc.
require 'sportdb/catalogs'    ## note: incl. deps csvreader etc.
require 'sportdb/writers'


require 'footballdata'      # e.g. football-data.org (api)
require 'worldfootball'     # e.g. weltfussball.de (web)



###
# our own code
require_relative 'football-sources/version' # let version always go first
require_relative 'football-sources/process'




puts FootballSources.banner   # say hello
