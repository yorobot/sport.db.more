
##
## kind of a new version of fbup !!!
##      works with json datasources (not csv)
##   maybe merge later into one


module Fbhub


LEAGUE_CODES = {
    'de'  => 'de.1',
    'eng' => 'eng.1',
    'es'  => 'es.1',
    'it'  => 'it.1',
    'fr'  => 'fr.1',
    'at'  => 'at.1',
    'mx'  => 'mx.1',
}



def self.main( args=ARGV )

opts = {
  push:     false,
  ffwd:     false,

  full:     true,   ## add full details page - true|false
  test:     true,  ## true,   ## sets push & ffwd to false
  test_dir:  './o',
  convert_dir:  '/sports/cache.api.fifa',
  file:     nil,
}


parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [args]"

    parser.on( "-p", "--[no-]push",
               "fast forward sync and commit & push changes to git repo - default is (#{opts[:push]})" ) do |push|
      opts[:push] = push
      if opts[:push]   ## note: autoset ffwd too if push == true
        opts[:ffwd] = true
        opts[:test] = false
      end
    end
    ## todo/check - add a --ffwd flag too - why? why not?

    parser.on( "-t", "--test",
                "test run; writing output to #{opts[:test_dir]} - default is #{opts[:test]}" ) do |test|
      opts[:test] = true
      opts[:push] = false
      opts[:ffwd] = false
    end

    parser.on( "-f FILE", "--file FILE",
                "read leagues (and seasons) via .csv file") do |file|
      opts[:file] = file
    end
end
parser.parse!( args )



puts "OPTS:"
pp opts


datasets = if opts[:file]
              recs = read_csv( opts[:file] )

               datasets = recs.map do |rec|
                               ## auto-convert season to season obj - why? why not?
                               ##   use Season.parse_line
                                 [ rec['league'],
                                   Season.parse_line( rec['seasons'])]
                          end
           else
             puts "!! error: --file FILE option for now required; sorry"
             exit 1
           end


pp datasets


####
#  get github repos for (league) slugs/codes

root_dir =  if opts[:test]
               opts[:test_dir]
            else
               Fbup::GitHubSync.root   # e.g. "/sports"
            end

puts "  (output) root_dir: >#{root_dir}<"


repos = Fbup::GitHubSync.find_repos( datasets )
puts "  #{repos.size} repo(s):"
pp repos

sync  =  Fbup::GitHubSync.new( repos )
puts "  sync:"
pp sync

sync.git_fast_forward_if_clean    if opts[:ffwd]



datasets.each do |slug, seasons|
  puts "==> gen #{slug} - #{seasons.size} seasons(s)..."

  config = CONFIGS[ slug ]
  if config.nil?
     puts "!! no pp config found for slug >#{slug}<; keys/codes include:"
     pp CONFIGS.keys
     exit 1
  end

  seasons.each do |season|
     ## get repo config for flags and more
      repo  = Fbup::GitHubSync::REPOS[ slug ]
      flags = repo['flags'] || {}
      classic_flag = flags['classic'] || false

      pp repo


      basename = nil
      if classic_flag
         league_config = Fbup::LeagueConfig.find_by( code:   LEAGUE_CODES[slug]||slug,
                                                      season: season )
         if league_config.nil?
            puts "!! ERROR - basename league config required for classic format; no config found for #{league_query} #{season}; sorry"
            exit 1
         end
         basename  = league_config['basename']
      else
         ## change base name to league key
         ##   todo - fix - make gsub smarter
         ##    change at.cup to at_cup - why? why not?
         basename = (LEAGUE_CODES[slug]||slug).gsub( '.', '' )
      end


      repo_path = "#{repo['owner']}/#{repo['name']}"
      repo_path << "/#{repo['path']}"    if repo['path']  ## note: do NOT forget to add optional extra path!!!


      outpath = "#{root_dir}/#{repo_path}"
      outpath +=  if classic_flag
                     "/#{season.to_path}/#{basename}.txt"
                  else
                     ## note - add season "inline" (to basename) or use dir
                     "/#{season.to_path}_#{basename}.txt"
                  end

      outpath_full = "#{root_dir}/#{repo_path}"
      outpath_full +=  if classic_flag
                     "/#{season.to_path}/#{basename}-full.txt"
                  else
                     ## note - add season "inline" (to basename) or use dir
                     "/#{season.to_path}_#{basename}-full.txt"
                  end

       puts "   writing to >#{outpath}<..."
       puts "   writing (full) to >#{outpath_full}<..."

       league_name      = config[:name]
       format_opts      = config[:opts]
       format_opts_full = config[:opts_full]

        header = String.new
        header << "= #{league_name} #{season}\n\n"

        buf = pp_matches( slug: slug, season: season,
                          indir: opts[:convert_dir],
                          opts: FormatOpts.build( **format_opts ))

        puts buf[0..300]
        write_text( outpath, header+buf )

        if opts[:full]
          buf = pp_matches_full( slug: slug, season: season,
                                 indir: opts[:convert_dir],
                                  opts: FormatOpts.build_full( **format_opts_full ))


          puts buf[0..300]
          write_text( outpath_full, header+buf )
        end
  end
end


sync.git_push_if_changes   if opts[:push]


puts "bye"
end

end   ## module Fbhub