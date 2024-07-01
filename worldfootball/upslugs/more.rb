##################
# to run use:
#    ruby upslugs\more.rb

$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../sportdb-writers/lib' )

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


puts "NAME          : #{$PROGRAM_NAME}"
puts "-- optparse:"

OPTS = {}
parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGAM_NAME} [options]"

  parser.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end
end
parser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts


Webcache.root = '../../../cache'  ### c:\sports\cache




more_league_to_slug = {
}



more_league_to_slug.each do |league, slug|

  Worldfootball::Metal.download_schedule( slug )  

  page = Worldfootball::Page::Schedule.from_cache( slug )

  pp page.seasons


  recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
  pp recs
  puts "  #{recs.size} record(s)"

  headers = ['season','slug']
  write_csv( "./slugs/#{league}.csv", recs, headers: headers  )
end


puts "bye"