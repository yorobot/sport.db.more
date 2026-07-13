
require_relative 'helper'


###
#  get matches and stages per season

outdir = '/sports/cache.fifadat'



pp  Fifa._idSeason_by!( name: 'mx', season: '2021/22' )

prepare( name:    'mx',
         seasons: ['2021/22'],
         outdir:  outdir )    ## note - autoadd slug (name) e..g ./eng !!

puts "bye"
