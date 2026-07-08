
require_relative 'helper'


###
#  get matches and stages per season

pp  Fifa._idSeason_by_year!( name: 'eng', season: '2025-26' )


prepare( name:    'eng',
         seasons: ['2025-26'],
         outdir:  '.' )   ## note - autoadd slug (name) e..g ./eng !!

puts "bye"
