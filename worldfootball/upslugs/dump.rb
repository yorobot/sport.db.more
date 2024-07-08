##
#  to run use
#     $ ruby upslugs/dump.rb

require_relative 'helper'


pp ARGV

slug = ARGV[0] || 'usa-u-s-open-cup-2024'

page = Worldfootball::Page::Schedule.from_cache( slug )

matches = page.matches
teams   = page.teams
rounds  = page.rounds

puts "  #{matches.size} match(es), #{teams.size} team(s), #{rounds.size} round(s)"
pp matches

puts
puts "  #{teams.size} team(s)"
pp teams

puts 
puts "  #{rounds.size} round(s)"
pp rounds

puts "bye"