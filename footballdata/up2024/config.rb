##########
##  webcache settings
Webcache.root = '../../../../cache'  
#=> /sports/cache

Webget.config.sleep  = 11    ## max. 10 requests/minute


#########
##  staging cache settings
Footballdata.config.convert.out_dir = '../../../../stage'

pp File.expand_path( Footballdata.config.convert.out_dir )
#=> /sports/stage


#########
##  datasets


## use LATEST_SEASONS or such - why? why not?
SEASONS = %w[2023/24 2022/23 2021/22 2020/21]

DATASETS_TOP = [
 ['eng.1',   SEASONS + %w[2024/25]],  
 ['de.1',    SEASONS],
 ['es.1',    SEASONS],
 ['it.1',    SEASONS],
 ['fr.1',    SEASONS],
]


DATASETS_MORE = [
  ['eng.2', SEASONS],
  ['pt.1',  SEASONS],
  ['nl.1',  SEASONS],
  ['br.1', %w[2024 2023 2022 2021 2020]],
]






