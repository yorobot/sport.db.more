module Writer

########################
# Austria

LEAGUES.merge!(
  'at.1' => { name:     'Österr. Bundesliga',
              basename: '1-bundesliga',
              path:     'austria',
              lang:     'de_AT',
              stages:   ->(season) {
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
  'at.2' => { name:     ->(season) { season.start_year >= 2018 ? 'Österr. 2. Liga' : 'Österr. Erste Liga' },
              basename: ->(season) { season.start_year >= 2018 ? '2-liga2' : '2-liga1' },
              path:     'austria',
              lang:     'de_AT',
            },
  'at.3.o' => { name:     'Österr. Regionalliga Ost',
                basename: '3-regionalliga-ost',
                path:     'austria',
                lang:     'de_AT',
              },
  'at.cup' => { name:     'ÖFB Cup',
                basename: 'cup',
                path:     'austria',
                lang:     'de_AT',
              }
)

end   # module Writer
