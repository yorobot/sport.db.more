require_relative 'helper'


## Worldfootball.convert( league: 'eng.1', season: '2023/24' )


# league = 'de.cup'
# season = '2023/24'


## defaults to './o'
Worldfootball.config.convert.out_dir = '/sports/cache.wfb'


SEASONS = ['2024/25']

datasets = [
    ['at.1',    SEASONS],
    ['at.2',    SEASONS],
    ['at.3.o',  SEASONS],
    ['at.cup',  SEASONS],

    ['ch.1',    SEASONS],
    ['ch.2',    SEASONS],
    ['ch.cup',  SEASONS],
 
    ['de.1',         SEASONS],
    ['de.2',         SEASONS],
    ['de.3',         SEASONS],
    ['de.4.bayern',  SEASONS],
    ['de.cup',       SEASONS],
]


datasets.each_with_index do |(league, seasons), i|
   ## Worldfootball.schedule( league: league, season: season )
   puts "==> #{i+1}/#{datasets.size} #{league}  #{seasons.size} season(s)..."
   seasons.each do |season|
     Worldfootball.convert( league: league, season: season )
   end
end


puts "bye"