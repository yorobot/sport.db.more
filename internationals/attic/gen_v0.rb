require 'cocos'
require 'alphabets'


root_dir = "/sports/openfootball/internationals"
# root_dir = "./o"


repo_dir = "/sports/more/international_results"



require_relative 'gen/base'
require_relative 'gen/build_goals'
require_relative 'gen/build_stats'
require_relative 'gen/build_tour'

require_relative 'gen/lookup_name'


## build index for shootouts
recs = read_csv( "#{repo_dir}/shootouts.csv ")
puts "  #{recs.size} shootout record(s)"
pp recs[0]

shootouts = {}    ## index by date/home_team/away_team
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    shootouts[key] = rec
end


recs = read_csv( "#{repo_dir}/goalscorers.csv ")
puts "  #{recs.size} goalscorer record(s)"
pp recs[0]

goals = {}
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    by_match = goals[key] ||= []
    by_match <<  rec
end


recs = read_csv( "#{repo_dir}/stages.csv ")
puts "  #{recs.size} stages record(s)"
pp recs[0]

stages = {}
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    stages[key] = rec
end





##
##  read our own list of top-level/major tournaments
recs = read_csv( "./tournaments.csv" )
puts "  #{recs.size} tournament record(s)"

## lookup by names
top_tournaments = recs.map { |rec| rec['name'] }




recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} result record(s)"
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



name_history = NameHistoryLookup.read( './former_names.csv' )




recs_by_year.each do |year, tournaments|
    tournaments.each do |tournament, matches|

       slug = slugify( tournament )

       puts "==> #{year} #{tournament} (#{slug})..."

##
## check for historic names
   matches = matches.map do |match|
       ## home_team,away_team
       date = Date.strptime( match['date'], '%Y-%m-%d' )
       home_team =  match['home_team']
       away_team =  match['away_team']

       home_team = name_history.historic_name_by_date( home_team, date: date )
       away_team = name_history.historic_name_by_date( away_team, date: date )

       match['home_team'] = home_team
       match['away_team'] = away_team

       match
   end


       buf =  build_tour( tournament: tournament,
                          year:       year,
                          matches:    matches,
                          shootouts:  shootouts,
                          goals:      goals,
                          stages:     stages )

       ##
       ##  add/file "minor" tournaments under "more"
       path =  if top_tournaments.include?( tournament )
                   "#{root_dir}/#{slug}/#{year}_#{slug}.txt"
               else
                   "#{root_dir}/more/#{slug}/#{year}_#{slug}.txt"
               end
       write_text( path, buf )
    end  # each tournament
end   # each year



puts "bye"
