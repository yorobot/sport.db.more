##########
#  to run use:
#   $ ruby upslugs/preload.rb

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


Webcache.config.root = '../../../cache'


Webget.config.sleep = 3



def preload( slug )
  ## note: check if passed in slug is cached too (if not - preload / download too)
  url = Worldfootball::Metal.schedule_url( slug )  
  if Webcache.cached?( url )
    print "   OK "
  else
    Worldfootball::Metal.download_schedule( slug ) 
    print "      "
  end

   page = Worldfootball::Page::Schedule.from_cache( slug )

   print "%-46s" % slug
   print '  /  '
   ## clean-up title/strip "» Spielplan" from title
   print page.title.sub('» Spielplan', '').strip
   
=begin   
   print '  -  '
   ## check for match count
   matches = page.matches
   print "#{matches.size} match(es)"
=end
   print "\n"
end # method preload



datafiles = Dir.glob( "./slugs/**/*.csv" )
pp datafiles

puts  "   #{datafiles.size} datafile(s)"




datafiles.each_with_index do |path, i|

  league = File.basename(path, File.extname(path))
  puts "==> [#{i+1}/#{datafiles.size}] #{league}..."
  recs = read_csv( path )
  puts "  #{recs.size} record(s)"

  recs.each_with_index do |rec,j|
    slug = rec['slug']
    puts "  #{league} [#{j+1}/#{recs.size}] >#{slug}<"
    preload( slug )
  end
end


puts "bye"
