
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


=begin
- fix 
[cache] saving ./cache/v3.football.api-sports.io/fixtures-I-league~147~~season~2021.json...
{"get"=>"fixtures",
 "parameters"=>{"league"=>"147", "season"=>"2021"},
 "errors"=>
  {"rateLimit"=>
    "Too many requests. Your rate limit is 10 requests per minute."},

{
  "get": "fixtures",
  "parameters": {
    "league": "147",
    "season": "2021"
  },
  "errors": {
    "rateLimit": "Too many requests. Your rate limit is 10 requests per minute."
  },
  "results": 0,
  "paging": {
    "current": 1,
    "total": 1
  },
  "response": [

  ]
}
-- do NOT save/cache (response) on error!!!
=end


leagues = [
 ##############  
 ## internationals (national teams)
  ['world',        ['2022'] ], 
  ##  - check for Time to be defined
  ## ['friendlies',   ['2021', '2022', '2023'] ],   
  ['uefa.nl',      ['2022'] ],     # uefa nations league
  ['southamerica', ['2021'] ],     # comebol copa america

  ## todo/fix - add timezones for africa and asia !!!
  ## ['africa',       ['2021', '2023']],  # Africa Cup of Nations
  ## ['asia',         ['2023']],          # asian cup


 ########
 ##  clubs
 ## -- europe 
  ['de.1',         ['2021/22','2022/23','2023/24']],
  ['de.2',         ['2021/22','2022/23','2023/24']],
  ['de.cup',       ['2021/22','2022/23','2023/24']],

  ['at.1',         ['2021/22','2022/23','2023/24']],
  ['at.2',         ['2021/22','2022/23','2023/24']],
  ['at.cup',       ['2021/22','2022/23','2023/24']],

  ['cz.1',          ['2021/22','2022/23','2023/24']], 
  ['hu.1',          ['2021/22','2022/23','2023/24']], 

  ['be.1',          ['2021/22','2022/23','2023/24']], 
  ['be.2',          ['2021/22','2022/23','2023/24']], 
  ['be.cup',        ['2021/22','2022/23','2023/24']], 


  ['eng.1',         ['2021/22','2022/23','2023/24']], 
  ['eng.fa.cup',    ['2021/22','2022/23','2023/24']],

  ['uefa.cl',      ['2021/22', '2022/23', '2023/24']],
  ['uefa.el',      ['2021/22', '2022/23', '2023/24']],
  ['uefa.conf',    ['2021/22', '2022/23', '2023/24']],


## -- north (& central) america  
  ['mx.1',         ['2021/22', '2022/23','2023/24']], 
  ['mls',          ['2021', '2022', '2023'  ]],
## -- south america
  ['br.1',    ['2021', '2022','2023'] ],
  ['br.cup',  ['2023'] ],
  ['ar.1',    ['2021', '2022','2023'] ],
  ['ar.cup',  ['2023'] ],

  ['copa.l',       ['2021', '2022', '2023']],
  ['copa.s',       ['2021', '2022', '2023']], 
## -- asia
  ['jp.1',    ['2021', '2022', '2023'] ],
  ['jp.cup',  ['2021', '2022', '2023'] ],
  ['cn.1',    ['2021', '2022', '2023'] ],

## -- ozeania & australia
  ['au.1',    ['2021/22', '2022/23', '2023/24'] ],
]




# outdir = './o'
outdir = '/sports/openfootball/world.more'


ApiFootball.build( leagues, outdir: outdir )

puts "bye"


