$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'  ### c:\sports\cache




Openliga::download( league: 'de.cup', season: '2026/27' )


puts "bye"