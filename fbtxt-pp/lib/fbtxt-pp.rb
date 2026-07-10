require 'cocos'


## todo/fix - use a module with method for config!!!
CACHE_DIR = '/sports/cache.api.fifa'



require_relative 'fbtxt-pp/helper'
require_relative 'fbtxt-pp/teams'
require_relative 'fbtxt-pp/stadiums'
require_relative 'fbtxt-pp/goals'


## pretty print
require_relative 'fbtxt-pp/pp/pphelper'
require_relative 'fbtxt-pp/pp/ppgoals'
require_relative 'fbtxt-pp/pp/ppstats'
require_relative 'fbtxt-pp/pp/ppmatch'
require_relative 'fbtxt-pp/pp/ppmatch_full'
require_relative 'fbtxt-pp/pp/ppmatch_min'
require_relative 'fbtxt-pp/pp/pppenalties'
require_relative 'fbtxt-pp/pp/pplineup'
require_relative 'fbtxt-pp/pp/ppsquads'
