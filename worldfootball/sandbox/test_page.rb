require_relative 'helper'


# slug = 'eng-premier-league-2024-2025'
# slug = 'eng-premier-league-2023-2024'
# slug = 'african-football-league-2023'
slug = 'caf-champions-league-2024-2025'


page = Worldfootball::Page::Schedule.from_cache( slug )


puts "matches:"
pp page.matches

puts
puts "teams:"
pp page.teams

puts "bye"

