require_relative 'fifa'
require_relative 'fifa_helper'
require_relative 'fifa_teams'

## collect (all) teams in teams.json




seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]


teams = Teams.new

seasons.each do |season|

  cup = read_json( "./fifa/#{season}_matches.json" )

   ## pp cup['Results']
   match_count = cup['Results'].size
   puts "  #{match_count} match(es) in season #{season}"


   collect_teams( cup, teams )
end


teams.dump

## fix/fix/fix -- stringize keys!!!
write_json( "./tmp/teams.json", teams.recs )

puts "bye"