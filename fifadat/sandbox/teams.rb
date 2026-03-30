require_relative '../helper'


## collect (all) teams in teams.json




seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]


teams = Teams.new

seasons.each do |season|

  cup = read_json( "./worldcup/#{season}_matches.json" )
  cup = cup['Results']

   ## pp cup
   puts "  #{cup.size} match(es) in season #{season}"

   teams.add( cup )
end


teams.dump

write_json_v2( "./tmp/worldcup_teams.json", teams.recs )

puts "bye"