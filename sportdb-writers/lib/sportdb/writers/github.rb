
module SportDb

###
## todo/fix:
##   add -i/--interactive flag
##     will prompt yes/no  before git operations (with consequences)!!!


class GitHubSync

######## 
##  (auto)default to Writer.config.out_dir - why? why not?
##
##    note - is root for org (NOT monotree for now - why?`why not?)
def self.root()  @root || "/sports/openfootball"; end
def self.root=( dir ) @root = dir; end  
## use root_dir (alias) - why? why not?


def initialize( datasets )
    @repos = _find_repos( datasets )
end


def git_push_if_changes 
    _git_push_if_changes( @repos )
end 
    
def git_fast_forward_if_clean
   _git_fast_forward_if_clean( @repos )
end


## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def _git_push_if_changes( names )   ## optenfootball repo names e.g. world, england, etc.
  message = "auto-update week #{Date.today.cweek}"  ## add /#{Date.today.cday - why? why not?
  puts message

  names.each do |name|
    path = "#{self.class.root}/#{name}"

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


def _git_fast_forward_if_clean( names )
  names.each do |name|
    path = "#{self.class.root}/#{name}"

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


## todo/check: find a better name for helper?
## note: datasets of format
##  
## DATASETS = [
##   ['it.1',    %w[2020/21 2019/20]],
##  ['it.2',    %w[2019/20]],
##  ['es.1',    %w[2019/20]],
##  ['es.2',    %w[2019/20]],
## ]

def _find_repos( datasets )
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
  

  

end  # class GitHub
end  # module SportDb
