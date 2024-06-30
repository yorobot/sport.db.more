## startup helper

# puts "$0            : #{$0}"              #=> "./top.rb"
# puts "$PROGRAM_NAME : #{$PROGRAM_NAME}"   #=> "./top.rb"
# puts "__FILE__      : #{__FILE__}"        #=> "C:/Sites/yorobot/cache.csv/up.2020/helper.rb"

## get program name WITHOUT path and extension
##  e.g. ./top.rb  =>  top
## todo: find a better name
##   - use SCRIPT or PROGRAM_BASENAME or such - why? why not?
NAME = File.basename( $PROGRAM_NAME, File.extname( $PROGRAM_NAME ))

puts "NAME          : #{NAME}"



### todo/fix:
##    add option for -e/--env(ironment)
##      - lets you toggle between dev/prod/etc.


require 'optparse'

puts "-- optparse:"

OPTS = {}
optparser = OptionParser.new do |opts|
  opts.banner = "Usage: #{NAME} [options]"

  opts.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end

  opts.on( "-p", "--push", "(Commit &) push changes to git" ) do |push|
    OPTS[:push] = push
  end

end
optparser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts



## hack: use "local" dev monoscript too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/rubycoco/monos/lib' )

require 'sportdb/setup'
SportDb::Boot.setup   ## setup dev load path



require_relative '../cache.weltfussball/lib/convert'
require_relative '../writer/lib/write'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SportDb::Boot.root}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SportDb::Boot.root}/openfootball/leagues"




