module Worldfootball

LEAGUES_PACIFIC = {

  # /nzl-nz-football-championship-2019-2020/
  # /nzl-nz-football-championship-2018-2019-playoffs/
  'nz.1' => {
    pages: {
      'nzl-nz-football-championship-{season}'          => 'Regular Season', # 1
      'nzl-nz-football-championship-{season}-playoffs' => 'Playoff Finals', # 2
     },
     season: ->( season ) {
      case season
      when Season('2019/20') then [1]    ## covid-19 - no playoffs/finals
      when Season('2018/19') then [1,2]
      end
     }
  },
}

end # module Worldfootball
