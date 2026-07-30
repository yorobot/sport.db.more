##
## note - always use latest (local) if present
$LOAD_PATH.unshift( '/sports/yorobot/fbup/fbup/lib' )
require 'fbup'

require_relative './lib/fbtxt-pp'



format_opts = {
                stadium: false,
                city:    true,
                show_stadiums: true
       }
format_opts_full = {
                show_stadiums: true
       }




opts = {
  dry:      false,  ## dry run (no write)
  test:     true,  ## true,   ## sets push & ffwd to false
  test_dir:  './o',
  convert_dir:  '/sports/cache.api.fifa',
}

puts "OPTS:"
pp opts


datasets = [
    ['de', ['2025/26']],
    ['it', ['2025/26']],
    ['es', ['2025/26']],
    ['fr', ['2025/26']],
]
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



LEAGUE_CODES = {
    'de' => 'de.1',
    'es' => 'es.1',
    'it' => 'it.1',
    'fr' => 'fr.1',
}

datasets.each do |slug, seasons|
  puts "==> gen #{slug} - #{seasons.size} seasons(s)..."

  seasons.each do |season|
     season = Season(season)

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
         basename = slug.gsub( '.', '' )
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

=begin
        buf = pp_matches( slug: slug, season: season,
                          indir: opts[:convert_dir],
                          opts: FormatOpts.build_full( **format_opts ))

        puts buf[0..300]

        ## todo - add header
        write_text( outpath, buf )
=end
  end
end


puts "bye"