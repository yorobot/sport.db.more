module Worldfootball


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
