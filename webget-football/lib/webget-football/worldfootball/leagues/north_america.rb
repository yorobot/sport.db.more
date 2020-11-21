module Worldfootball

LEAGUES_NORTH_AMERICA = {

# todo/fix: adjust date/time by -6 or 7 hours!!!
#   /can-canadian-championship-2020/
#     - Qual. 1. Runde
#     - Qual. 2. Runde
#     - Qual. 3. Runde
#   todo/fix: check for leagues - premier league? championship? soccer league?
#  'ca.1' => { slug: 'can-canadian-championship' },



# todo/fix: adjust date/time by -7 hours!!!
##  e.g. 25.07.2020	02:30  => 24.07.2020 19.30
#        11.01.2020	04:00  => 10.01.2020 21.00
#
# e.g. /mex-primera-division-2020-2021-apertura/
#      /mex-primera-division-2019-2020-clausura/
#      /mex-primera-division-2019-2020-apertura-playoffs/
#        - Viertelfinale
#        - Halbfinale
#        - Finale
#      /mex-primera-division-2018-2019-clausura-playoffs/
'mx.1' => {
  pages: {
    'mex-primera-division-{season}-apertura'          => 'Apertura',            # 1
    'mex-primera-division-{season}-apertura-playoffs' => 'Apertura - Liguilla', # 2
    'mex-primera-division-{season}-clausura'          => 'Clausura',            # 3
    'mex-primera-division-{season}-clausura-playoffs' => 'Clausura - Liguilla', # 4
 },
 season: ->( season ) {
  case season
  when Season('2020/21') then [1]        # just getting started
  when Season('2019/20') then [1,2,3]    # covid-19 - no liguilla
  when Season('2010/11')..Season('2018/19') then [1,2,3,4]
  end
 }
},
}

end # module Worldfootball

