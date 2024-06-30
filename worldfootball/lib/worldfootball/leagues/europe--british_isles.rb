
module Worldfootball


LEAGUES_EUROPE.merge!({


   # /eng-national-league-2020-2021/
  'eng.1'     => { pages: 'eng-premier-league' },
  'eng.2'     => { pages: 'eng-championship' },
  'eng.3'     => { pages: 'eng-league-one' },
  'eng.4'     => { pages: 'eng-league-two' },
  'eng.5'     => { pages: 'eng-national-league' },
  'eng.cup'   => { pages: 'eng-fa-cup' },    ## change key to eng.cup.fa or such??
  'eng.cup.l' => { pages: 'eng-league-cup' }, ## change key to ??

  'sco.1' => {
    pages: {
      'sco-premiership-{season}'           => 'Regular Season',
      'sco-premiership-{end_year}-playoff' => 'Playoffs - Championship',  # note: only uses season.end_year!
      'sco-premiership-{end_year}-abstieg' => 'Playoffs - Relegation',    # note: only uses season.end_year!
    },
    season: ->( season ) {
      case season
      when Season('2020/21') then [1]     # just getting started
      when Season('2019/20') then [1]     # covid-19 - no championship & relegation
      when Season('2018/19') then [1,2,3]
      end
   }
  },

   # e.g. /irl-premier-division-2019/
   # irl-premier-division-2020
   # irl-premier-division-2019
   # irl-premier-division-2018
   # irl-premier-division-2017
   # irl-premier-division-2016
   # irl-premier-division-2015
   # irl-premier-division-2014
   # irl-premier-division-2013
   # irl-airtricity-league-2012
   # irl-airtricity-league-2011
   # irl-airtricity-league-2010

  'ie.1'  => {
    pages: [
      'irl-premier-division',
      'irl-airtricity-league'],
    season: ->( season ) {
      case season
      when Season('2013')..Season('2020') then 1
      when Season('2010')..Season('2012') then 2
    end
   }
  },
})

end

