require 'cocos'
require 'alphabets'




require_relative 'gen/base'
require_relative 'gen/archive'
require_relative 'gen/name_history'
require_relative 'gen/build_stats'



repo_dir = "/sports/more/international_results"


ar = Archive.new
ar.add_matches( read_csv( "#{repo_dir}/results.csv" ))

puts "bye"




##
##  read our own list of top-level/major tournaments
recs = read_csv( "./tournaments.csv" )
puts "  #{recs.size} tournament record(s)"

## lookup by names
top_tournaments = recs.map { |rec| rec['name'] }



buf = String.new
buf << "# Tournament Index by Year\n\n"

ar.matches_by_year.each do |year, tournaments|
   buf << "## #{year}"
   ## get matches of all tournaments in year
   count = tournaments.reduce(0) { |cnt, (_,matches)| cnt += matches.size }
   buf << " (#{count})\n"

   ## sort by tournament name
   ##   plus Friendly always goes first

   names = tournaments.keys
   friendly = names.delete( 'Friendly' )

   names = names.sort
   names.unshift( friendly )   if friendly   ## add back friendly if exists

   buf <<  names.map do |tournament|
                          slug    = slugify( tournament )
                          matches = tournaments[tournament]

                          stats = calc_stats( matches )

                          ##  note - add/file "minor" tournaments under "more"
                          path =  if top_tournaments.include?( tournament )
                                       "#{slug}/#{year}_#{slug}.txt"
                                  else
                                       "more/#{slug}/#{year}_#{slug}.txt"
                                  end

                          link = String.new
                          link << "[#{tournament}](#{path})"
                        "#{link} (#{matches.size}/#{stats['teams'].size})"
                     end.join( ' · ' )
   buf << "\n\n"
end

puts buf



## write both
outdir = "./tmp"
write_text( "#{outdir}/TOURNAMENTS_BY_YEAR.md", buf )

outdir = "/sports/openfootball/internationals"
write_text( "#{outdir}/TOURNAMENTS_BY_YEAR.md", buf )

puts "bye"
