$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )
$LOAD_PATH.unshift( '../sportdb-linters/lib' )
require 'sportdb/catalogs'
require 'sportdb/writers'   ## note - requires sportdb/formats only (require sportdb/catalogs first)!!!


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


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
end
parser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts


Webcache.root = '../../../cache'  ### c:\sports\cache
