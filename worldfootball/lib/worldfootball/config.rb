module Worldfootball

#################
# todo/fix -  use timezone instead of offset !!!
#  e.g
=begin
   TIMEZONES = {
  'eng.1' => 'Europe/London',
  'eng.2' => 'Europe/London',

  'es.1'  => 'Europe/Madrid',

  'de.1'  => 'Europe/Berlin',
  'fr.1'  => 'Europe/Paris',
  'it.1'  => 'Europe/Rome',
  'nl.1'  => 'Europe/Amsterdam',

  'pt.1'  => 'Europe/Lisbon',

  ## todo/fix - pt.1
  ##  one team in madeira!!! check for different timezone??
  ##  CD Nacional da Madeira

  'br.1'  => 'America/Sao_Paulo',
  ## todo/fix - brazil has 4 timezones
  ##           really only two in use for clubs
  ##             west and east (amazonas et al)
  ##           for now use west for all - why? why not?
}
=end

## todo - find "proper/classic" timezone ("winter time")

##  Brasilia - Distrito Federal, Brasil  (GMT-3)  -- summer time?
##  Ciudad de México, CDMX, México       (GMT-5)  -- summer time?
##  Londres, Reino Unido (GMT+1)
##   Madrid -- ?
##   Lisboa -- ?
##   Moskow -- ?
##
## todo/check - quick fix timezone offsets for leagues for now
##   - find something better - why? why not?
## note: assume time is in GMT/UTC+1  - PLUS SUMMERTIME!!!
##        todo/fix - consider summertime before conversion too!!!



##
##  fix - use timezone names  !!!!!!!!!!!!!!!!!
###   see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones


OFFSETS = {

  ## fix - change to gmt/utc offset
  ##        if offset == 1 (GMT/UTC+1)
  ##           do NOTHING (default date/timezone of pages)

  'eng' => 0,
 # 'eng.1' => 0,
 # 'eng.2' => 0,
 # 'eng.3' => 0,
 # 'eng.4' => 0,
 # 'eng.5' => 0,

  'ie'  =>  0,
  'sco' =>  0,

  'pt' => 0,
 # 'pt.1'  => 0,
 # 'pt.2'  => 0,

  'fi' => 2, # +2
  'gr' => 2, # +2
  'ro' =>  2, # +2
  'ua' =>  2, # +2

  'ru' =>  3,   # +3
  'tr'   => 3,  # +3 turkey time/moscow time


  'us'      => -5,   # (gmt-5) new york

  'mx'      => -6,
 # 'mx.1'    => -6,
 # 'mx.2'    => -6,
 # 'mx.3'    => -6,
 # 'mx.cup'  => -6,

  'cr' => -6,    # gmt-6
  'gt' => -6,    # gmt-6
  'hn' => -6,    # gmt-6
  'sv' => -6,    # gmt-6
  'ni' => -6,    # gmt-6

  'uy' =>  -3,     #   gmt-3
  'pe' =>  -5,     #  gmt-5
  'ec' =>  -5,     #  gmt-5
  'co' =>  -5,     #  gmt-5
  'bo' =>  -4,     #  gmt-4
  'cl' =>  -4,     #  gmt-4

  'br'  => -4,    # gmt-3  - change to -3?
 # 'br.1'  => -4,
  'ar'   => -4,   # gmt-3  - change to -3?
 # 'ar.1'  => -4,


  'eg' =>   3,  # +3  (gmt+3)

  'jp' =>   9,  # +9  (gmt+9)
  'kr' =>   9,     # use Asia/Seoul
  'cn' =>   7,  # +7  (gmt+7)


   ## note - central european time (cet) - no need for date auto-fix
   'at' => 1,
   'de' => 1,
   'ch' => 1,
   'hu' => 1,
    'cz' => 1,
    'sk' => 1,
    'pl' => 1,
    'nl' => 1,
    'lu' => 1,
    'be' => 1,
    'dk' => 1,
    'se' => 1,
    'it' => 1,
    'hr' => 1,   # check croatia is eastern
    'fr' => 1,
    'es' => 1,
    ##   see https://en.wikipedia.org/wiki/Time_in_Europe


  ################
  ## int'l tournaments
  # 'uefa.cl'
  # 'uefa.el'
  'uefa.cl'   => 1,
  'uefa.el'   => 1,

  'concacaf.cl'  => -6,   ### use mx time
  'copa.l'       => -4,    ### use brazil time
}


####
# config for slug to local basename / directories
#   e.g.
#     aut-bundesliga-2023-2024  =>  austria/2023-24/1_bundesliga.txt


## add (timezone) offset here too - why? why not?
LEAGUE_SETUPS  = {
  ## note - for now auto-generate  path via name (downcased)
  ##         e.g. Belgium => /belgium

  ## top five (europe)
  'eng' => { code: 'eng', name: 'England'  },
  'es'  =>  { code: 'esp', name: 'Spain' },
  # 'fr'  =>  { code: 'fra', name: 'France' },
  # 'de'  =>  { code: '???', name: 'Germany' },
  'it'  =>  { code: 'ita', name: 'Italy' },


  'be' =>  { code: 'bel', name: 'Belgium'   },
  'at' =>  { code: 'aut', name: 'Austria'   },
  'hu' =>  { code: 'hun', name: 'Hungary'   },

  'tr' =>  { code: 'tur', name: 'Turkey' },
  'nl' =>  { code: 'ned', name: 'Netherlands' },
  'ch' =>  { code: 'sui',  name: 'Switzerland' },


  'cz' =>  { code: 'cze', name: 'Czech Republic' },
  'dk' =>  { code: 'den', name: 'Denmark' },
  'fi' =>  { code: 'fin', name: 'Finland' },
  'gr' =>  { code: 'gre', name: 'Greece' },

  'ie' =>  { code: 'irl', name: 'Ireland' },
  'sco' =>  { code: 'sco', name: 'Scotland' },

  'lu' =>  { code: 'lux', name: 'Luxembourg' },
  'pl' =>  { code: 'pol', name: 'Poland' },
  'pt' =>  { code: 'por', name: 'Portugal' },
  'ro' =>  { code: 'rou', name: 'Romania' },
  'ru' =>  { code: 'rus', name: 'Russia' },
  'se' =>  { code: 'swe', name: 'Sweden' },
  'ua' =>  { code: 'ukr', name: 'Ukraine' },


  'eg' =>  { code: 'egy', name: 'Egypt' },
  'jp' =>  { code: 'jpn', name: 'Japan' },
  'cn' =>  { code: 'chn', name: 'China' },

  ## note - for now do NOT add United States to league name
  ##     e.g. 1   - Major League Soccer
  ##          2   - USL Championship
  ##          cup - U.S. Open Cup
  'us' =>  { code: 'usa', name: nil,  path: 'united-states' },

  'mx' =>  { code: 'mex', name: 'Mexico'    },
  'ar' =>  { code: 'arg', name: 'Argentina' },
  'br' =>  { code: 'bra', name: 'Brazil' },

   'uy' =>  { code: 'uru', name: 'Uruguay' },
  'pe' =>  { code: 'per', name: 'Peru' },
  'ec' =>  { code: 'ecu', name: 'Ecuador' },
  'bo' =>  { code: 'bol', name: 'Bolivia' },
  'cl' =>  { code: 'chi', name: 'Chile' },
  'co' =>  { code: 'col', name: 'Colombia' },

   'cr' =>  { code: 'crc', name: 'Costa Rica' },
  'gt' =>  { code: 'gua', name: 'Guatemala' },
  'hn' =>  { code: 'hon', name: 'Honduras' },
  'sv' =>  { code: 'slv', name: 'El Salvador' },
  'ni' =>  { code: 'nca', name: 'Nicaragua' },


  ## int'l tournaments
  'uefa.cl'      => { code: nil, name: 'UEFA',     path: 'europe' },
  'uefa.el'      => { code: nil, name: 'UEFA',     path: 'europe' },
  'concacaf.cl'  => { code: nil, name: nil,       path: 'north-america' },
  'copa.l'       => { code: nil, name: nil,       path: 'south-america' },
}



end  # module Worldfootball
