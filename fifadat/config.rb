
### rename to setups or such - why? why not?


## default setups
CONFIGS = {

  worldcup: {
        slug:      'worldcup',   ## rename to dir / indir / source / source or ???
        name:      'World Cup',       
        outname:   'worldcup',
        ## check - incl. 2026 - not all matches with results and teams!!!
        seasons:   [1930, 1934, 1938,
                    1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
                    1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
                    2014, 2018, 2022],
        ## default pp opts
        opts:        { opt_country: false,   
                       opt_stadium: false,
                     },   
        opts_full:   { opt_country: false,
                     },
        ## opts for squads (incl. jersey numbers - yes/no?)
        jerseys:  ->(season) { season >= 1954 ? true : false },
            
         ## outdir = "../../openfootball/worldcup"      
    },
  
  
    clubworldcup: {
         slug:   'clubworldcup',  ## rename to dir / indir / source / source or ???
        name:      'Club World Cup',  
        outname:   'clubworldcup',
        seasons:      [2025],
        ## default pp opts
        opts:        { opt_country: true,   
                       opt_stadium: false,
                     },   
        opts_full:   { opt_country: true,
                     },

     ## outdir = "../../openfootball/clubworldcup"
    },



     ## todo - find a better key  than _v0??
     ##         use clubworldcup_hist or _history or __ ??
    clubworldcup_v0: {
       ##  all club world cups  2000, 2005-2023
       ##    NOT incl. new format every 4 yrs starting in 2025
       ##    N0T incl. old/new interconti cup every yr starting in 2024
        slug:   'interconticup', 
        name:      'Club World Cup',    
        outname:   'clubworldcup',
        seasons: [2000, 
                  2005, 2006, 2007, 2008, 2009,
                  2010, 2011, 2012, 2013, 2014,
                  2015, 2016, 2017, 2018, 2019,
                  2020, 2021, 2022, 2023],
        ## default pp opts
        opts:        { opt_country: true,   
                       opt_stadium: false,
                       opt_teams:   true,
                     },   
        opts_full:   { opt_country: true,
                       opt_teams:   true,
                     },       
        ## outdir = "../../openfootball/clubworldcup"
    },


    
    interconticup: {
       ##    (new) interconti cup   2024-
        slug:   'interconticup', 
        name:      'Intercontinental Cup',   
       outname:   'interconticup',
       seasons: [2024, 2025],
       ## default pp opts
        opts:        { opt_country: true,   
                       opt_stadium: false,
                       opt_teams:   true,
                     },   
        opts_full:   { opt_country: true,
                       opt_teams:   true,
                     },
    },
}


