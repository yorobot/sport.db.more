#####
#  to run use
#   $ ruby sandbox/test_leagues.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'


pp Openliga::LEAGUES
puts "  #{Openliga::LEAGUES.keys.size} league(s)"


puts "bye"