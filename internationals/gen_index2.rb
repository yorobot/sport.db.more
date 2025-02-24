require 'cocos'


### index by tournaments


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


buf = String.new

## sort by name
tournaments = recs_by_tournament.keys.sort

tournaments.each do |tournament|
   recs_by_year = recs_by_tournament[tournament]
   buf << "## #{tournament} (#{recs_by_year.size})\n"
   recs_by_year.each_with_index do |(year, matches),i|
       buf << ' ' if i > 0
       buf << "#{year} (#{matches.size})"
   end
   buf << "\n\n"
end

puts buf

write_text( "./tmp/INDEX_BY_TOURNAMENT.md", buf )

puts "bye"


