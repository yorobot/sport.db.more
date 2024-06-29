require_relative 'helper'



['eng.1', 'eng.2',
 'de.1',
 'es.1',
 'fr.1',
 'it.1',
 'nl.1',
 'pt.1',
 'uefa.cl',
].each do |league|
  season = '2023/24'
  puts "==> #{league} #{season}"
  Footballdata.export_teams( league: league, season: season )
end

## season with calendar year (NOT academic)
[ 'copa.l', 
  'br.1'
].each do |league|
  season = '2024'
  puts "==> #{league} #{season}"
  Footballdata.export_teams( league: league, season: season )
end

puts 'bye'
