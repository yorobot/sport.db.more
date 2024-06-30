require_relative 'helper'

Webcache.config.root = '../../cache'

Worldfootball.config.convert.out_dir     = './o'


LEAGUES = [
# ['mx.1', (Season('2010/11')..Season('2019/20')).to_a],
# ['ro.1', (Season('2010/11')..Season('2019/20')).to_a],
# ['ru.1', (Season('2004')..Season('2010')).to_a +
#          (Season('2011/12')..Season('2020/21')).to_a],

# ['nl.1', (Season('2010/11')..Season('2019/20')).to_a],
# ['pt.1', (Season('2010/11')..Season('2019/20')).to_a],

# ['gr.1', (Season('2010/11')..Season('2019/20')).to_a],
# ['tr.1', (Season('2012/13')..Season('2019/20')).to_a],
# ['ch.1', (Season('2010/11')..Season('2019/20')).to_a],

  ['ie.1', (Season('2010')..Season('2020')).to_a],
]

pp LEAGUES




### convert
LEAGUES.each do |item|
  league  = item[0]
  seasons = item[1]
  seasons.each do |season|
    puts "#{league} #{season}:"

    Worldfootball.convert( league: league,
                           season: season,
                           offset: Worldfootball::OFFSETS[ league ] )

   end
end


### write

# Writer.config.out_dir = "#{SportDb::Boot.root}/openfootball"
Writer.config.out_dir = './tmp'

LEAGUES.each do |item|
  league  = item[0]
  seasons = item[1]
  seasons.each do |season|
    puts "#{league} #{season}:"

    Writer.write( league, season,
                  source: Worldfootball.config.convert.out_dir )
  end
end


puts "bye"
