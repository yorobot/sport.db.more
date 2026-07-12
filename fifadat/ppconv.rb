

require_relative './lib/fifadat'
require_relative 'config'



args = ARGV
opts = { season: nil }

parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"
   ## add options here
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
seasons = config[:seasons]


## note - use (shared) absolute path for now!!
outdir  = '/sports/cache.api.fifa'

indir   = '/sports/cache.api.fifadat'


##  select 1st or selected season - works only on single season!!
season = opts[:season] ? opts[:season] : seasons[0]



    name =  config[:name].is_a?(Proc) ? config[:name].call( season )
                                      : config[:name]

    outname = config[:outname].is_a?(Proc) ? config[:outname].call( season )
                                           : config[:outname]



    data = pp_convert( slug: slug, season: season, indir: indir )

    outpath =  "#{outdir}/#{season}/#{outname}.json"

    write_json( outpath, data )
    puts "  written to >#{outpath}<"


    ##  convert all match reports one-by-one
    outdir = "#{outdir}/#{season}/#{outname}"
    pp_convert_reports( slug: slug, season: season,
                               indir: indir,
                               outdir: outdir )


puts "bye"
