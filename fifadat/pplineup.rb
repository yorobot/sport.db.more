require_relative 'fifa'
require_relative 'fifa_helper'
require_relative 'fifa_teams'
require_relative 'fifa_players'



season = 2022
date = Date.new( 2022, 12, 18 )
team1 = 'ARG'
team2 = 'FRA'
idMatch = '400128145'

### get match (live) details
live = read_json( "./matches/#{season}/#{date.strftime('%Y-%m-%d')}_#{team1}-#{team2}__#{idMatch}.json" )




players1 = Players.new
players1.add( live['HomeTeam']['Players'] )
players1.add_subs( live['HomeTeam']['Substitutions'])

players2 = Players.new
players2.add( live['AwayTeam']['Players'] )
players2.add_subs( live['AwayTeam']['Substitutions'])

players1.dump
puts "---"
players2.dump


puts 
puts
lineup = players1.lineup
pp lineup
puts "  #{lineup.size} player(s)"

puts "Argentina: " + pplineup( lineup )
puts "France: " + pplineup( players2.lineup )


puts "bye"

__END__

 "Period": 5,
      "Reason": 0,
      "SubstitutePosition": 4,
      "IdPlayerOff": "266800",
      "IdPlayerOn": "401204",
      "PlayerOffName": [{"Locale": "en-GB", "Description": "Angel DI MARIA"}],
      "PlayerOnName": [{"Locale": "en-GB", "Description": "Marcos ACUNA"}],
      "Minute": "64'",
      "IdTeam": "43922"},
     