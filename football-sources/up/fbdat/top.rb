
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

## plus add int'l cups
##    uefa.cl, copa.l  
##
## plus cups with national teams!!!
##    euro, southamerica (copa america)



# datasets = DATASETS_MORE + DATASETS_TOP
DATASETS = DATASETS_TOP

