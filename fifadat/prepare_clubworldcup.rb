
require_relative 'helper'

require_relative 'prepare'


seasons = [2025]
outdir  = "."

prepare( name: 'clubworldcup',
         seasons: seasons,
         outdir:  outdir )

puts "bye"



