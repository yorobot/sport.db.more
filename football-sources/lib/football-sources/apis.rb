###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


module Footballdata

LEAGUES = {
  'eng.1' => 'PL',     # incl. team(s) from wales
  'eng.2' => 'ELC',
   # PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 31
   #  ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 38
   #
   # 2019 => 2019/20
   # 2018 => 2018/19
   # 2017 => xxx 2017-18 - requires subscription !!!

  'es.1'  => 'PD',
  # PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 31

  'pt.1'  => 'PPL',
  # PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 28

  'de.1'  => 'BL1',
  # BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34

  'nl.1'  => 'DED',
  # DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34

  'fr.1'  => 'FL1',    # incl. team(s) monaco
  # FL1 - Ligue 1, France
  #   9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
  #
  # 2019 => 2019/20
  # 2018 => 2018/19
  # 2017 => xxx 2017-18 - requires subscription !!!

  'it.1'  => 'SA',
  # SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 27

  'br.1'  => 'BSA',
  # BSA - Série A, Brazil
  #   4 seasons | 2020-05-03 - 2020-12-06 / matchday 10
  #
  #  2020 => 2020
  #  2019 => 2019
  #  2018 => 2018
  #  2017 => xxx 2017 - requires subscription !!!

  ## todo/check: use champs and NOT cl - why? why not?
  'cl'        => 'CL',    ## note: cl is country code for chile!! - use champs - why? why not?
  'europe.cl' => 'CL',    ## note: cl is country code for chile!! - use champs - why? why not?
  # CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-05-30 / matchday 6
}


#########
## Mods
# e.g.
# Cardiff City FC | Cardiff  › Wales  - Cardiff City Stadium, Leckwith Road Cardiff CF11 8AZ
# AS Monaco FC | Monaco  › Monaco     - Avenue des Castellans Monaco 98000


MODS = {
  'br.1' => {
         'América FC' => 'América MG',   # in year 2018
            },
  'pt.1'  => {
         'Vitória SC' => 'Vitória Guimarães',  ## avoid easy confusion with Vitória SC <=> Vitória FC
         'Vitória FC' => 'Vitória Setúbal',
           },
}

end  # module Footballdata


###########################
## our own code
require_relative 'apis/config'
require_relative 'apis/stat'
require_relative 'apis/download'

require_relative 'apis/convert'
require_relative 'apis/convert_cl'

