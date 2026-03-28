
require_relative 'fifa'
require_relative 'fifa_helper'


data = read_json( "./tmp/search_world_cup.json" )

results_count = data['Results'].size
puts "  #{results_count} result(s)"

data['Results'].each_with_index do |h,i|

    idSeason = h['IdSeason']
    idCompetition = h['IdCompetition']
    name = desc( h['Name'] )

    puts  "#{idSeason} #{idCompetition} -- #{name}" 
end


puts "bye"