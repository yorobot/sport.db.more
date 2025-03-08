
require_relative 'helper'


###
##  note - season start_year NOT always same as api season year!!!!!!
##    make a debug/lint list - why? why not?


###
##  todo/check
###   use teams/
##      if fa cup  is england and wales
##      if mls     is united states  and canada!!!
##       



leagues = [
  ['copa.l',       ['2023'  ]],
  ['copa.s',       ['2023'  ]], 
  ['uefa.cl',      ['2023/24']],
  ['uefa.el',      ['2023/24']],
  ['uefa.conf',    ['2023/24']],
]



leagues.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season,j|
      puts "==> #{i+1} | #{league} #{j+1}/#{seasons.size}"
      buf = ApiFootball.build_fixtures( league: league, season: season ) 
      puts buf

      season = Season( season )
      path = "./o/#{season.to_path}/#{league}.txt"
      write_txt( path, buf )
   end
end



puts "bye"


