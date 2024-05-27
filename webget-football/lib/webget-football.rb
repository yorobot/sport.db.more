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

## sources
require_relative 'webget-football/apis'   ## incl. football-data.org (by Daniel Friday)
require_relative 'webget-football/worldfootball'
require_relative 'webget-football/fbref'
require_relative 'webget-football/footballsquads'


puts Webget::Module::Football.banner   # say hello
