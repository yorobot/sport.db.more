##################
# to run use:
#    ruby upquick\up.rb



require_relative 'helper'


# Worldfootball.config.convert.out_dir     = './o'


LEAGUES = [
  ['eng.1', [Season('1998/99')]],
]

pp LEAGUES



### convert
=begin
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
=end


Worldfootball.convert( league: 'eng.1',
                       season: '1998/99',
                       offset: Worldfootball::OFFSETS[ 'eng.1' ] )


__END__


### write

# Writer.config.out_dir = "#{SportDb::Boot.root}/openfootball"
Writer.config.out_dir = './tmp'


Writer.write( 'eng.1', '1998/99',
              source: Worldfootball.config.convert.out_dir,
              extra: 'archive/1990s' )

=begin
LEAGUES.each do |item|
  league  = item[0]
  seasons = item[1]
  seasons.each do |season|
    puts "#{league} #{season}:"

    Writer.write( league, season,
                  source: Worldfootball.config.convert.out_dir )
  end
end
=end

puts "bye"
