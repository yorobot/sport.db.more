require_relative 'helper'


## Worldfootball.convert( league: 'eng.1', season: '2023/24' )


league = 'de.cup'
season = '2023/24'

## Worldfootball.schedule( league: league, season: season )
Worldfootball.convert( league: league, season: season )



puts "bye"