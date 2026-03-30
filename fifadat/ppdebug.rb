
require_relative 'helper'
require_relative 'config'


args = ARGV
opts = { season: nil }

parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"
   ## add options here
   parser.on( "--season=NUM", Integer,
               "season (default: #{opts[:season] ? opts[:season] : '1st'})" ) do |num|
     opts[:season] = num
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

outdir  = '.'
##  select 1st or selected season - works only on single season!!
season = opts[:season] ? opts[:season] : seasons[0]



    name =  config[:name].is_a?(Proc) ? config[:name].call( season )
                                      : config[:name]

    outname = config[:outname].is_a?(Proc) ? config[:outname].call( season )
                                           : config[:outname]


    page = String.new
    page << "= #{name} #{season}\n"
    page <<  "\n"
    
    buf = pp_debug( slug: slug, season: season )
  
    page << buf
    
    puts page

    outpath =  "#{outdir}/tmp/#{season}_#{outname}-debug.txt"
             
    write_text( outpath, page )
    puts "  written to >#{outpath}<"



puts "bye"


__END__


wc 2026:
"MatchStatus"=>{1=>104},
 "ResultType"=>{0=>104},
 "Leg"=>{nil=>104},
 "IsHomeMatch"=>{nil=>104},
 "TeamType"=>{1=>126},
 "AgeType"=>{7=>126},
 "FootballType"=>{0=>126}}
 

add asserts for MatchStatus && TeamType
##     use a  opt_club flag - why? why not?
##         or better use a first_teamtype 
##              and make sure all other match - cannot mix'n'match!!!

- [ ] use   MatchStatus 0 for complete? 
         && MatchStatus 1 for future? 

- [ ] use    TeamType  0 for club 
          && TeamType  1 for national_team   

- resulttype  0 - to be done
              1 - 90min, 
              2 - aet, win on pens, 
              3 - aet


wc 1930:
"MatchStatus"=>{0=>18},
 "ResultType"=>{1=>18},
 "Leg"=>{nil=>18},
 "IsHomeMatch"=>{nil=>18},
 "TeamType"=>{1=>36},
 "AgeType"=>{7=>36},
 "FootballType"=>{0=>36}}

wc 2018:
stats:{"MatchStatus"=>{0=>64}, "ResultType"=>{1=>59, 2=>4, 3=>1}}

wc 2022:
{"MatchStatus"=>{0=>64},
 "ResultType"=>{1=>59, 2=>5},
 "Leg"=>{nil=>64},
 "IsHomeMatch"=>{nil=>64},
 "TeamType"=>{1=>128},
 "AgeType"=>{7=>128},
 "FootballType"=>{0=>128}}

cwc 2023:
stats:{"MatchStatus"=>{0=>7}, "ResultType"=>{1=>7}}



cwc 2025:
  - data error   pachuca vs salzburg => resulttype 0!!
"MatchStatus"=>{0=>63},
 "ResultType"=>{1=>59, 0=>1, 3=>3},
 "Leg"=>{nil=>63},
 "IsHomeMatch"=>{nil=>63},
 "TeamType"=>{0=>126},
 "AgeType"=>{7=>126},
 "FootballType"=>{0=>126}}