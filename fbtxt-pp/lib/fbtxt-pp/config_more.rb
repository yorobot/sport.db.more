
### rename to setups or such - why? why not?


## default setups

CONFIGS.merge!({
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
})
