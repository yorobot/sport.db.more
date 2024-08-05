
require_relative 'helper'

require_relative 'datasets'


datasets = DATASETS
datasets.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season, j|
       Kicker.download_teams( league: league, season: season )
   end
end


puts "bye"

