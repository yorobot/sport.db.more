module Writer

LEAGUES.merge!(

  ########################
  # France
  'fr.1' => { name:     'French Ligue 1',
              basename: '1-ligue1',
              path:     'europe/france',
              lang:     'fr',
          },
  'fr.2' => { name:     'French Ligue 2',
              basename: '2-ligue2',
              path:     'europe/france',
              lang:     'fr',
            },

  'hu.1' => { name:     'Hungarian NB I',
              basename: '1-nbi',
              path:     'europe/hungary',
            },
  'gr.1' => { name:     'Super League Greece',
              basename: '1-superleague',
              path:     'europe/greece',
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

  'pt.1' => { name:     'Portuguese Primeira Liga',
              basename: '1-primeiraliga',
              path:     'europe/portugal',
              lang:     'pt_PT',
            },
  'pt.2' => { name:     'Portuguese Segunda Liga',
              basename: '2-segundaliga',
              path:     'europe/portugal',
              lang:     'pt_PT',
            },

  'ch.1' => { name:     'Swiss Super League',
              basename: '1-superleague',
              path:     'europe/switzerland',
              lang:     'de_CH',
            },
  'ch.2' => { name:     'Swiss Challenge League',
              basename: '2-challengeleague',
              path:     'europe/switzerland',
              lang:     'de_CH',
            },
  'tr.1' => { name:     'Turkish Süper Lig',
              basename: '1-superlig',
              path:     'europe/turkey',
            },
  'tr.2' => { name:     'Turkish 1. Lig',
              basename: '2-lig1',
              path:     'europe/turkey',
            },


  'is.1' => { name:     'Iceland Urvalsdeild',
              basename: '1-urvalsdeild',
              path:     'europe/iceland',
            },
  'sco.1' => { name:     'Scottish Premiership',
               basename: '1-premiership',
               path:     'europe/scotland',
               stages:  [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation' ]]
             },
  'ie.1' => { name:     'Irish Premier Division',
              basename: '1-premierdivision',
              path:     'europe/ireland',
            },

  'fi.1' => { name: 'Finland Veikkausliiga',  ## note: make optional!!! override here (otherwise (re)use "regular" lookup "canonical" name from league!!!)
              basename: '1-veikkausliiga',
              path:     'europe/finland',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Challenger',
                          'Europa League Finals' ]]
            },
 'se.1'  => { name:     'Sweden Allsvenskan',
                basename: '1-allsvenskan',
                path:     'europe/sweden',
              },
   'se.2'  => { name:     'Sweden Superettan',
                basename: '2-superettan',
                path:     'europe/sweden',
              },
   'no.1'  => { name:     'Norwegian Eliteserien',
                basename: '1-eliteserien',
                path:     'europe/norway'
              },
   'dk.1'  => { name:     'Denmark Superligaen',
                basename: '1-superligaen',
                path:     'europe/denmark',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },

   'lu.1'  => { name:     'Luxembourger First Division',
                basename: '1-nationaldivision',
                path:     'europe/luxembourg',
              },
   'be.1'  => { name:     'Belgian First Division A',
                basename: '1-firstdivisiona',
                path:     'europe/belgium',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Europa League',
                           'Playoffs - Europa League - Finals']]
               },
    'nl.1' =>  { name:     'Dutch Eredivisie',
                 basename: '1-eredivisie',
                 path:     'europe/netherlands',
               },
    'cz.1' => { name:     'Czech First League',
                basename: '1-firstleague',
                path:     'europe/czech-republic',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Europa League Play-off',
                           'Playoffs - Relegation'
                          ]]
              },
  'sk.1' =>   { name:     'Slovakia First League',
                basename: '1-superliga',
                path:     'europe/slovakia',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },
  'hr.1'  =>  { name:     'Croatia 1. HNL',
                basename: '1-hnl',
                path:     'europe/croatia',
              },
  'pl.1' => { name:     'Poland Ekstraklasa',
              basename: '1-ekstraklasa',
              path:     'europe/poland',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation']]
            },

  'ro.1' => { name:     'Romanian Liga 1',
              basename: '1-liga1',
              path:     'europe/romania',
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
              basename: '1-premierleague',
              path:     'europe/ukraine',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation',
                          'Europa League Finals']]
            },


   'ru.1' => { name:     'Russian Premier League',
               basename: '1-premierliga',
               path:     'europe/russia',
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
    'ru.2' => { name:     'Russian 1. Division',
                basename: '2-division1',
                path:     'europe/russia',
              },
)


end   # module Writer
