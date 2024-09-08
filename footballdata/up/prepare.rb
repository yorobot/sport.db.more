############
# to run use:
#    $ ruby up/prepare.rb


require_relative 'helper'   ## (shared) boot helper



require_relative 'datasets'   ## shared datasets


#########
# download latest

# Footballdata.schedule( league: 'eng.1', season: '2023/24' )
# Footballdata.schedule( league: 'eng.2', season: '2023/24' )
# Footballdata.schedule( league: 'eng.2', season: '2022/23' )
# Footballdata.schedule( league: 'eng.2', season: '2021/22' )
# Footballdata.schedule( league: 'eng.2', season: '2020/21' )

# Footballdata.schedule( league: 'de.1',  season: '2023/24' )
# Footballdata.schedule( league: 'fr.1',  season: '2023/24' )

# note:  it.1 2023/2024 ends jul/2 !!!
# Footballdata.schedule( league: 'it.1',  season: '2023/24' )

# note: es.1 2023/2024 end may/26 !!!
# Footballdata.schedule( league: 'es.1',  season: '2023/24' )

# Footballdata.schedule( league: 'pt.1',  season: '2023/24' )
# Footballdata.schedule( league: 'nl.1',  season: '2023/24' )

# Footballdata.schedule( league: 'br.1',  season: '2024' )
# Footballdata.schedule( league: 'br.1',  season: '2023' )
# Footballdata.schedule( league: 'br.1',  season: '2022' )
# Footballdata.schedule( league: 'br.1',  season: '2021' )
# Footballdata.schedule( league: 'br.1',  season: '2020' )


#####
# convert for staging


datasets = DATASETS_TOP + DATASETS_MORE
datasets.each do |league, seasons|
  seasons.each_with_index do |season,i|
    puts "==> #{league} #{season} - #{i+1}/#{seasons.size}..."
    Footballdata.convert( league: league, season: season )
  end
end



puts "bye"

