$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = '../../../cache'  ### c:\sports\cache



recs = Openliga::convert( league: 'euro', season: '2024' )

## recs = Openliga::convert( league: 'southamerica', season: '2024' )
pp recs


puts "bye"