$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '../webget-football/lib' )
$LOAD_PATH.unshift( './lib' )

require 'football/sources'


Webcache.root = '../../../cache'  ### c:\sports\cache

Webget.config.sleep  = 11    ## max. 10 requests/minute




# Footballdata.schedule( league: 'eng.1', season: '2023/24' )
# Footballdata.schedule( league: 'de.1', season: '2023/24' )



puts "==> eng.1 2023/24"
Footballdata.convert( league: 'eng.1', season: '2023/24' )

puts "==> de.1 2023/24"
Footballdata.convert( league: 'de.1', season: '2023/24' )

# puts "==> uefa.cl 2023/24"
# Footballdata.convert( league: 'uefa.cl', season: '2023/24' )

puts "bye"