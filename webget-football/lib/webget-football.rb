## 3rd party (our own)
require 'webget'    ## incl. webget, webcache, webclient, etc.

## 3rd party
require 'nokogiri'


###
# our own code
require 'webget-football/version' # let version always go first

require 'webget-football/apis'
require 'webget-football/worldfootball'


puts Webget::Module::Football.banner   # say hello
