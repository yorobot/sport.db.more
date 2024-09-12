
module Fbtxt
def self.main( args=ARGV )


opts = {
}

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options]"
end
parser.parse!( args )

puts "OPTS:"
p opts
puts "ARGV:"
p args


matches = []

## step 1 - get all matches via csv
args.each do |arg|
   path = arg
   puts "==> reading matches in #{path} ..."
   more_matches = SportDb::CsvMatchParser.read( path )
   matches += more_matches
end

puts "#{matches.size} matches"
puts

txt = SportDb::TxtMatchWriter.build( matches )
puts txt
puts
end
end # module Fbtxt