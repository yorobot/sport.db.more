#####
#  to run use
#   $ ruby sandbox/test_convert.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'  ### c:\sports\cache



## recs = Openliga::convert( league: 'euro', season: '2024' )

## recs = Openliga::convert( league: 'southamerica', season: '2024' )


## recs = Openliga::convert( league: 'de.cup', season: '2024/25' )


buf = Openliga::convert( league: 'de.1', season: '2020/21' )
## buf = Openliga::convert( league: 'de.cup', season: '2026/27' )
puts buf


puts "bye"