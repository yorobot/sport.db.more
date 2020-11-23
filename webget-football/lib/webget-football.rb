## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

## 3rd party
require 'nokogiri'




###
# our own code
require 'webget-football/version' # let version always go first

## shared base code (e.g. Metal::Base, Page::Base, etc.)
require 'webget-football/metal'

## sources
require 'webget-football/apis'
require 'webget-football/worldfootball'
require 'webget-football/fbref'


puts Webget::Module::Football.banner   # say hello
