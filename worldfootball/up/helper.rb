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

require 'pp'
require 'optparse'

puts "-- optparse:"

OPTS = {}
parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{NAME} [options]"

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



$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


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


###
## todo/fix:
##   add -i/--interactive flag
##     will prompt yes/no  before git operations (with consequences)!!!



########################
#  push & pull github scripts
require 'gitti'

## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def git_push_if_changes( names )   ## optenfootball repo names e.g. world, england, etc.
  message = "auto-update week #{Date.today.cweek}"
  puts message

  names.each do |name|
    path = "#{SportDb::Boot.root}/openfootball/#{name}"

    Gitti::GitProject.open( path ) do |proj|
      puts ''
      puts "###########################################"
      puts "## trying to commit & push repo in path >#{path}<"
      puts "Dir.getwd: #{Dir.getwd}"
      output = proj.changes
      if output.empty?
        puts "no changes found; skipping commit & push"
      else
        proj.add( '.' )
        proj.commit( message )
        proj.push
      end
    end
  end
end


def git_fast_forward_if_clean( names )
  names.each do |name|
    path = "#{SportDb::Boot.root}/openfootball/#{name}"

    Gitti::GitProject.open( path ) do |proj|
      output = proj.changes
      unless  output.empty?
        puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
        puts output
        exit 1
      end

      proj.fast_forward
   end
  end
end





###
## todo/fix:  move more code into tool class or such? - why? why not?

## todo/check: find a better name for helper?
##   find_all_datasets, filter_datatsets - add alias(es???
##  queries (lik ARGV) e.g. ['at'] or ['eng', 'de'] etc. list of strings
def find_datasets( datasets, queries=[] )
  ## find all matching leagues (that is, league keys)
  if queries.empty?  ## no filter - get all league keys
    datasets
  else
    datasets.find_all do |dataset|
                         found = false
                         ## note: normalize league key (remove dot and downcase)
                         league_key = dataset[0].gsub( '.', '' )
                         queries.each do |query|
                            q = query.gsub( '.', '' ).downcase
                            if league_key.start_with?( q )
                              found = true
                              break
                            end
                         end
                         found
                      end
  end
end

## todo/check: find a better name for helper?
def find_repos( datasets )
  repos = []
  datasets.each do |dataset|
    league_key = dataset[0]
    league = Writer::LEAGUES[ league_key ]
    pp league
    path = league[:path]

    ## use only first part e.g. europe/belgium => europe
    repos << path.split( %r{[/\\]})[0]
  end
  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end




def process( datasets, includes: )
  ## filter/find datasets by includes (e.g. at matchting at.1,at.2,at.cup with start_with etc.)
  ## find all repo paths (e.g. england or europe)
  ##   from league code e.g. eng.1, be.1, etc.
  datasets = find_datasets( datasets, includes )
  repos    = find_repos( datasets )


  Worldfootball::Job.download( datasets )   if OPTS[:download]

  ## always pull before push!! (use fast_forward)
  git_fast_forward_if_clean( repos )  if OPTS[:push]


  # Worldfootball.config.convert.out_dir = './o/aug29'
  Worldfootball.config.convert.out_dir = './o'

  Worldfootball::Job.convert( datasets )


  if OPTS[:push]
    Writer.config.out_dir = "#{SportDb::Boot.root}/openfootball"
  else
    Writer.config.out_dir = './tmp'
  end

  Writer::Job.write( datasets,
                     source: Worldfootball.config.convert.out_dir )

  ## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
  git_push_if_changes( repos )    if OPTS[:push]

  puts "INCLUDES (QUERIES):"
  pp includes
  puts "DATASETS:"
  pp datasets
  puts "REPOS:"
  pp repos
end

