require 'json'
require 'pp'


=begin
## Tier One
BSA - Série A               , Brazil          4 seasons | 2020-05-03 - 2020-12-06 / matchday 10
ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 38
PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 31
CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-05-30 / matchday 6
EC  - European Championship , Europe          2 seasons | 2020-06-12 - 2020-07-12 / matchday 1
FL1 - Ligue 1               , France          9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34
SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 27
DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34
PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 28
PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 31
WC  - FIFA World Cup        , World           2 seasons | 2018-06-14 - 2018-07-15 / matchday 3


## Tier Two
ASL - Superliga Argentina   , Argentina       3 seasons | 2019-07-27 - 2020-03-01 / matchday 22
AAL - A League              , Australia       3 seasons | 2019-10-11 - 2020-05-17 / matchday 29
APL - Playoffs 1/2          , Austria         1 seasons | 2018-05-31 - 2018-06-03 / matchday
BJL - Jupiler Pro League    , Belgium         3 seasons | 2019-07-26 - 2020-05-24 / matchday 30
BSA - Série A               , Brazil          4 seasons | 2020-05-03 - 2020-12-06 / matchday 16
FAC - FA Cup                , England         3 seasons | 2019-08-10 - 2020-05-23 / matchday
ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 44
EL1 - League One            , England        11 seasons | 2019-08-03 - 2020-05-26 / matchday 46
PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 36
EC  - European Championship , Europe          2 seasons | 2020-06-12 - 2020-07-12 / matchday 1
CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-08-23 / matchday 6
EL  - UEFA Europa League    , Europe          2 seasons | 2019-06-27 - 2020-08-21 / matchday 6
FL1 - Ligue 1               , France          9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
FL2 - Ligue 2               , France         22 seasons | 2019-07-26 - 2020-05-31 / matchday 38
BL2 - 2. Bundesliga         , Germany        24 seasons | 2019-07-26 - 2020-06-28 / matchday 34
BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34
DFB - DFB-Pokal             , Germany         3 seasons | 2019-08-09 - 2020-07-04 / matchday
SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 33
SB  - Serie B               , Italy          15 seasons | 2019-08-24 - 2020-07-31 / matchday 34
JJL - J. League             , Japan           3 seasons | 2020-02-21 - 2020-12-19 / matchday 5
DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34
PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 32
RFPL - RFPL                  , Russia          3 seasons | 2019-07-28 - 2020-07-22 / matchday 29
SPL - Premier League        , Scotland        3 seasons | 2019-08-03 - 2020-05-30 / matchday 33
PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 37
SD  - Segunda División      , Spain           8 seasons | 2019-08-17 - 2020-07-19 / matchday 40
MLS - MLS                   , United States    3 seasons | 2020-02-29 - 2020-11-10 / matchday 2
WC  - FIFA World Cup        , World           2 seasons | 2018-06-14 - 2018-07-15 / matchday 3

## Tier Three
ASL - Superliga Argentina   , Argentina       3 seasons | 2019-07-27 - 2020-03-01 / matchday 22
AAL - A League              , Australia       3 seasons | 2019-10-11 - 2020-05-17 / matchday 29
ABL - Bundesliga            , Austria         3 seasons | 2019-07-22 - 2020-07-05 / matchday 10
APL - Playoffs 1/2          , Austria         1 seasons | 2018-05-31 - 2018-06-03 / matchday
BJL - Jupiler Pro League    , Belgium         3 seasons | 2019-07-26 - 2020-05-24 / matchday 30
BSB - Série B               , Brazil          3 seasons | 2020-05-01 - 2020-11-28 / matchday 7
BSA - Série A               , Brazil          4 seasons | 2020-05-03 - 2020-12-06 / matchday 16
CPD - Primera División      , Chile           4 seasons | 2020-01-24 - 2020-11-28 / matchday 18
DSU - Superliga             , Denmark         3 seasons | 2019-07-12 - 2020-07-26 / matchday 8
EL2 - League Two            , England         3 seasons | 2019-08-03 - 2020-05-25 / matchday 46
FLC - Football League Cup   , England         3 seasons | 2019-08-12 - 2020-03-01 / matchday
FAC - FA Cup                , England         3 seasons | 2019-08-10 - 2020-05-23 / matchday
ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 44
EL1 - League One            , England        11 seasons | 2019-08-03 - 2020-05-26 / matchday 46
PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 36
EC  - European Championship , Europe          2 seasons | 2020-06-12 - 2020-07-12 / matchday 1
CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-08-23 / matchday 6
EL  - UEFA Europa League    , Europe          2 seasons | 2019-06-27 - 2020-08-21 / matchday 6
VEI - Veikkausliiga         , Finland         3 seasons | 2020-04-11 - 2020-11-28 / matchday 3
FL1 - Ligue 1               , France          9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
FL2 - Ligue 2               , France         22 seasons | 2019-07-26 - 2020-05-31 / matchday 38
BL3 - 3. Liga               , Germany         8 seasons | 2019-07-11 - 2020-07-04 / matchday 38
BL2 - 2. Bundesliga         , Germany        24 seasons | 2019-07-26 - 2020-06-28 / matchday 34
BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34
DFB - DFB-Pokal             , Germany         3 seasons | 2019-08-09 - 2020-07-04 / matchday
REG - Regionalliga          , Germany         3 seasons | 2019-07-11 - 2020-05-30 / matchday 38
HNB - NB I                  , Hungary         3 seasons | 2019-08-03 - 2020-06-27 / matchday 33
SB  - Serie B               , Italy          15 seasons | 2019-08-24 - 2020-07-31 / matchday 34
SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 33
CIT - Coppa Italia          , Italy           3 seasons | 2019-08-03 - 2020-05-13 / matchday
JJL - J. League             , Japan           3 seasons | 2020-02-21 - 2020-12-19 / matchday 5
LMX - Liga MX               , Mexico          3 seasons | 2019-07-20 - 2020-05-27 / matchday 19
DJL - Jupiler League        , Netherlands     3 seasons | 2019-08-09 - 2020-05-01 / matchday 38
DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34
KNV - KNVB Beker            , Netherlands     3 seasons | 2019-08-17 - 2020-05-05 / matchday
TIP - Tippeligaen           , Norway          3 seasons | 2020-04-04 - 2020-12-19 / matchday 8
PPD - Primera División      , Peru            3 seasons | 2020-02-02 - 2020-12-12 / matchday 19
PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 32
RL1 - Liga I                , Romania         3 seasons | 2019-07-13 - 2020-08-01 / matchday 10
RFPL - RFPL                  , Russia          3 seasons | 2019-07-28 - 2020-07-22 / matchday 29
SPL - Premier League        , Scotland        3 seasons | 2019-08-03 - 2020-05-30 / matchday 33
PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 37
CDR - Copa del Rey          , Spain           3 seasons | 2019-11-13 - 2020-04-18 / matchday
SD  - Segunda División      , Spain           8 seasons | 2019-08-17 - 2020-07-19 / matchday 40
ALL - Allsvenskan           , Sweden          3 seasons | 2020-04-05 - 2020-12-06 / matchday 8
SSL - Super League          , Switzerland     3 seasons | 2019-07-20 - 2020-08-02 / matchday 31
TSL - Süper Lig             , Turkey          3 seasons | 2019-08-18 - 2020-07-26 / matchday 32
UPL - Premier Liha          , Ukraine         3 seasons | 2019-07-28 - 2020-07-19 / matchday 9
MLS - MLS                   , United States    3 seasons | 2020-02-29 - 2020-11-10 / matchday 2
WC  - FIFA World Cup        , World           2 seasons | 2018-06-14 - 2018-07-15 / matchday 3
=end


# path = './dl/competitions.json'
path = './dl/competitions-I-plan~TIER_THREE.json'

txt = File.open( path, 'r:utf-8' ) {|f| f.read }
data = JSON.parse( txt )

data[ 'competitions'].each do |comp|
  print '%-3s' % comp['code']
  print ' - '
  print '%-22s' % comp['name']
  print ', '
  print '%-12s' % comp['area']['name']
  print '   '
  print '%2s seasons' % comp['numberOfAvailableSeasons']
  print ' | '

  season = comp['currentSeason']
  print "#{season['startDate']} - #{season['endDate']} / matchday #{season['currentMatchday']}"
  print "\n"
end

