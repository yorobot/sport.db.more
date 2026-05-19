require 'cocos'
require 'alphabets'


root_dir = "/sports/openfootball/internationals"
# root_dir = "./o"


repo_dir = "/sports/more/international_results"



require_relative 'gen/base'
require_relative 'gen/build_goals'
require_relative 'gen/build_stats'
require_relative 'gen/build_tour'



## build index for shootouts
recs = read_csv( "#{repo_dir}/shootouts.csv ")
puts "  #{recs.size} record(s)"
pp recs[0]

shootouts = {}    ## index by date/home_team/away_team
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    shootouts[key] = rec
end


recs = read_csv( "#{repo_dir}/goalscorers.csv ")
puts "  #{recs.size} record(s)"
pp recs[0]

goals = {}
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    by_match = goals[key] ||= []
    by_match <<  rec
end




recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
pp recs[0]

recs_by_year = {}   ## and tournament


recs.each do |rec|
   date = Date.strptime( rec['date'], '%Y-%m-%d')

   ## tournament plus year
   title = "#{} #{date.year}"

   by_year = recs_by_year[date.year] ||= {}
   matches = by_year[rec['tournament']] ||= []

   matches << rec
end





recs_by_year.each do |year, tournaments|
    tournaments.each do |tournament, matches|

       slug = slugify( tournament )

       puts "==> #{year} #{tournament} (#{slug})..."

       buf =  build_tour( tournament: tournament,
                          year:       year,
                          matches:    matches,
                          shootouts:  shootouts,
                          goals:      goals )

       path = "#{root_dir}/#{slug}/#{year}_#{slug}.txt"
       write_text( path, buf )
    end  # each tournament
end   # each year



puts "bye"
