$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'footballdata'


Webcache.root = '../../../cache'  ### c:\sports\cache


pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"


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
  sleep( 15 )  ## 15sec pause
end

# Footballdata.schedule( league: 'eng.1',  season: '2022/23' )
# Footballdata.schedule( league: 'eng.1',  season: '2021/22' )
# Footballdata.schedule( league: 'eng.1',  season: '2020/21' )
#   2019/20  - not available with free tier


__END__


Competition type
LEAGUE | LEAGUE_CUP | CUP | PLAYOFFS

Team type
CLUB | NATIONAL

Match status

SCHEDULED | TIMED | IN_PLAY | PAUSED | 
EXTRA_TIME | PENALTY_SHOOTOUT | FINISHED | 
SUSPENDED | POSTPONED | CANCELLED | AWARDED

status		The status of a match. 
[ SCHEDULED | LIVE | IN_PLAY | PAUSED | 
  FINISHED | POSTPONED | SUSPENDED | CANCELLED]

Match stage
  
FINAL | THIRD_PLACE | SEMI_FINALS | QUARTER_FINALS | 
LAST_16 | LAST_32 | LAST_64 | 
ROUND_4 | ROUND_3 | ROUND_2 | ROUND_1 | 
GROUP_STAGE | 
PRELIMINARY_ROUND | 
QUALIFICATION | QUALIFICATION_ROUND_1 | QUALIFICATION_ROUND_2 | QUALIFICATION_ROUND_3 | 
PLAYOFF_ROUND_1 | PLAYOFF_ROUND_2 | PLAYOFFS | 
REGULAR_SEASON | 
CLAUSURA | APERTURA | 
CHAMPIONSHIP | RELEGATION | RELEGATION_ROUND

stage	
FINAL | THIRD_PLACE | SEMI_FINALS | QUARTER_FINALS | 
LAST_16 | LAST_32 | LAST_64 | 
ROUND_4 | ROUND_3 | ROUND_2 | ROUND_1 | 
GROUP_STAGE | 
PRELIMINARY_ROUND | 
QUALIFICATION | QUALIFICATION_ROUND_1 | QUALIFICATION_ROUND_2 | QUALIFICATION_ROUND_3 | 
PLAYOFF_ROUND_1 | PLAYOFF_ROUND_2 | PLAYOFFS | 
REGULAR_SEASON | 
CLAUSURA | APERTURA | 
CHAMPIONSHIP | RELEGATION | RELEGATION_ROUND


Match group
GROUP_A | GROUP_B | GROUP_C | GROUP_D | 
GROUP_E | GROUP_F | GROUP_G | GROUP_H | 
GROUP_I | GROUP_J | GROUP_K | GROUP_L

Penalty type
MATCH | SHOOTOUT

Score duration
REGULAR | EXTRA_TIME | PENALTY_SHOOTOUT

Card type
YELLOW | YELLOW_RED | RED

Goal type
REGULAR | OWN | PENALTY


## Fbref.schedule( league: 'at.1', season: '2020/21' )

## Worldfootball.schedule( league: 'at.1', season: '2020/21' )
## Worldfootball.schedule( league: 'at.1', season: '2019/20' )

## Footballdata.schedule( league: 'eng.1', season: '2023/24' )



# Footballdata::MetalV4.competitions

## try euro - EC
# Footballdata::MetalV4.teams( 'EC', 2024 )  
## Footballdata::MetalV4.matches( 'EC', 2024 )  


## tryp england premier league - pl
# Footballdata::MetalV4.teams( 'PL', 2023 )  # 2023/24
# Footballdata::MetalV4.matches( 'PL', 2023 )  # 2023/24

# Footballdata::MetalV4.standings( 'PL', 2023 )  # 2023/24


# Footballdata::MetalV4.matches( 435956 )  

puts "bye"