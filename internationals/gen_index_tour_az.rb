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


tournaments = recs_by_tournament.keys.sort.each_with_index do |tournament,i|
     buf << " · \n"  if i != 0

     recs_by_year = recs_by_tournament[tournament]

     tooltip = "#{recs_by_year.size} #{recs_by_year.size == 1 ? 'tournament' : 'tournaments'}"

     ## note - use quick slugify_markdownstyle!!
     slug = slugify_markdown( tournament )

     buf << %Q{[#{tournament}](##{slug} "#{tooltip}")}
end
buf << "\n\n"





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


   buf << "## [#{tournament}](#{tour_dir})\n"
   buf << "#{recs_by_year.size} tournament(s) <br>\n"

   totals = {}  ## for teams

   recs_by_year.each_with_index do |(year, matches),i|
       buf << ' ' if i > 0

       stats = calc_stats( matches )

       buf << "[#{year}](#{tour_dir}/#{year}_#{slug}.txt) (#{matches.size}/#{stats['teams'].size})"

       ## update totals for teams
       stats['teams'].each do |team, count|
           team_rec =  totals[team] ||= { name:  team,
                                          years: [],
                                          count: 0 }
           team_rec[:years] << year
           team_rec[:count] += count
       end
   end
   buf << " <br>\n"


   buf << "<details><summary>#{totals.size} teams</summary>\n\n"
   totals.values.sort do |l,r|
           res =  r[:years].size <=> l[:years].size
           res =  r[:count]      <=> l[:count]  if res == 0
           res =  l[:name]       <=> r[:name]   if res == 0
           res
   end.each do |team_rec|
      if recs_by_year.size == 1
        buf << "- #{team_rec[:name]}"
        buf << " - #{team_rec[:count]} match(es)"
        buf << "\n"
      else
        buf << "- #{team_rec[:name]}"
        buf << " - #{team_rec[:years].size} year(s), "
        buf << "#{team_rec[:count]} match(es)"
        buf << "  -  "
        if team_rec[:years].size <= 10
           buf << team_rec[:years].join( ' ' )
        else
            buf << team_rec[:years][0,3].join( ' ' ) +
                    " ... " + team_rec[:years][-3,3].join( ' ' )
        end
        buf << "\n"
      end
   end
   buf << "\n</details>"
   buf << "\n\n"
end

puts buf


## write both
outdir = "./tmp"
write_text( "#{outdir}/TOURNAMENTS.md", buf )

outdir = "/sports/openfootball/internationals"
write_text( "#{outdir}/TOURNAMENTS.md", buf )


puts "bye"
