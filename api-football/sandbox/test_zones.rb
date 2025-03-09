### check timezones for leagues

require_relative 'helper'




leagues = [
  ################
  ## clubs
  ['copa.l',       ['2023'  ]],
  ['copa.s',       ['2023'  ]], 
  ['uefa.cl',      ['2023/24']],
  ['uefa.el',      ['2023/24']],
  ['uefa.conf',    ['2023/24']],

  ['be.1',          ['2023/24']], 
  ['be.2',          ['2023/24']], 
  ['be.cup',          ['2023/24']], 

  ['cz.1',          ['2023/24']], 
  ['hu.1',          ['2023/24']], 


  ['jp.1',    ['2023'] ],
  ['jp.cup',  ['2023'] ],
  ['cn.1',    ['2023'] ],

  ['au.1',    ['2023/24'] ],
 
  ['br.1',  ['2023'] ],
  ['br.cup',  ['2023'] ],
  ['ar.1',  ['2023'] ],
  ['ar.cup',  ['2023'] ],

  ['at.1',         ['2023/24']],
  ['at.2',         ['2023/24']],
  ['at.cup',       ['2023/24']],
  ['be.1',          ['2023/24']], 
  ['eng.1',         ['2023/24']], 
  ['eng.fa.cup',   ['2023/24']],

  ['mx.1',         ['2022/23','2023/24']], 
  ['mls',          ['2021', '2022', '2023'  ]],

  #########
  ## internationals  (national teams)
  ['uefa.nl',      ['2022'] ],
  ['southamerica', ['2021'] ],
  ['world',        ['2022'] ],    
]



leagues.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season,j|
      puts "==> #{i+1} | #{league} #{j+1}/#{seasons.size}"
 
      zone = find_zone!( league: league, season: season )
      pp zone
      puts "  #{zone.name} -- #{zone.now}"
   end
end



puts "bye"