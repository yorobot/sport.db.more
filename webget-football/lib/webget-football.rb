## 3rd party (our own)
require 'webget'    ## incl. webget, webcache, webclient, etc.

## 3rd party
require 'nokogiri'


require 'sportdb/structs'   ## add season support - todo/fix: move to season-formats??


###
# our own code
require 'webget-football/version' # let version always go first

require 'webget-football/apis'
require 'webget-football/worldfootball'
require 'webget-football/fbref'


puts Webget::Module::Football.banner   # say hello
