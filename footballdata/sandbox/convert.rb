require_relative 'helper'



# Footballdata.schedule( league: 'eng.1', season: '2024/25' )
# Footballdata.schedule( league: 'de.1', season: '2023/24' )


puts "==> eng.1"
Footballdata.convert( league: 'eng.1', season: '2023/24' )
Footballdata.convert( league: 'eng.1', season: '2024/25' )

puts "==> de.1 2023/24"
Footballdata.convert( league: 'de.1', season: '2023/24' )

# puts "==> uefa.cl 2023/24"
# Footballdata.convert( league: 'uefa.cl', season: '2023/24' )

puts "bye"