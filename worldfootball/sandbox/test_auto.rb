require_relative 'helper'


### test auto-configurations of league pages/slugs

at = Worldfootball::LEAGUES[ 'at.1' ]
pp at

puts
pp at.seasons.keys
puts "  #{at.seasons.keys.size} season(s)"

puts
pp at.seasons

puts
pages = at.pages( season: '2024/25' )
pp pages

puts
pages = at.pages( season: '2023/24' )
pp pages

puts
pages = at.pages( season: '2000/01' )
pp pages



puts "bye"

