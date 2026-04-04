
require_relative 'helper'
require_relative 'config'


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





args = ARGV
opts = {
    full: false,     ## incl. line-ups, penalties, referees, etc.
    minimal: false,  ## no dates, no venues, no goals, no half-time score, etc.
}


parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"

   parser.on( "--full",
               "turn on full mode incl. line-up, pens, & more (default: #{opts[:full]})" ) do |full|
     opts[:full] = true
   end

   parser.on( "--min",
               "turn on min(imal) mode (default: #{opts[:min]})" ) do |min|
     opts[:min] = true
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
          elsif opts[:min]
              pp_matches_min( slug: slug, season: season,
                                 **config[:opts] )
          else
               pp_matches( slug: slug, season: season,
                             **config[:opts] )
          end
   
    page << buf
    
    puts page

    outpath = if opts[:full]
                 "#{outdir}/more/#{season}_#{outname}-full.txt"
              elsif opts[:min]
                 "#{outdir}/min/#{season}.txt"
              else
                 "#{outdir}/more/#{season}_#{outname}.txt"
              end

    write_text( outpath, page )
    puts "  written to >#{outpath}<"
end


puts "bye"