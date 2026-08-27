#####
#  to run use
#   $ ruby sandbox/get_leagues.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'


pp Openliga::Metal.leagues


puts "bye"