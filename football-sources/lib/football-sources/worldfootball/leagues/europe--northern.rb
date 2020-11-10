
module Worldfootball

LEAGUES_EUROPE.merge!({
  # e.g. /isl-urvalsdeild-2020/
  'is.1'  => { pages: 'isl-urvalsdeild' },

  # e.g. /swe-allsvenskan-2020/
  #      /swe-superettan-2020/
  'se.1'  => { pages: 'swe-allsvenskan' },
  'se.2'  => { pages: 'swe-superettan' },

  # e.g. /nor-eliteserien-2020/
  'no.1'  => { pages: 'nor-eliteserien' },

  # e.g. /fin-veikkausliiga-2019/
  #      /fin-veikkausliiga-2019-meisterschaft/
  #      /fin-veikkausliiga-2019-abstieg/
  #      /fin-veikkausliiga-2019-playoff-el/
  'fi.1' => {
    pages: {
      'fin-veikkausliiga-{season}'               => 'Regular Season',
      'fin-veikkausliiga-{season}-meisterschaft' => 'Playoffs - Championship',
      'fin-veikkausliiga-{season}-abstieg'       => 'Playoffs - Challenger',
      'fin-veikkausliiga-{season}-playoff-el'    => 'Europa League Finals',
    },
    season: ->( season ) {
     case season
     when Season('2020') then [1]    # just getting started
     when Season('2019') then [1,2,3,4]
     end
    }
  },

  # /den-superliga-2020-2021/
  # /den-superliga-2019-2020-meisterschaft/
  # /den-superliga-2019-2020-abstieg/
  # /den-superliga-2019-2020-europa-league/
  'dk.1'  => {
    pages: {
      'den-superliga-{season}'               => 'Regular Season',
      'den-superliga-{season}-meisterschaft' => 'Playoffs - Championship',
      'den-superliga-{season}-abstieg'       => 'Playoffs - Relegation',
      'den-superliga-{season}-europa-league' => 'Europa League Finals',
   },
   season: ->( season ) {
     case season
     when Season('2020/21') then [1]     # just getting started
     when Season('2019/20') then [1,2,3,4]
     when Season('2018/19') then [1,2,3,4]
     end
   }
  },

})

end
