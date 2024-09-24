###
##  to run use:
##    $ ruby sandbox/test_leagues.rb


require_relative 'helper'



keys = Worldfootball::LEAGUES.keys

keys.each do |key|

   zone = find_zone( league: key, season: '2024' )
   if zone.nil?
      puts "!! no zone found for #{key}"
   else
      puts "  OK #{key} => #{zone.name}"
   end
end

puts "bye"

