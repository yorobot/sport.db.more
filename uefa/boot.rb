$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'


###
#  dump built-in table stats / record counts
CatalogDb::Metal.tables 


##
## note - fix - pull in cocos by structs? or formats?
require 'cocos'     


Country = Sports::Country  # or SportDb::Import::Country or WorldDB ???
Club    = Sports::Club     # or SportDb::Import::Club


