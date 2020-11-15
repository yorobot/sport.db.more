module Writer

############################
# Germany / Deutschland

LEAGUES.merge!(
  'de.1' => { name:     'Deutsche Bundesliga',
              basename: '1-bundesliga',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.2' => { name:     'Deutsche 2. Bundesliga',
              basename: '2-bundesliga2',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.3' => { name:     'Deutsche 3. Liga',
              basename: '3-liga3',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.cup' => { name:     'DFB Pokal',
                basename: 'cup',
                path:     'deutschland',
                lang:     'de_DE',
              }
)

end   # module Writer
