require 'cocos'
require 'season-formats'




require_relative 'fbtxt-pp/helper'


def norm_name( str )
   ##  todo/fix - add/report to console if  space collaped or dash trimmed etc.
   ##  collapse spaces into one
   ##  e.g.
   str = str.gsub( /[ ]+/, ' ' )
   ##    remove leading & trailing space around dash (-)
   ##   e.g. Callum HUDSON - ODOI  =>  Callum HUDSON-ODOI
   str = str.gsub( / - /, '-' )
   str
end


def slugify( str )
   str.downcase.gsub( /[^a-z0-9]/, '' )
end


## models
require_relative 'fbtxt-pp/models/document'  ## note - document is container for LeagueSeason holding teams, matches, etc.
require_relative 'fbtxt-pp/models/match'
require_relative 'fbtxt-pp/models/score'
require_relative 'fbtxt-pp/models/goals'
require_relative 'fbtxt-pp/models/penalties'
require_relative 'fbtxt-pp/models/teams'
require_relative 'fbtxt-pp/models/players'
require_relative 'fbtxt-pp/models/officials'
require_relative 'fbtxt-pp/models/stadiums'



## pretty print
require_relative 'fbtxt-pp/pp/ppopts'  ## use ppformat_opts or such - why? why not?
require_relative 'fbtxt-pp/pp/ppgoals'
require_relative 'fbtxt-pp/pp/ppstats'
require_relative 'fbtxt-pp/pp/ppmatch'
require_relative 'fbtxt-pp/pp/ppmatch_full'
require_relative 'fbtxt-pp/pp/ppmatch_min'
require_relative 'fbtxt-pp/pp/pppenalties'
require_relative 'fbtxt-pp/pp/pplineup'
require_relative 'fbtxt-pp/pp/ppsquads'


require_relative 'fbtxt-pp/config'
require_relative 'fbtxt-pp/tool'
