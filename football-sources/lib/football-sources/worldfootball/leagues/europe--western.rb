
module Worldfootball

LEAGUES_EUROPE.merge!({
  'fr.1'  => { pages: 'fra-ligue-1' },
  'fr.2'  => { pages: 'fra-ligue-2' },

  # e.g. /lux-nationaldivision-2020-2021/
  'lu.1' => { pages: 'lux-nationaldivision' },

  # e.g. /ned-eredivisie-2020-2021/
  'nl.1' => { pages: 'ned-eredivisie' },
  # Championship play-offs
  # Europa League play-offs (Group A + Group B / Finals )

  # e.g. /bel-eerste-klasse-a-2020-2021/
  #      /bel-europa-league-playoffs-2018-2019-playoff/
  #       - Halbfinale
  #       - Finale
  'be.1' => {
    pages: {
      'bel-eerste-klasse-a-{season}'                => 'Regular Season',
      'bel-eerste-klasse-a-{season}-playoff-i'      => 'Playoffs - Championship',
      'bel-europa-league-playoffs-{season}'         => 'Playoffs - Europa League',           ## note: missing groups (A & B)
      'bel-europa-league-playoffs-{season}-playoff' => 'Playoffs - Europa League - Finals',
    },
    season: ->( season ) {
      case season
      when Season('2020/21') then [1]     # just getting started
      when Season('2019/20') then [1]     # covid-19 - no championship & europa
      when Season('2018/19') then [1,2,3,4]
      end
    }
  },

})

end
