
require_relative 'helper'



args = ARGV
opts = {
    full: false,
}

parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAMES"

   parser.on( "--full",
               "turn on full mode incl. line-up, pens, & more (default: #{opts[:full]})" ) do |full|
     opts[:full] = true
   end
end
parser.parse!( args )


puts "OPTS:"
p opts
puts "ARGV:"
p args




seasons = [2025]


## outdir = "../../openfootball/clubworldcup"
outdir = "."


seasons.each do |season|

    page = String.new
    page << "= Club World Cup #{season}\n"
    page <<  "\n"
    
    buf = if opts[:full]
              pp_matches_full( slug: "clubworldcup",
                       season: season,
                       opt_country: true )
  
          else
               pp_matches( slug: "clubworldcup",
                           season: season,
                           opt_country: true,
                           opt_stadium: false )
          end
   
    page << buf
    
    puts page

    outpath = if opts[:full]
                 "#{outdir}/more/clubworldcup#{season}-full.txt"
              else
                 "#{outdir}/more/clubworldcup#{season}.txt"
              end

    write_text( outpath, page )
    puts "  written to >#{outpath}<"
end


puts "bye"