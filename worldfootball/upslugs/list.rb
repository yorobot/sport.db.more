##########
#  to run use:
#   $ ruby upslugs/list.rb


require_relative 'helper'


start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


# pages = Dir.glob( './dl/at*' )
pages = Dir.glob( "#{Webcache.root}/www.weltfussball.de/alle_spiele/*.html" )
puts "#{pages.size} pages"   #=> 3672 pages
puts



leagues = {}

pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   print "%-50s" % basename
   print " => "

   page = Worldfootball.find_page( basename )
   if page
     league_key = page[:league]
     season_key = page[:season]

     print "    "
     print "%-12s"    % league_key
     print "| %-10s"  % season_key
     print "\n"

     seasons = leagues[league_key] ||= []
     seasons << season_key   unless seasons.include?( season_key )
   else
     print "??"
     print "\n"
   end
end



end_time = Time.now
diff_time = end_time - start_time
puts "convert_all: done in #{diff_time} sec(s)"

puts "bye"
