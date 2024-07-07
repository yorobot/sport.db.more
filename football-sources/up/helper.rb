$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )
$LOAD_PATH.unshift( '../sportdb-linters/lib' )


$LOAD_PATH.unshift( '../footballdata/lib' )   ### footballdata-api gem
$LOAD_PATH.unshift( '../worldfootball/lib' )  

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'football/sources'


load_env   ## use dotenv (.env)



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

  parser.on( "--dry", "Dry run (dump datasets)") do |dry|
    OPTS[:dry] = dry
  end
end
parser.parse!



puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts


Webcache.root = '/sports/cache'  ### c:\sports\cache


## set openfootball github org root - note - NOT monorepo (github) root dirc
SportDb::GitHubSync.root = '/sports/openfootball'   


## add convenience shortcuts
Country = Sports::Country
League  = Sports::League
Club    = Sports::Club



# Worldfootball.config.convert.out_dir = './o/aug29'
# Worldfootball.config.convert.out_dir = './o'
# Worldfootball.config.convert.out_dir = './o'
Worldfootball.config.convert.out_dir = '/sports/cache.wfb'

#########
##  staging cache settings
Footballdata.config.convert.out_dir = '/sports/cache.api.fbdat'
pp File.expand_path( Footballdata.config.convert.out_dir )
#=> /sports/scache.api.fbdat



