module Writer

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

  ########################
  # France
  'fr.1' => { name:     'French Ligue 1',
              basename: '1-ligue1',
          },
  'fr.2' => { name:     'French Ligue 2',
              basename: '2-ligue2',
            },

  'hu.1' => { name:     'Hungarian NB I',
              basename: '1-nbi',
            },
  'gr.1' => { name:     'Super League Greece',
              basename: '1-superleague',
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
            },
  'pt.2' => { name:     'Portuguese Segunda Liga',
              basename: '2-segundaliga',
            },

  'ch.1' => { name:     'Swiss Super League',
              basename: '1-superleague',
            },
  'ch.2' => { name:     'Swiss Challenge League',
              basename: '2-challengeleague',
            },
  'tr.1' => { name:     'Turkish Süper Lig',
              basename: '1-superlig',
            },
  'tr.2' => { name:     'Turkish 1. Lig',
              basename: '2-lig1',
            },


  'is.1' => { name:     'Iceland Urvalsdeild',
              basename: '1-urvalsdeild',
            },
  'sco.1' => { name:     'Scottish Premiership',
               basename: '1-premiership',
               stages:  [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation' ]]
             },
  'ie.1' => { name:     'Irish Premier Division',
              basename: '1-premierdivision',
            },

  'fi.1' => { name: 'Finland Veikkausliiga',  ## note: make optional!!! override here (otherwise (re)use "regular" lookup "canonical" name from league!!!)
              basename: '1-veikkausliiga',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Challenger',
                          'Europa League Finals' ]]
            },
 'se.1'  => { name:     'Sweden Allsvenskan',
                basename: '1-allsvenskan',
              },
   'se.2'  => { name:     'Sweden Superettan',
                basename: '2-superettan',
              },
   'no.1'  => { name:     'Norwegian Eliteserien',
                basename: '1-eliteserien',
              },
   'dk.1'  => { name:     'Denmark Superligaen',
                basename: '1-superligaen',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },

   'lu.1'  => { name:     'Luxembourger First Division',
                basename: '1-nationaldivision',
              },
   'be.1'  => { name:     'Belgian First Division A',
                basename: '1-firstdivisiona',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Europa League',
                           'Playoffs - Europa League - Finals']]
               },
    'nl.1' =>  { name:     'Dutch Eredivisie',
                 basename: '1-eredivisie',
               },
    'cz.1' => { name:     'Czech First League',
                basename: '1-firstleague',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Europa League Play-off',
                           'Playoffs - Relegation'
                          ]]
              },
  'sk.1' =>   { name:     'Slovakia First League',
                basename: '1-superliga',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },
  'hr.1'  =>  { name:     'Croatia 1. HNL',
                basename: '1-hnl',
              },
  'pl.1' => { name:     'Poland Ekstraklasa',
              basename: '1-ekstraklasa',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation']]
            },

  'ro.1' => { name:     'Romanian Liga 1',
              basename: '1-liga1',
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
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation',
                          'Europa League Finals']]
            },


   'ru.1' => { name:     'Russian Premier League',
               basename: '1-premierliga',
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
              },
)


end   # module Writer
