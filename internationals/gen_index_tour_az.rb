require 'cocos'
require 'alphabets'

require_relative 'gen/base'
require_relative 'gen/build_stats'



### build index by tournaments a-z


repo_dir = "/sports/more/international_results"



recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
pp recs[0]


recs_by_tournament = {}

recs.each do |rec|
   date = Date.strptime( rec['date'], '%Y-%m-%d')

   tournament = recs_by_tournament[rec['tournament']] ||= {}
   matches    = tournament[date.year] ||= []

   matches << rec
end




##
##  read our own list of top-level/major tournaments
recs = read_csv( "./tournaments.csv" )
puts "  #{recs.size} tournament record(s)"

## lookup by names
top_tournaments = recs.map { |rec| rec['name'] }



buf = String.new
buf << "# Tournament Index A-Z\n\n"


## sort by name
tournaments = recs_by_tournament.keys.sort

tournaments.each do |tournament|
   recs_by_year = recs_by_tournament[tournament]


   slug = slugify( tournament )
   tour_dir =  if top_tournaments.include?( tournament )
                   "#{slug}"
               else
                   "more/#{slug}"
               end

   buf << "## [#{tournament}](#{tour_dir}) (#{recs_by_year.size})\n"

   recs_by_year.each_with_index do |(year, matches),i|
       buf << ' ' if i > 0

       stats = calc_stats( matches )

       buf << "[#{year}](#{tour_dir}/#{year}_#{slug}.txt) (#{matches.size}/#{stats['teams'].size})"
   end
   buf << "\n\n"
end

puts buf


## write both
outdir = "./tmp"
write_text( "#{outdir}/TOURNAMENTS.md", buf )

outdir = "/sports/openfootball/internationals"
write_text( "#{outdir}/TOURNAMENTS.md", buf )


puts "bye"
