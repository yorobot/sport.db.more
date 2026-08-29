## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

require 'cgi'  ## todo - check if already required upstream!!!
               ##   pulled-in for CGI.escpape  (URI path) e.g. /getmatchdata/BLÖ/2026


###
# our own code
require_relative 'openliga/leagues'
require_relative 'openliga/download'


require_relative 'openliga/models'


require_relative 'openliga/convert'
require_relative 'openliga/convert_helpers'
require_relative 'openliga/convert-match'
require_relative 'openliga/convert-score'
require_relative 'openliga/convert-goals'


require_relative 'openliga/pp_matches'


require_relative 'openliga/tool'