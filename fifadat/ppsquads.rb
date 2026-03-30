require_relative 'helper'
require_relative 'config'





args = ARGV  
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

## outdir = "../../openfootball/worldcup"
## outdir = "."





seasons.each do |season|

    name =  config[:name].is_a?(Proc) ? config[:name].call( season )
                                      : config[:name]

    outname = config[:outname].is_a?(Proc) ? config[:outname].call( season )
                                           : config[:outname]

    opt_jerseys =  config[:jerseys].is_a?(Proc) ? config[:jerseys].call( season )
                                                 : config.fetch(:jerseys, true)

    opt_country =  config[:opts].fetch( :opt_country, false )


   page = String.new
   page << "= #{name} #{season}        "

   buf = pp_squads( slug: slug, season: season,
                          opt_jerseys: opt_jerseys,
                          opt_country: opt_country )
   page << buf


   ## puts buf
   write_text( "#{outdir}/more/#{season}_#{outname}-squads.txt", page )
end


puts "bye"

