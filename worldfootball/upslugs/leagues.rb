###
# config for leagues
#   map code to (sample) slug for easy (re)use



## find a better name for league_to_slug - why? why not?

## league to slug/page mappings
LEAGUE_TO_SLUG = {

  ### British Isles / Western Europe
  'eng.1'  => 'eng-premier-league-2024-2025',
  'eng.2'  => 'eng-championship-2024-2025',
  'ie.1' =>  'irl-premier-division-2024',
  'sco.1'  => 'sco-premiership-2024-2025',


 ### Northern Europe
  'se.1' => 'swe-allsvenskan-2024',
  'se.2' => 'swe-superettan-2024',
  'fi.1' => 'fin-veikkausliiga-2024',
  'dk.1' => 'den-superliga-2024-2025',


 ### Benelux / Western Europe
  'nl.1'    => 'ned-eredivisie-2024-2025',
  'nl.2'    => 'ned-eerste-divisie-2024-2025',
  'nl.cup'  => 'ned-knvb-beker-2024-2025',

  'be.1'    => 'bel-eerste-klasse-a-2024-2025',
  'be.2'    => 'bel-eerste-klasse-b-2024-2025',
  'be.cup'  => 'bel-beker-van-belgie-2023-2024',
  'lu.1'    => 'lux-nationaldivision-2024-2025',


 #### Central Europe
   'at.1'    => 'aut-bundesliga-2024-2025',
   'at.2'    => 'aut-2-liga-2024-2025',
   'at.cup'  => 'aut-oefb-cup-2024-2025',
   'at.3.o'  => 'aut-regionalliga-ost-2024-2025',

   'ch.1'    =>  'sui-super-league-2024-2025',
   'ch.2'    =>  'sui-challenge-league-2024-2025',
   'ch.cup'  =>  'sui-cup-2024-2025',

   'hu.1'  =>  'hun-nb-i-2024-2025',
   'cz.1'  =>  'cze-1-fotbalova-liga-2024-2025',
   'pl.1'  =>  'pol-ekstraklasa-2024-2025',

  ### Southern Europe
  'it.1' => 'ita-serie-a-2020-2021',
  'it.2' => 'ita-serie-b-2024-2025',
  'it.cup' => 'ita-coppa-italia-2024-2025',

  'es.1' => 'esp-primera-division-2020-2021',
  'es.2' =>  'esp-segunda-division-2024-2025',
  'es.cup' =>  'esp-copa-del-rey-2023-2024',


   'pt.1' => 'por-primeira-liga-2023-2024',
    'pt.2' => 'por-segunda-liga-2023-2024',

  'gr.1' => 'gre-super-league-2023-2024',

## note: start with 2012/13 for now!!!
## in 2011/12 a new format was introduced, in which after the regular season
##  two play-off groups were played to decide over the Champions League and Europa League starting rounds
## 1)  - tur-sueperlig-2011-2012
## 2a) - tur-sueperlig-2012-meisterschaft  -- 2012 Meisterschaft
## 2b) - tur-sueperlig-2012-platzierung    -- 2012 Platzierung
  'tr.1' => 'tur-sueperlig-2023-2024',

 ### Eastern Europe
 'ro.1' => 'rou-liga-1-2023-2024',

##
## note: ru - special (transition) league format for season 2011/12 (lasting 18 month!!)
#  1)  rus-premier-liga-2011-2012/     -- 30 rounds
#  2a) rus-premier-liga-2011-2012-meisterschaft/  -- 2011/2012 Meisterschaft (rounds 31 to 44)
#   b) rus-premier-liga-2011-2012-relegation/     -- 2011/2012 Relegation    (rounds 31 to 44)
 'ru.1' => 'rus-premier-liga-2024-2025',

 'ua.1' => 'ukr-premyer-liga-2019-2020',

 ### Asia
 'cn.1' => 'chn-super-league-2024',
 'jp.1' => 'jpn-j1-league-2024',

 ### Africa
  'eg.1' => 'egy-premiership-2019-2020',


 ### North America
'us.1'   =>  'usa-major-league-soccer-2020',
'us.2'   =>  'usa-usl-championship-2020',
'us.cup'  =>  'usa-u-s-open-cup-2019',

'mx.1'   =>  'mex-primera-division-2020-2021-apertura',
'mx.cup' => 'mex-copa-mx-2019-2020',
'mx.2'   => 'mex-liga-de-expansion-2020-2021-apertura',
'mx.3'   => 'mex-premier-de-ascenso-2020-2021-grupo-b',

 ### Central America & Caribbean Islands
'cr.1' => 'crc-primera-division-2020-2021-apertura',
'sv.1' => 'slv-primera-division-2020-2021-apertura',
'gt.1' => 'gua-liga-nacional-2020-2021-apertura',
'hn.1' => 'hon-liga-nacional-2020-2021-apertura',
'ni.1' => 'nca-liga-primera-2020-2021-apertura',

 ### South America
 'br.1'    =>  'bra-serie-a-2020',
 'br.2'    =>  'bra-serie-b-2024',
 'br.3'    =>  'bra-serie-c-2024-playoffs',
 'br.4'    =>  'bra-serie-d-2024',
 'br.cup'  =>  'bra-copa-do-brasil-2024',     # Copa do Brasil

 'br.carioca' => 'bra-campeonato-carioca-2024-taca-guanabara-finals',
 # Campeonato Carioca
 'br.gauchao' => 'bra-campeonato-gaucho-2024-playoffs',
 # Campeonato Gaúcho
 'br.mineiro' => 'bra-campeonato-mineiro-2024-fase-final',
 # Campeonato Mineiro
 'br.paranaense' => 'bra-campeonato-paranaense-2024-fase-final',
 # Campeonato Paranaense
  'br.paulistao' => 'bra-campeonato-paulista-2024-playoffs',
  # Campeonato Paulista



 'ar.1' => 'arg-primera-division-2019-2020',

 'pe.1' => 'per-primera-division-2020-apertura',
 'cl.1' => 'chi-primera-division-2020',
 'uy.1' => 'uru-primera-division-2020-apertura',
 'co.1' => 'col-primera-a-2020',
 'bo.1' => 'bol-liga-profesional-2024-clausura',
 'ec.1' => 'ecu-serie-a-2024-segunda-etapa',


 ### Int'l Cups / Tournaments
 'uefa.cl'   =>  'champions-league-2020-2021',
 'uefa.cl.q' => 'champions-league-qual-2024-2025',
 'uefa.el'   =>  'europa-league-2020-2021',
 'uefa.el.q' =>  'europa-league-qual-2024-2025',
 ## use conf or other code - why? why not? (drop europa?)
 'uefa.ecl'   =>  'europa-conference-league-2023-2024',
 'uefa.ecl.q' =>  'europa-conference-league-qual-2024-2025',


 'copa.l' =>  'copa-libertadores-2020',
 'concacaf.cl'  =>  'concacaf-champions-league-2020',

}


