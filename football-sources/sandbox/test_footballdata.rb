require 'football/sources'


#############
## download up (ongoing) 2020 or 2020/21 seasons


Webget.config.sleep  = 10

Footballdata.schedule( league: 'eng.1', season: '2020/21' )
Footballdata.schedule( league: 'eng.2', season: '2020/21' )

Footballdata.schedule( league: 'de.1', season: '2020/21' )
Footballdata.schedule( league: 'es.1', season: '2020/21' )

Footballdata.schedule( league: 'fr.1', season: '2020/21' )
Footballdata.schedule( league: 'it.1', season: '2020/21' )

Footballdata.schedule( league: 'nl.1', season: '2020/21' )
Footballdata.schedule( league: 'pt.1', season: '2020/21' )

Footballdata.schedule( league: 'cl',   season: '2020/21' )

# note: Brasileirão - season is a calendar year (NOT an academic year)
Footballdata.schedule( league: 'br.1', season: '2020' )



['eng.1', 'eng.2',
 'de.1',
 'es.1',
 'fr.1',
 'it.1',
 'nl.1',
 'pt.1',
 'cl',
].each do |league|
  Footballdata.convert( league: league, season: '2020/21' )
end

Footballdata.convert( league: 'br.1', season: '2020' )


puts 'bye'