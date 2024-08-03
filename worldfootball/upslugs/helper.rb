$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


require_relative 'leagues'   ## pull-in league code to slug maps/configs



require 'pp'
require 'optparse'

puts "NAME          : #{$PROGRAM_NAME}"
puts "-- optparse:"

OPTS = {}
parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGAM_NAME} [options]"

  parser.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end

  parser.on( "", "--force", "Always force update" ) do |force|
    OPTS[:force] = force
  end

end
parser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts


Webcache.root = '/sports/cache'    ## note: use absolute path - why? why not?


