require 'cocos'
require 'season-formats'




require_relative 'fbtxt-pp/helper'


## models
require_relative 'fbtxt-pp/models/document'  ## note - document is container for LeagueSeason holding teams, matches, etc.
require_relative 'fbtxt-pp/models/match'
require_relative 'fbtxt-pp/models/score'
require_relative 'fbtxt-pp/models/goals'
require_relative 'fbtxt-pp/models/teams'
require_relative 'fbtxt-pp/models/players'
require_relative 'fbtxt-pp/models/stadiums'



## pretty print
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
