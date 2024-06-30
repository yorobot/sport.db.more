$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/structs'   # incl. CsvMatchParser
require 'sportdb/catalogs'



$LOAD_PATH.unshift( '../../sportdb-writers/lib' )
require 'sportdb/writers'


## todo/check: find a better name for helper?
def find_repos( datasets )
  repos = []
  datasets.each do |dataset|
    league_key = dataset[0]
    league = Writer::LEAGUES[ league_key ]
    puts "==> #{league_key}:"
    pp league
    path = league[:path]

    ## use only first part e.g. europe/belgium => europe
    repos << path.split( %r{[/\\]})[0]
  end
  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end


########################
#  push & pull github scripts
require 'gitti'

def git_fast_forward_if_clean( names )
  names.each do |name|
    path = "/sports/openfootball/#{name}"

    puts "==> #{name} - (#{path})..."
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

## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def git_push_if_changes( names )   ## optenfootball repo names e.g. world, england, etc.
  # message = "auto-update week #{Date.today.cweek}"
  message = "up week #{Date.today.cweek}"
  puts message

  names.each do |name|
    path = "/sports/openfootball/#{name}"

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



