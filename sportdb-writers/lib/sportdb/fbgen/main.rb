
module Fbgen
def self.main( args=ARGV )

opts = {
  source_path: [],
  push:     false,
  dry:      false,  ## dry run (no write)
  debug:    true,
  file:     nil,
}

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [args]"

    parser.on( "-p", "--push",
               "fast forward sync and commit & push changes to git repo - default is (#{opts[:push]})" ) do |push|
      opts[:push] = push
    end
    parser.on( "--dry",
                "dry run; do NOT write - default is (#{opts[:dry]})" ) do |dry|
      opts[:dry] = dry
    end
    parser.on( "-q", "--quiet",
               "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
      opts[:debug] = !debug
    end

    parser.on( "-f FILE", "--file FILE",
                "read leagues via .csv file") do |file|
      opts[:file] = file
    end
end
parser.parse!( args )



if opts[:source_path].empty? &&
  File.exist?( '/sports/cache.api.fbdat')  &&
  File.exist?( '/sports/cache.wfb' )
 opts[:source_path] << '/sports/cache.api.fbdat'
 opts[:source_path] << '/sports/cache.wfb'
end


puts "OPTS:"
p opts
puts "ARGV:"
p args

datasets =   if opts[:file]
                  read_datasets( opts[:file] )
             else
                  parse_datasets( args )
             end

puts "datasets:"
pp datasets


source_path = opts[:source_path]
source_path = ['.']    if source_path.empty?  ## use ./ as default

root_dir =  if opts[:push]
               GitHubSync.root   # e.g. "/sports"
            else
               './o'
            end

puts "  (output) root_dir: >#{root_dir}<"

sync  = if opts[:push]
           repos = GitHubSync.find_repos( datasets )
           puts "  #{repos.size} repo(s):"
           pp repos
           GitHubSync.new( repos )
        else
           nil
        end
puts "  sync:"
pp sync

sync.git_fast_forward_if_clean      if sync



datasets.each do |league_key, seasons|
    seasons = [ Season('2024/25') ]   if seasons.empty?

    puts "==> gen #{league_key} - #{seasons.size} seasons(s)..."

    league_info = Writer::LEAGUES[ league_key ]
    pp league_info

    seasons.each do |season|
      ### get matches

      filename = "#{season.to_path}/#{league_key}.csv"
      path = find_file( filename, path: source_path )

      if path.nil?
        puts "!! no source found for #{filename}; sorry"
        exit 1
      end

      puts "  ---> reading matches in #{path} ..."
      matches = SportDb::CsvMatchParser.read( path )
      puts "     #{matches.size} matches"

      ## build
      txt = SportDb::TxtMatchWriter.build( matches )
      puts txt   if opts[:debug]

      league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
      basename     = league_info[ :basename]   #.e.g  1-seriea

      league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
      basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season

      buf = String.new
      buf << "= #{league_name} #{season}\n\n"
      buf << txt

      repo  = GitHubSync::REPOS[ league_key ]
      repo_path = "#{repo['owner']}/#{repo['name']}"
      repo_path << "/#{repo['path']}"    if repo['path']  ## note: do NOT forget to add optional extra path!!!

      outpath = "#{root_dir}/#{repo_path}/#{season.to_path}/#{basename}.txt"
      if opts[:dry]
        puts "   (dry) writing to >#{outpath}<..."
      else
        write_text( outpath, buf )
      end
    end
end

sync.git_push_if_changes   if sync

end  # method self.main



def self.parse_datasets( args )
### split args in datasets with leagues and seasons
datasets = []
args.each do |arg|
   if arg =~ %r{^[0-9/-]+$}   ##  season
       if datasets.empty?
         puts "!! ERROR - league required before season arg; sorry"
         exit 1
       end

       season = Season.parse( arg )  ## check season
       datasets[-1][1] << season
   else ## assume league key
       key = arg.downcase
       league_info = Writer::LEAGUES[ key ]

       if league_info.nil?
         puts "!! ERROR - no league found for >#{key}<; sorry"
         exit 1
       end

       datasets << [key, []]
   end
end
datasets
end


def self.read_datasets( path )
### split args in datasets with leagues and seasons
datasets = []
recs = read_csv( path )
recs.each do |rec|
    league_code  = rec['league']
    key = league_code.downcase
    league_info = Writer::LEAGUES[ key ]

    if league_info.nil?
      puts "!! ERROR - no league found for >#{key}<; sorry"
      exit 1
    end

    datasets << [key, []]

    seasons_str = rec['seasons']
    seasons = seasons_str.split( /[ ]+/ )

    seasons.each do |season_str|
        season = Season.parse( season_str )  ## check season
        datasets[-1][1] << season
    end
end
datasets
end


def self.find_file( filename, path: )
    path.each do |src_dir|
       path = "#{src_dir}/#{filename}"
       return path   if File.exist?( path )
    end

    ##  fix - raise file not found error!!!
    nil  ## not found - raise filenot found error - why? why not?
end



end  # module Fbgen
