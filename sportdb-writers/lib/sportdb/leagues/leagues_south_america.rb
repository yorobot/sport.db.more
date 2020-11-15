module Writer


LEAGUES.merge!(
  'ar.1' => { name:     'Argentina Primera Division',
              basename: '1-primeradivision',
              path:     'south-america/argentina',
              lang:     'es_AR',
            },

  ############################
  # Brazil
  'br.1' => { name:     'Brasileiro Série A',  ## league name
              basename: '1-seriea',
              path:     'south-america/brazil',              ## repo path
              lang:     'pt_BR',
            },
)


end   # module Writer
