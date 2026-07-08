
require_relative 'helper'


###
#  get matches and stages per season

pp  Fifa._idSeason_by_year!( name: 'at', season: '2025-26' )


prepare( name:    'at',
         seasons: ['2025-26'],
         outdir:  '.' )   ## note - autoadd slug (name) e..g ./at !!

puts "bye"
