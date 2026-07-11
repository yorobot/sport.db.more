###
#  to run use:
#   $ ruby sandbox/convert_json.rb

require_relative 'helper'



Footballdata::convert_json( league: 'world', season: '2026' )

Footballdata::convert_json( league: 'eng.1', season: '2025/26' )
Footballdata::convert_json( league: 'eng.1', season: '2026/27' )

Footballdata::convert_json( league: 'uefa.cl', season: '2025/26' )

Footballdata::convert_json( league: 'copa.l',  season: '2026' )
Footballdata::convert_json( league: 'copa.l',  season: '2024' )


puts "bye"