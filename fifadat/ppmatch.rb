
require_relative 'helper'



##
##  - [ ] check for N.N.  goal missing IdPlayer
## ▪ 3rd Place
## Thu Feb 11
##  18:00 UTC+3   Al Ahly FC  0-0 a.e.t., 3-2 pen.  Palmeiras   @ Education City Stadium, Doha
##                  (Badr BENOUN 91'(p), MOHAMED HANY 97'(p), AJAYI Junior 99'(p);
##                   GUSTAVO SCARPA 96'(p), N.N. 98'(p))
##
##  - [ ]  clean stages in interconti
##           FIFA Derby of the Americas
##           FIFA African-Asian-Pacific Playoff
##           FIFA African-Asian-Pacific Play-off 2025™
##           FIFA African-Asian-Pacific Cup 2025™
##           FIFA Derby of the Americas 2025
##           FIFA Challenger Cup 2025
##           FIFA Intercontinental Cup 2025 Final
##
##  - [ ]  add year to first date -  club world cups 2020,2021 start year+1!!!
##   Club World Cup 2020
##    Dates    Mon Feb 1 - Thu Feb 11 2021 (10d)
##
##
##  check penalties  -   last pens NOT in paired order!!!!
##     resort possible (use IdTeam or such) in build recs??
## Sat Dec 14 20:00 UTC+3 @ Stadium 974, Doha, Att: 38841
##   CF Pachuca (MEX) v Al Ahly FC (EGY)  0-0 a.e.t., 6-5 pen.
## 
## Penalties:     Salomon RONDON (missed), 0-1 MOHAMED AFSHA,
##                BORJA (missed), 0-2 Rami RABIA,
##            1-2 Gustavo CABRAL, 1-3 MARAWAN ATTIA,
##            2-3 Oussama IDRISSI,     KAHRABA (missed),
##            3-3 Nelson DEOSSA,     OMAR KAMAL (missed),
##            4-3 Elias MONTIEL, 4-4 AMRO ELSOULIA,
##            5-4 RODRIGUEZ Luis, 6-4 Faber GIL,
##                KHALED ABDELFATTAH (missed)
##
## Fri Jan 14 20:00 UTC-2 @ Maracanã, Rio de Janeiro
##  Corinthians (BRA) v Vasco da Gama (BRA)  0-0 a.e.t., 4-3 pen.
##
## Penalties: 1-0 Freddy RINCON, 1-1 ROMÁRIO,
##           2-1 FERNANDO BAIANO, 2-2 ALEX OLIVEIRA,
##           3-2 LUIZAO,     GILBERTO MELO (missed),
##           4-2 EDU, 4-3 VIOLA,
##               MARCELINHO CARIOCA (missed),     EDMUNDO (missed)




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



args = ARGV
opts = {
    full: false,
}

parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"

   parser.on( "--full",
               "turn on full mode incl. line-up, pens, & more (default: #{opts[:full]})" ) do |full|
     opts[:full] = true
   end
end
parser.parse!( args )


puts "OPTS:"
pp opts
puts "ARGV:"
pp args

if args.size == 0
  puts " NAME argument required; use:"
  pp CONFIGS.keys
  exit 1
end  


##
## note - all args other than first ignored for now; issue warn - why? why not?

key = args[0].downcase.to_sym
config = CONFIGS[ key ]
puts "CONFIG:"
pp config

slug    = config[:slug]   ## change to source - why? why not?
seasons = config[:seasons]


## outdir = "../../openfootball/clubworldcup"
outdir = "."



seasons.each do |season|

    name =  config[:name].is_a?(Proc) ? config[:name].call( season )
                                      : config[:name]

    outname = config[:outname].is_a?(Proc) ? config[:outname].call( season )
                                           : config[:outname]


    page = String.new
    page << "= #{name} #{season}\n"
    page <<  "\n"
    
    buf = if opts[:full]
              pp_matches_full( slug: slug, season: season,
                                **config[:opts_full] )
  
          else
               pp_matches( slug: slug, season: season,
                             **config[:opts] )
          end
   
    page << buf
    
    puts page

    outpath = if opts[:full]
                 "#{outdir}/more/#{season}_#{outname}-full.txt"
              else
                 "#{outdir}/more/#{season}_#{outname}.txt"
              end

    write_text( outpath, page )
    puts "  written to >#{outpath}<"
end


puts "bye"