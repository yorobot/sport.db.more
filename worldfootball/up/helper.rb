$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


### todo/fix:
##    add option for -e/--env(ironment)
##      - lets you toggle between dev/prod/etc. - why? why not?
require 'optparse'

puts "-- optparse:"

OPTS = {}
parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options]"

  parser.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end

  parser.on( "-p", "--push", "(Commit &) push changes to git" ) do |push|
    OPTS[:push] = push
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


## set openfootball github org root - note - NOT monorepo (github) root dirc
SportDb::GitHubSync.root = '/sports/openfootball'   

# Worldfootball.config.convert.out_dir = './o/aug29'
# Worldfootball.config.convert.out_dir = './o'
# Worldfootball.config.convert.out_dir = './o'
Worldfootball.config.convert.out_dir = '../../../cache.wfb'



