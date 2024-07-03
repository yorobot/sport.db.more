$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )
$LOAD_PATH.unshift( '../sportdb-linters/lib' )

require 'sportdb/catalogs'
require 'sportdb/writers'   ## note - requires sportdb/formats only (require sportdb/catalogs first)!!!


$LOAD_PATH.unshift( './lib' )
require 'footballdata'


## add convenience shortcuts
Country = Sports::Country
League  = Sports::League
Club    = Sports::Club



SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
CatalogDb::Metal.tables


##########
##  webcache settings
Webcache.root = '/sports/cache'  
pp File.expand_path( Webcache.root )
#=> /sports/cache

## max. 10 requests/minute
##          about ~6 request/minute (if delay is 10 secs) 
Webget.config.sleep  = 10

#########
##  staging cache settings
Footballdata.config.convert.out_dir = '/sports/cache.api.fbdat'
pp File.expand_path( Footballdata.config.convert.out_dir )
#=> /sports/scache.api.fbdat


##
# todo/fix - change to (generic) monoroot  e.g. /sports (or /sites) or such
SportDb::GitHubSync.root = "/sports/openfootball"
pp File.expand_path( SportDb::GitHubSync.root )

