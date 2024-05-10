require 'sportdb/catalogs'
require 'sportdb/models'


###
# our own code
require 'sportdb/exporters/version'
require 'sportdb/exporters/json_exporter'
require 'sportdb/exporters/json_exporter_more'     ## for worldcup
require 'sportdb/exporters/json_exporter_more_ii'  ## quick hack for euro



SportDb::Module::Exporters.banner     # say hello

