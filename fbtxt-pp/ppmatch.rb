
require_relative './lib/fbtxt-pp'
require_relative 'config'



args = ARGV
opts = {
    full:    false,  ## incl. line-ups, penalties, referees, etc.
    minimal: false,  ## no dates, no venues, no goals, no half-time score, etc.
    season:  nil,
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

   parser.on( "--season=SEASON",
               "season (default: #{opts[:season]})" ) do |season|
     opts[:season] = season
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
seasons = opts[:season] ?  [opts[:season]] : config[:seasons]


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
                 "#{outdir}/min/#{season}_#{outname}.txt"
              else
                 "#{outdir}/more/#{season}_#{outname}.txt"
              end

    write_text( outpath, page )
    puts "  written to >#{outpath}<"
end


puts "bye"