
### rename to setups or such - why? why not?


## default setups
CONFIGS = {

  worldcup: {
        slug:      'worldcup',   ## rename to dir / indir / source / source or ???
        name:      'World Cup',
        ## check - incl. 2026 - not all matches with results and teams!!!
        seasons:   ['1930', '1934', '1938',
                    '1950', '1954', '1958', '1962', '1966', '1970', '1974', '1978',
                    '1982', '1986', '1990', '1994', '1998', '2002', '2006', '2010',
                    '2014', '2018', '2022', '2026'],
        ## default pp opts
        opts:        { country:       false,
                       show_stadiums: true,
                       show_teams:    false,
                       timezone:      true,
                     },
        opts_full:   { country: false,
                       show_stadiums: true,
                     },
        ## opts for squads (incl. jersey numbers - yes/no?)
        jerseys:  ->(season) { season >= 1954 ? true : false },

         ## outdir = "../../openfootball/worldcup"
    },


    clubworldcup: {
         slug:   'clubworldcup',  ## rename to dir / indir / source / source or ???
        name:      'Club World Cup',
        seasons:      ['2025'],
        ## default pp opts
        opts:        { country:       true,
                       show_stadiums: false,
                     },
        opts_full:   { country: true,
                     },

     ## outdir = "../../openfootball/clubworldcup"
    },



     ## todo - find a better key  than _v0??
     ##         use clubworldcup_hist or _history or __ ??
    clubworldcup_v0: {
       ##  all club world cups  2000, 2005-2023
       ##    NOT incl. new format every 4 yrs starting in 2025
       ##    NOT incl. old/new interconti cup every yr starting in 2024
        slug:   'interconticup',
        name:      'Club World Cup',
##        outname:   'clubworldcup',
        seasons: ['2000',
                  '2005', '2006', '2007', '2008', '2009',
                  '2010', '2011', '2012', '2013', '2014',
                  '2015', '2016', '2017', '2018', '2019',
                  '2020', '2021', '2022', '2023'],
        ## default pp opts
        opts:        { country: true,
                       show_stadiums: false,
                       show_teams:   true,
                     },
        opts_full:   { country: true,
                       show_teams:   true,
                     },
        ## outdir = "../../openfootball/clubworldcup"
    },



    interconticup: {
       ##    (new) interconti cup   2024-
        slug:   'interconticup',
        name:      'Intercontinental Cup',
       seasons: ['2024', '2025'],
       ## default pp opts
        opts:        { country: true,
                       show_stadiums: false,
                       show_teams:   true,
                     },
        opts_full:   { country: true,
                       show_teams:   true,
                     },
    },



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

  eng: {
        slug:      'eng',   ## rename to dir / indir / source / source or ???
        name:      'England | Premier League',
        seasons:   ['2025-26'],
        ## default pp opts
        opts:        { country: false,
                       stadium: true,
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


}
