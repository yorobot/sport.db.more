$LOAD_PATH.unshift( '../../../sportdb/sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-quick/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-search/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )
$LOAD_PATH.unshift( '../sportdb-linters/lib' )


require 'sportdb/formats'
require 'sportdb/writers'   ## note - requires sportdb/formats only (require sportdb/catalogs first)!!!


path = "./datasets/2024-25/uefa.cl.csv"
matches = SportDb::CsvMatchParser.read( path )
puts "matches #{matches.size} records"

pp matches[0]




outdir = "./tmp"

Writer.config.out_dir = outdir
pp Writer.config.out_dir

    Writer.write( league: 'uefa.cl',
                  season: '2024/25',
                  source: './datasets'
                 )

puts "bye"

