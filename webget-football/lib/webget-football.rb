## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

## 3rd party
require 'nokogiri'




###
# our own code
require_relative 'webget-football/version' # let version always go first

## shared base code (e.g. Metal::Base, Page::Base, etc.)
require_relative 'webget-football/metal'


## by source

###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


### by source
require_relative 'webget-football/worldfootball/config'
require_relative 'webget-football/worldfootball/leagues'
require_relative 'webget-football/worldfootball/download'
require_relative 'webget-football/worldfootball/page'
require_relative 'webget-football/worldfootball/page_schedule'
require_relative 'webget-football/worldfootball/page_report'


require_relative 'webget-football/fbref'


puts Webget::Module::Football.banner   # say hello
