###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies

## our own code
require_relative 'apis/footballdata-config'
require_relative 'apis/footballdata-leagues'
require_relative 'apis/footballdata-download'

require_relative 'apis/openliga-leagues'
require_relative 'apis/openliga-download'

