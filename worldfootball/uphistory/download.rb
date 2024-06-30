require_relative '../cache.weltfussball/lib/convert'


Webcache.config.root = '../../cache'


Worldfootball.config.sleep = 3


IE = %w[
  irl-premier-division-2020
  irl-premier-division-2019
  irl-premier-division-2018
  irl-premier-division-2017
  irl-premier-division-2016
  irl-premier-division-2015
  irl-premier-division-2014
  irl-premier-division-2013
  irl-airtricity-league-2012
  irl-airtricity-league-2011
  irl-airtricity-league-2010
]


GR = %w[
  gre-super-league-2020-2021

  gre-superleague-2019-2020
  gre-super-league-2019-2020-meisterschaft
  gre-super-league-2019-2020-abstieg

  gre-superleague-2018-2019
  gre-superleague-2017-2018

  gre-superleague-2016-2017
  gre-superleague-2017-playoffs

  gre-superleague-2015-2016
  gre-superleague-2016-playoffs

  gre-superleague-2014-2015
  gre-superleague-2015-playoffs

  gre-superleague-2013-2014
  gre-superleague-2014-playoffs

  gre-superleague-2012-2013
  gre-superleague-2013-playoffs
  gre-superleague-2013-spiel-um-platz-6

  gre-superleague-2011-2012
  gre-superleague-2012-playoffs

  gre-superleague-2010-2011
  gre-superleague-2011-playoffs
]



TR = %w[
  tur-sueperlig-2020-2021
  tur-sueperlig-2019-2020
  tur-sueperlig-2018-2019
  tur-sueperlig-2017-2018
  tur-sueperlig-2016-2017
  tur-sueperlig-2015-2016
  tur-sueperlig-2014-2015
  tur-sueperlig-2013-2014
  tur-sueperlig-2012-2013
]
## note: start with 2012/13 for now!!!
## in 2011/12 a new format was introduced, in which after the regular season
##  two play-off groups were played to decide over the Champions League and Europa League starting rounds
## 1)  - tur-sueperlig-2011-2012
## 2a) - tur-sueperlig-2012-meisterschaft  -- 2012 Meisterschaft
## 2b) - tur-sueperlig-2012-platzierung    -- 2012 Platzierung


CH = %w[
  sui-super-league-2020-2021
  sui-super-league-2019-2020
  sui-super-league-2018-2019
  sui-super-league-2017-2018
  sui-super-league-2016-2017
  sui-super-league-2015-2016
  sui-super-league-2014-2015
  sui-super-league-2013-2014
  sui-super-league-2012-2013
  sui-super-league-2011-2012
  sui-super-league-2010-2011
]


PT = %w[
  por-primeira-liga-2020-2021
  por-primeira-liga-2019-2020
  por-primeira-liga-2018-2019
  por-primeira-liga-2017-2018
  por-primeira-liga-2016-2017
  por-primeira-liga-2015-2016
  por-primeira-liga-2014-2015
  por-primeira-liga-2013-2014
  por-liga-zon-sagres-2012-2013
  por-liga-zon-sagres-2011-2012
  por-liga-sagres-2010-2011
]


NL = %w[
  ned-eredivisie-2020-2021
  ned-eredivisie-2019-2020
  ned-eredivisie-2018-2019
  ned-eredivisie-2017-2018
  ned-eredivisie-2016-2017
  ned-eredivisie-2015-2016
  ned-eredivisie-2014-2015
  ned-eredivisie-2013-2014
  ned-eredivisie-2012-2013
  ned-eredivisie-2011-2012
  ned-eredivisie-2010-2011
]


##
## note: ru - special (transition) league format for season 2011/12 (lasting 18 month!!)
#  1)  rus-premier-liga-2011-2012/     -- 30 rounds
#  2a) rus-premier-liga-2011-2012-meisterschaft/  -- 2011/2012 Meisterschaft (rounds 31 to 44)
#   b) rus-premier-liga-2011-2012-relegation/     -- 2011/2012 Relegation    (rounds 31 to 44)


RU = %w[
  rus-premier-liga-2020-2021
  rus-premier-liga-2019-2020
  rus-premier-liga-2018-2019
  rus-premier-liga-2017-2018
  rus-premier-liga-2016-2017
  rus-premier-liga-2015-2016
  rus-premier-liga-2014-2015
  rus-premier-liga-2013-2014
  rus-premier-liga-2012-2013

  rus-premier-liga-2011-2012
  rus-premier-liga-2011-2012-meisterschaft
  rus-premier-liga-2011-2012-relegation

  rus-premier-liga-2010
  rus-premier-liga-2009
  rus-premier-liga-2008
  rus-premier-liga-2007
  rus-premier-liga-2006
  rus-premier-liga-2005
  rus-premier-liga-2004
]


RO = %w[
rou-liga-1-2020-2021

rou-liga-1-2019-2020
rou-liga-1-2019-2020-championship
rou-liga-1-2019-2020-relegation

rou-liga-1-2018-2019
rou-liga-1-2018-2019-championship
rou-liga-1-2018-2019-relegation

rou-liga-1-2017-2018
rou-liga-1-2017-2018-championship
rou-liga-1-2017-2018-relegation

rou-liga-1-2016-2017
rou-liga-1-2016-2017-championship
rou-liga-1-2016-2017-relegation

rom-liga-1-2015-2016
rom-liga-1-2015-2016-championship
rou-liga-1-2015-2016-relegation

rom-liga-1-2014-2015
rom-liga-1-2013-2014
rom-liga-1-2012-2013
rom-liga-1-2011-2012
rom-liga-1-2010-2011
]


MX = %w[
 mex-primera-division-2020-2021-apertura

 mex-primera-division-2019-2020-apertura
 mex-primera-division-2019-2020-apertura-playoffs
 mex-primera-division-2019-2020-clausura

 mex-primera-division-2018-2019-apertura
 mex-primera-division-2018-2019-apertura-playoffs
 mex-primera-division-2018-2019-clausura
 mex-primera-division-2018-2019-clausura-playoffs

 mex-primera-division-2017-2018-apertura
 mex-primera-division-2017-2018-apertura-playoffs
 mex-primera-division-2017-2018-clausura
 mex-primera-division-2017-2018-clausura-playoffs

 mex-primera-division-2016-2017-apertura
 mex-primera-division-2016-2017-apertura-playoffs
 mex-primera-division-2016-2017-clausura
 mex-primera-division-2016-2017-clausura-playoffs

 mex-primera-division-2015-2016-apertura
 mex-primera-division-2015-2016-apertura-playoffs
 mex-primera-division-2015-2016-clausura
 mex-primera-division-2015-2016-clausura-playoffs

 mex-primera-division-2014-2015-apertura
 mex-primera-division-2014-2015-apertura-playoffs
 mex-primera-division-2014-2015-clausura
 mex-primera-division-2014-2015-clausura-playoffs

 mex-primera-division-2013-2014-apertura
 mex-primera-division-2013-2014-apertura-playoffs
 mex-primera-division-2013-2014-clausura
 mex-primera-division-2013-2014-clausura-playoffs

 mex-primera-division-2012-2013-apertura
 mex-primera-division-2012-2013-apertura-playoffs
 mex-primera-division-2012-2013-clausura
 mex-primera-division-2012-2013-clausura-playoffs

 mex-primera-division-2011-2012-apertura
 mex-primera-division-2011-2012-apertura-playoffs
 mex-primera-division-2011-2012-clausura
 mex-primera-division-2011-2012-clausura-playoffs

 mex-primera-division-2010-2011-apertura
 mex-primera-division-2010-2011-apertura-playoffs
 mex-primera-division-2010-2011-clausura
 mex-primera-division-2010-2011-clausura-playoffs
]


# SLUGS = MX
# SLUGS = RO
# SLUGS = RU
# SLUGS = PT
# SLUGS = CH
# SLUGS = TR
# SLUGS = GR
SLUGS = IE

SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}]>#{slug}<"
  Worldfootball::Metal.schedule( slug )
end


puts "bye"
