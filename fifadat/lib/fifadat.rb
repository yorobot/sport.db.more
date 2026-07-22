require 'cocos'   ## check if incl webclient already?
require 'webclient'

require 'season-formats'




require_relative 'fifadat/json'    ## read_json_v2, fetch_json, fetch_json_if, etc.



###
##  our own code
require_relative 'fifadat/version'

require_relative 'fifadat/api-config'  ## base
require_relative 'fifadat/api'  ## base
require_relative 'fifadat/helper'
require_relative 'fifadat/prepare'   ## "all-in-one" prepare (download cache) helpers etc.

require_relative 'fifadat/ppdebug'
require_relative 'fifadat/ppmatch'

require_relative 'fifadat/types'
require_relative 'fifadat/errata'


#####
## more
require_relative 'fifadat/pp/norm'

require_relative 'fifadat/pp/stages'
require_relative 'fifadat/pp/teams'
require_relative 'fifadat/pp/stadiums'
require_relative 'fifadat/pp/players'

require_relative 'fifadat/pp/officials'   ## aka referees
require_relative 'fifadat/pp/goals'
require_relative 'fifadat/pp/goals-calc_score'
require_relative 'fifadat/pp/penalties'
require_relative 'fifadat/pp/substitutions'


require_relative 'fifadat/pp/build_match'
require_relative 'fifadat/pp/build_report'
require_relative 'fifadat/pp/convert'
require_relative 'fifadat/pp/convert-reports'

require_relative 'fifadat/pp/helper-date'
require_relative 'fifadat/pp/helper-score'
require_relative 'fifadat/pp/helper-minute'


require_relative 'fifadat/tool'      ## fifadat command-line tool



puts Fifadat.banner  ## say hello
