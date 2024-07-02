##########
#  to run use:
#    $ ruby sandbox/test_generate.rb

require_relative 'helper'



g = Footballdata::Generator.new


# Footballdata.schedule( league: 'eng.1', season: '2024/25' )
# Footballdata.schedule( league: 'de.1', season: '2023/24' )

###
## use ./tmp for now
Webcache.root = './tmp2/cache'  ## auto-adds address/domain from url
Footballdata.config.convert.out_dir = './tmp2/stage/api.football-data.org'
Writer.config.out_dir = './tmp2'


# g.generate( league: 'eng.1', season: '2024/25' )
# g.generate( league: 'eng.1', season: '2023/24' )
g.generate( league: 'de.1', season: '2023/24' )

puts "bye"