
module SportDb

###
## todo/fix:
##   add -i/--interactive flag
##     will prompt yes/no  before git operations (with consequences)!!!

class GitHubSync

  ## map leagues to repo+path
  ##  e.g.   fr.1   => europe/france
  ##         eng..1 => england


  ##  for other than openfootball (default)
  ## use @
  ##   e.g.    myorg@austria
  ##           austria@myorg ??
  ##
  ##           myorg@europe/france
  ##            europe/france@myorg

REPOS = {
  'at.1' =>  'austria',
  'at.2' =>  'austria',
  'at.3.o' =>   'austria',
  'at.cup' =>   'austria',

  'de.1' =>  'deutschland',
  'de.2' =>  'deutschland',
  'de.3' =>  'deutschland',
  'de.cup' => 'deutschland',

  'eng.1' =>  'england',
'eng.2' =>  'england',
'eng.3' =>  'england',
'eng.4' =>  'england',
'eng.5' =>  'england',
'eng.cup' => 'england',   # English FA Cup

'es.1' => 'espana',
'es.2' => 'espana',

  'fr.1' =>  'europe/france',
  'fr.2' =>  'europe/france',

  'hu.1' => 'europe/hungary',
  'gr.1' => 'europe/greece',
  'pt.1' => 'europe/portugal',
  'pt.2' => 'europe/portugal',

  'ch.1' => 'europe/switzerland',
  'ch.2' => 'europe/switzerland',

  'tr.1' => 'europe/turkey',
  'tr.2' => 'europe/turkey',

  'is.1' => 'europe/iceland',
  'sco.1' =>  'europe/scotland',
  'ie.1' => 'europe/ireland',

  'fi.1' =>  'europe/finland',
   'se.1'  =>  'europe/sweden',
   'se.2'  =>  'europe/sweden',
   'no.1'  =>  'europe/norway',
   'dk.1'  =>  'europe/denmark',

   'lu.1'  =>  'europe/luxembourg',
   'be.1'  =>  'europe/belgium',
    'nl.1' =>  'europe/netherlands',
    'cz.1' =>  'europe/czech-republic',

  'sk.1' =>   'europe/slovakia',
  'hr.1'  =>  'europe/croatia',
  'pl.1' =>   'europe/poland',

  'ro.1' =>  'europe/romania',

  'ua.1' =>  'europe/ukraine',

   'ru.1' =>  'europe/russia',
    'ru.2' => 'europe/russia',

    'it.1' =>  'italy',
    'it.2' =>  'italy',

    'mx.1' => 'mexico',

    'ar.1' => 'south-america/argentina',
    'br.1' => 'south-america/brazil',

    'cn.1' =>  'world/asia/china',
    'jp.1' =>  'world/asia/japan',
}



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
      path  = REPOS[ league_key ]
      ## pp path
      if path.nil?
         puts "!! ERROR - no repo path found for league >#{league_key}<; sorry"
         exit 1
      end

      ## auto-add
      ##   openfootball/ org here
      ##  and keep root "generic" to monoroot - why? why not?

      ## use only first part e.g. europe/belgium => europe
      repos << path.split( '/' )[0]
    end
    pp repos
    repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end




end  # class GitHub
end  # module SportDb
