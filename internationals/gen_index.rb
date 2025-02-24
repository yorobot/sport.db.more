require 'cocos'
require 'alphabets'



repo_dir = "/sports/more/international_results"



def slugify( str )
   str = unaccent( str )   
   ## replace space with underscore
   str = str.gsub( ' ', '_' )
   str = str.downcase
   ## remove all BUT a-z, 0-9, _-
   str = str.gsub( /[^a-z0-9_-]/, '' )
   str 
end




recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
pp recs[0]

recs_by_year = {}   ## and tournament


recs.each do |rec|
   date = Date.strptime( rec['date'], '%Y-%m-%d')  


   by_year = recs_by_year[date.year] ||= {}
   matches = by_year[rec['tournament']] ||= []

   matches << rec
end


buf = String.new

recs_by_year.each do |year, tournaments|
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
                          link = String.new
                          slug = slugify( tournament )
                          link << "[#{tournament}](#{slug}/#{year}_#{slug}.txt)"
                        "#{link} (#{tournaments[tournament].size})"
                     end.join( ' · ' )
   buf << "\n\n"
end

puts buf

write_text( "./tmp/INDEX_BY_YEAR.md", buf )

puts "bye"



###
##  generate INDEX.md
##     generate index by year
##    year
##       tournaments (matches)     #  teams, from to)