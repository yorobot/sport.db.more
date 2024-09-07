
require 'sportdb/quick'



module Writer
  class Configuration
     def out_dir()        @out_dir   || './tmp'; end
     def out_dir=(value)  @out_dir = value; end
     ## add outdir alias - why? why not?
  end # class Configuration

  ## lets you use
  ##   Write.configure do |config|
  ##      config.out_dir = "??"
  ##   end
  def self.configure()  yield( config ); end
  def self.config()  @config ||= Configuration.new;  end
end   # module Writer



###
# our own code
require_relative 'writers/version'
require_relative 'writers/txt_writer'

require_relative 'writers/goals'
require_relative 'writers/write'


## setup  leagues (info) table
require_relative 'writers/league_config'

module Writer
  LEAGUES = SportDb::LeagueConfig.new

  ['leagues_europe',
   'leagues_america',
   'leagues_world'
  ].each do |name|
    recs = read_csv( "#{SportDb::Module::Writers.root}/config/#{name}.csv" )
    LEAGUES.add( recs )
  end
end  # module Writer



########################
#  push & pull github scripts
require 'gitti'    ## note - requires git machinery

require_relative 'writers/github_config'
require_relative 'writers/github'   ## github helpers/update machinery


module SportDb
class  GitHubSync
  REPOS = GitHubConfig.new
  recs = read_csv( "#{SportDb::Module::Writers.root}/config/openfootball.csv" )
  REPOS.add( recs )

## todo/check: find a better name for helper?
## note: datasets of format
##
## DATASETS = [
##   ['it.1',    %w[2020/21 2019/20]],
##  ['it.2',    %w[2019/20]],
##  ['es.1',    %w[2019/20]],
##  ['es.2',    %w[2019/20]],
## ]

def self.find_repos( datasets )
  repos = []
  datasets.each do |dataset|
    league_key = dataset[0]
    repo  = REPOS[ league_key ]
    ## pp repo
    if repo.nil?
       puts "!! ERROR - no repo config/path found for league >#{league_key}<; sorry"
       exit 1
    end

    repos <<  "#{repo['owner']}/#{repo['name']}"
  end

  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end
end  #  class  GitHubSync
end  # module SportDb





###
## todo/fix:  move more code into tool class or such? - why? why not?

## todo/check: find a better name for helper?
##   find_all_datasets, filter_datatsets - add alias(es???
##  queries (lik ARGV) e.g. ['at'] or ['eng', 'de'] etc. list of strings
def filter_datasets( datasets, queries=[] )
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




puts SportDb::Module::Writers.banner   # say hello
