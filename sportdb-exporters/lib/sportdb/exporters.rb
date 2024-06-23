require 'sportdb/catalogs'   ## catalogs gem needed - why ???
require 'sportdb/models'



###
# our own code
require_relative 'exporters/version'
require_relative 'exporters/json_exporter'

require_relative 'exporters/json_exporter_worldcup'     ## for worldcup
require_relative 'exporters/json_exporter_euro'         ## quick hack for euro
require_relative 'exporters/json_exporter_copa'      



SportDb::Module::Exporters.banner     # say hello

