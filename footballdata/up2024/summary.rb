$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-models/lib' )
$LOAD_PATH.unshift( '../../sportdb-linters/lib' )


require 'sportdb/catalogs'
require 'sportdb/linters'    # e.g. uses TeamSummary class


SportDb::Import.config.catalog_path = '../../../../sportdb/sport.db/catalog/catalog.db'

CatalogDb::Metal.tables


require 'cocos'


DATAFILES_DIR = '../../../../stage'

team_buf, team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )

path = "#{DATAFILES_DIR}/SUMMARY.md"
write_text( path, team_buf )


puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts 'bye'

