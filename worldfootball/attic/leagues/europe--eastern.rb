
module Worldfootball

LEAGUES_EUROPE.merge!({

  # /rou-liga-1-2019-2020
  # /rou-liga-1-2019-2020-championship
  # /rou-liga-1-2019-2020-relegation
  # ..
  # /rom-liga-1-2015-2016
  # /rom-liga-1-2015-2016-championship
  # /rou-liga-1-2015-2016-relegation


  'ro.1' => {
    pages: {
     'rou-liga-1-{season}'               => 'Regular Season',
     'rou-liga-1-{season}-championship'  => 'Playoffs - Championship',
     'rou-liga-1-{season}-relegation'    => 'Playoffs - Relegation',
     ## note: change of country code from rou to rom in slug in 2015/16!!!
     'rom-liga-1-{season}'               => 'Regular Season',
     'rom-liga-1-{season}-championship'  => 'Playoffs - Championship',
     'rom-liga-1-{season}-relegation'    => 'Playoffs - Relegation',
    },
    season: ->( season ) {
     case season
     when Season('2020/21') then [1]  # just getting started
     when Season('2016/17')..Season('2019/20') then [1,2,3]
     when Season('2015/16') then [4,5,3]  # handle special case with weird mixed slugs
     when Season('2010/11')..Season('2014/15') then 4   ## use simple format for the rest; note: index NOT wrapped in array
     end
    }
  },

  #   rus-premier-liga-2020-2021
  #   ..
  #   rus-premier-liga-2012-2013
  #
  #   rus-premier-liga-2011-2012
  #   rus-premier-liga-2011-2012-meisterschaft
  #   rus-premier-liga-2011-2012-relegation
  #
  #   rus-premier-liga-2010
  'ru.1'  => {
    pages: {
     'rus-premier-liga-{season}'                => 'Regular Season',
     'rus-premier-liga-{season}-meisterschaft'  => 'Playoffs - Championship',
     'rus-premier-liga-{season}-relegation'     => 'Playoffs - Relegation',
    },
    season: ->( season ) {
     case season
     when Season('2012/13')..Season('2020/21') then 1   ## use simple format for the rest; note: index NOT wrapped in array
     when Season('2011/12') then [1,2,3]
     when Season('2004')..Season('2010') then 1         ## use simple format for the rest; note: index NOT wrapped in array
     end
    }
  },
  'ru.2'  => { pages: 'rus-1-division' },

  # /ukr-premyer-liga-2019-2020/
  # /ukr-premyer-liga-2019-2020-meisterschaft/
  # /ukr-premyer-liga-2019-2020-abstieg/
  # /ukr-premyer-liga-2019-2020-playoffs-el/
  'ua.1'  => {
    pages: {
     'ukr-premyer-liga-{season}'               => 'Regular Season',
     'ukr-premyer-liga-{season}-meisterschaft' => 'Playoffs - Championship',
     'ukr-premyer-liga-{season}-abstieg'       => 'Playoffs - Relegation',
     'ukr-premyer-liga-{season}-playoffs-el'   => 'Europa League Finals',
   },
   season: ->( season ) {
    case season
    when Season('2019/20') then [1,2,3,4]
    when Season('2018/19') then [1,2,3]    # note: no europa league finals / playoffs
    end
   }
  },

})

end

