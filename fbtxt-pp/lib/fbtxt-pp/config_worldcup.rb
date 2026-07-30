
CONFIGS.merge!({
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
                       stadium:       false,
                       city:          true,
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
    }
})
