
LEAGUES.merge!(

  ###
  # Uefa
  ##  quick and dirty add for champions league
  ##
  ##  use uefa.1 - why? why not?
  ##      uefa.2,
  ##      uefa.3

  'uefa.cl' => {  name: 'UEFA Champions League',
                  basename: 'cl',
               },


'at.1' => {   stages:   ->(season) {
                            if season.start_year >= 2018
                             [['Grunddurchgang'],
                              ['Finaldurchgang - Meister',
                               'Finaldurchgang - Qualifikation',
                               'Europa League Play-off']]
                            else
                              nil
                            end
                          },
            },

  'gr.1' => { name:     'Super League Greece',
              stages:   ->(season) {
                if season.start_year >= 2019  # new league system starting with 2015/16 season
                 [['Regular Season'],
                  ['Playoffs - Championship',
                   'Playoffs - Relegation']]
                elsif [2017,2018].include?( season.start_year )  ## 2017/18, 2018/19
                  nil
                elsif [2013,2014,2015,2016].include?( season.start_year )
                  [['Regular Season'],
                   ['Playoffs']]
                elsif season.start_year == 2012
                  [['Regular Season'],
                   ['Playoffs',
                    'Match 6th Place']]
                elsif [2010,2011].include?( season.start_year )
                  [['Regular Season'],
                   ['Playoffs']]
                else
                  nil
                end
               },
            },

            },
  'sco.1' => { name:     'Scottish Premiership',
               stages:  [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation' ]]
             },

  'fi.1' => { name: 'Finland Veikkausliiga',  ## note: make optional!!! override here (otherwise (re)use "regular" lookup "canonical" name from league!!!)
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Challenger',
                          'Europa League Finals' ]]
            },
   'dk.1'  => { name:     'Denmark Superligaen',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },

   'be.1'  => { name:     'Belgian First Division A',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Europa League',
                           'Playoffs - Europa League - Finals']]
               },

    'cz.1' => { name:     'Czech First League',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Europa League Play-off',
                           'Playoffs - Relegation'
                          ]]
              },
  'sk.1' =>   { name:     'Slovakia First League',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },

  'pl.1' => { name:     'Poland Ekstraklasa',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation']]
            },

  'ro.1' => { name:     'Romanian Liga 1',
              stages:   ->(season) {
                        if season.start_year >= 2015  # new league system starting with 2015/16 season
                         [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation']]
                        else
                          nil
                        end
                       },
            },

  'ua.1' => { name:     'Ukraine Premier League',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation',
                          'Europa League Finals']]
            },


   'ru.1' => { name:     'Russian Premier League',
               stages:   ->(season) {
                if season.start_year == 2011  # 2011/12 - new (transition) league system during season switch from calendar year to academic
                 [['Regular Season'],
                  ['Playoffs - Championship',
                   'Playoffs - Relegation']]
                else
                  nil
                end
               },
     },
)

