require_relative 'helper'



# Footballdata.schedule( league: 'eng.1', season: '2024/25' )
# Footballdata.schedule( league: 'de.1', season: '2023/24' )


puts "==> eng.1"
Footballdata.convert_csv( league: 'eng.1', season: '2025/26' )
Footballdata.convert_csv( league: 'eng.1', season: '2024/25' )

puts "==> de.1"
Footballdata.convert_csv( league: 'de.1', season: '2024/25' )

puts "==> uefa.cl"
Footballdata.convert_csv( league: 'uefa.cl', season: '2024/25' )

puts "==> world"
## Footballdata.convert_csv( league: 'world', season: '2022' )
## Footballdata.convert_csv( league: 'world', season: '2026' )

puts "bye"