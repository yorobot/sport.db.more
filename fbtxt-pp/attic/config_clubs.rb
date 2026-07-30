
CONFIGS.merge!({

  at: {
        slug:      'at',   ## rename to dir / indir / source / source or ???
        name:      'Austria | Bundesliga',
        seasons:   ['2025-26'],
        ## default pp opts
        opts:        { country: false,
                       stadium: false,
                       city:    false,
                       timezone: false,
                     },
        opts_full:   { country: false,
                     },
    },

   de: {
        slug:      'de',
        name:      'Germany | Bundesliga',
        seasons:   ['2025-26'],
        ## default pp opts
        opts:        { country: false,
                       stadium: false,
                       city:    false,
                       timezone: false,
                     },
        opts_full:   { country: false,
                     },
    },

  eng: {
        slug:      'eng',   ## rename to dir / indir / source / source or ???
        name:      'England | Premier League',
        seasons:   ['2025-26'],
        ## default pp opts
        opts:        { country: false,
                       stadium: false,
                       city:    false,
                       timezone: false,
                     },
        opts_full:   { country: false,
                     },
    },

 'uefa.cl': {
        slug:      'uefa.cl',   ## rename to dir / indir / source / source or ???
        name:      'UEFA | Champions League',
        seasons:   ['2025/26'],
        ## default pp opts
        opts:        { country: true,
                       stadium: false,
                       city:    true,
                       timezone: false,
                       show_teams: true,
                     },
        opts_full:   { country: false,
                     },
    },
})