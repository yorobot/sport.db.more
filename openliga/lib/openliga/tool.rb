
module Openliga
 module Tool


def self.main( args=ARGV )


##  todo - make it an option - maybe??
Webcache.root = './cache'


opts = {
    metal:    false,
    season:   nil,
    outpath:  nil,
}



parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"

   parser.on( "--metal",
               "use openligadb.de shortcuts/codes and seasons/years (default: #{opts[:metal]})" ) do |metal|
     opts[:metal] = true
   end

   parser.on( "-o PATH", "--output",
               "write football.txt conversion to output path (default: #{opts[:outpath]||'none'})" ) do |outpath|
     opts[:outpath] = outpath
   end

   parser.on( "--season=SEASON",
               "season (default: #{opts[:season]||'none'})" ) do |season|
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
  pp LEAGUES
  puts "---"
  pp LEAGUES.keys
  exit 1
end



##
## note - all args other than first ignored for now; issue warn - why? why not?

code  = nil
year  = nil
info  = nil


if opts[:metal]
     code  = args[0]
     year  = opts[:season] ? opts[:season].to_i(10) : Time.now.year

     pp [code,year]
else
    key = args[0].downcase
    seasons =  LEAGUES[key]

    if seasons.nil?
        puts "!! ERROR - no league (info) found for key >#{key}<; known keys include:"
        pp LEAGUES.keys
        exit 1
    end

    season_key = if opts[:season]
                    Season.parse(opts[:season]).to_key
                 else
                     seasons.keys[0]  ## autopick latest
                 end

    info = seasons[season_key]

    if info.nil?
        puts "!! ERROR - no season >#{season_key}< found for league with key >#{key}<; known seasons include:"
        pp seasons.keys
        exit 1
    end

    pp info

    code = info.shortcut
    year = info.season
end


#############
### step 1 - download
   puts "==> downloading  /getmatchdata/#{code}/#{year}"
   data = Metal.matches( code, year )

   puts "   #{data.size} match(es)"
   pp data[0]    ## dump first match

##################
### step 2 - convert to football.txt

   body = Openliga._convert( data )

## add header
###
###  auto-add header
###    note - use leagueName from first match
  header =<<TXT
###
#  converted from openligadb.de json to Football.TXT
#    for source, see https://api.openligadb.de/getmatchdata/#{code}/#{year}

= #{data[0]['leagueName']}
TXT


   puts header+body

   if opts[:outpath]
       puts "  writing football.txt to >#{opts[:outpath]}<"
       write_text( opts[:outpath], header+body )
   end

   puts "bye"
end  ## self.main

end  ## module Tool
end  ## module Openliga
