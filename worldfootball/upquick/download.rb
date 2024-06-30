##################
# to run use:
#    ruby upquick\download.rb


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


Webcache.root = '../../../cache'  ### c:\sports\cache

# Worldfootball.config.sleep = 3



SLUGS = %w[
  eng-premier-league-1998-1999
]


SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}]>#{slug}<"
  Worldfootball::Metal.download_schedule( slug )
end


puts "bye"
