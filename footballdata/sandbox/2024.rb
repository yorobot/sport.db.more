require_relative 'helper'

pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"


__END__

# Footballdata.schedule( league: 'world', season: '2022' ) ## world cup 2022 
# world cup 2018 not available with free tier

# Footballdata.schedule( league: 'euro',  season: '2024' ) ## euro 2024 
# Footballdata.schedule( league: 'euro',  season: '2021' ) ## euro 2021 (2020) 
# euro 2016 not available with free tier

# Footballdata.schedule( league: 'uefa.cl', season: '2023/24' )  ## 2023/24!! use start year 
# Footballdata.schedule( league: 'uefa.cl', season: '2022/23' )  
# Footballdata.schedule( league: 'uefa.cl', season: '2021/22' )  
# Footballdata.schedule( league: 'uefa.cl', season: '2020/21' )  
# uefa cl 2019/20 not available with free tree  

# Footballdata.schedule( league: 'copa.l',  season: '2024' )
# Footballdata.schedule( league: 'copa.l',  season: '2023' )



## 1 national league (year season )
# Footballdata.schedule( league: 'br.1',  season: '2024' )

## 8 nation leagues (academic season)
leagues = ['eng.1', 'eng.2',
            'es.1',
            'de.1',
            'fr.1',
            'it.1',
            'pt.1',
            'nl.1',
          ]
pp leagues

season = '2023/24'
leagues.each do |league|
  Footballdata.schedule( league: league,  season: season )
  # Footballdata.schedule( league: league,  season: '2022/23' )
  # Footballdata.schedule( league: league,  season: '2021/22' )
  # Footballdata.schedule( league: league,  season: '2020/21' )
end

# Footballdata.schedule( league: 'eng.1',  season: '2022/23' )
# Footballdata.schedule( league: 'eng.1',  season: '2021/22' )
# Footballdata.schedule( league: 'eng.1',  season: '2020/21' )
#   2019/20  - not available with free tier

