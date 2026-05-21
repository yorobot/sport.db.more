require 'cocos'
require 'alphabets'    ### e.g. uses unaccent()




require_relative 'gen/base'
require_relative 'gen/build_goals'
require_relative 'gen/build_stats'
require_relative 'gen/build_tour'

require_relative 'gen/name_history'
require_relative 'gen/archive'




repo_dir = "/sports/more/international_results"


ar = Archive.new(
         history: read_csv( './former_names.csv' ))

ar.add_matches(     read_csv( "#{repo_dir}/results.csv" ))
ar.add_shootouts(   read_csv( "#{repo_dir}/shootouts.csv" ))
ar.add_goalscorers( read_csv( "#{repo_dir}/goalscorers.csv" ))
ar.add_stages(      read_csv( "#{repo_dir}/stages.csv" ))




##
##  read our own list of top-level/major tournaments
recs = read_csv( "./tournaments.csv" )
puts "  #{recs.size} tournament record(s)"

## lookup by names
top_tournaments = recs.map { |rec| rec['name'] }




outdir = "/sports/openfootball/internationals"
# outdir = "./o"

ar.matches_by_year.each do |year, tournaments|
    tournaments.each do |tournament, matches|

       slug = slugify( tournament )

       puts "==> #{year} #{tournament} (#{slug}), #{matches.size} match(es)..."

       buf =  build_tour( matches: matches,
                          title:   "#{tournament} #{year}" )


       ##  note - add/file "minor" tournaments under "more"
       path =  if top_tournaments.include?( tournament )
                   "#{outdir}/#{slug}/#{year}_#{slug}.txt"
               else
                   "#{outdir}/more/#{slug}/#{year}_#{slug}.txt"
               end
       write_text( path, buf )
    end  # each tournament
end   # each year



puts "bye"
