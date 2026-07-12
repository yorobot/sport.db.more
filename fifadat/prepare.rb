
require_relative 'helper'


###
#  get matches and stages per season

pp  Fifa._idSeason_by_year!( name: 'copa.l', season: '2026' )


prepare( name:    'copa.l',
         seasons: ['2026'],
         outdir:  '/sports/cache.api.fifadat' )    ## note - autoadd slug (name) e..g ./eng !!

puts "bye"
