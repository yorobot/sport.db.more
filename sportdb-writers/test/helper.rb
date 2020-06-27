## note: use the local version of sportdb gems

# todo/fix: use SPORTDB_DIR or such (for reuse) in boot!!!!!!!!

$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-config/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/writers'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"
