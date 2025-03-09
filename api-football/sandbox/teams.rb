
require_relative 'helper'



teams  = ApiFootball.teams( league: 'copa.l', season: '2023' )
## teams  = ApiFootball.teams( league: 'world', season: '2022' )

pp teams


#### lookup country codes for teams

teams['response'].each do |rec|

   team_name    = rec['team']['name'] 
   team_country = rec['team']['country']

   cty = Fifa.world.find_by_name( team_country )
   if cty.nil?
     pp rec['team']
     puts "!! ERROR - no country found for >#{team_country}<"
     exit 1
   end

   puts "   #{team_name}, #{team_country} => (#{cty.code})"
end


puts "bye"
