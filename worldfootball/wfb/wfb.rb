##################
# to run use:
#    ruby wfb\wfb.rb


require 'pp'
require 'optparse'


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


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



$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/structs'   # incl. CsvMatchParser
require 'sportdb/catalogs'

$LOAD_PATH.unshift( '../sportdb-writers/lib' )
require 'sportdb/writers'



league  = ARGV[0] || 'eng.1'
season  = ARGV[1] || '2023/24'



Worldfootball.schedule( league: league,
                        season: season )   if OPTS[:download]



Worldfootball.config.convert.out_dir = '../../../cache.wfb'

Worldfootball.convert( league: league,
                       season: season )


                       
Writer.config.out_dir = './tmp'

Writer.write( league: league,
              season: season,
              normalize: false,
                  source: Worldfootball.config.convert.out_dir )


puts "bye"