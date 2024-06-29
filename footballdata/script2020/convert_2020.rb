$LOAD_PATH.unshift( '../webget/lib')
$LOAD_PATH.unshift( '../football-sources/lib' )
require 'football-sources'


# Footballdata.config.convert.out_dir = './o'
# '../../stage/one'


['eng.1',
 'eng.2',
 'de.1',
 'es.1',
 'fr.1',
 'it.1',
 'nl.1',
 'pt.1',
].each do |league|
  Footballdata.convert( league: league, season: '2020/21' )
end

# note: season is calendar year (but in 2020 runs into 2021!!)
Footballdata.convert( league: 'br.1', season: '2020' )

## note: special case converter for champions league now
# Footballdata.convert_cl( league: 'cl', season: '2020/21' )
Footballdata.convert( league: 'cl', season: '2020/21' )


puts "bye"