require 'sportdb/catalogs'
require 'sportdb/models'


###
# our own code
require 'sportdb/exporters/version'
require 'sportdb/exporters/json_exporter'

require 'sportdb/exporters/json_exporter_worldcup'     ## for worldcup
require 'sportdb/exporters/json_exporter_euro'         ## quick hack for euro



SportDb::Module::Exporters.banner     # say hello

