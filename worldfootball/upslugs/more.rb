##################
# to run use:
#    ruby upslugs\more.rb


require_relative 'helper'


## auto-add .csv dataset if not (yet) available
## note - use force option to auto-update all!!



## lint slugs dir
###   check that all datasets have matching league config
paths = Dir.glob( './slugs/**/*.csv' )
paths.each do |path|
  basename = File.basename( path, File.extname( path ))

  slug = LEAGUE_TO_SLUG[basename]
  if slug.nil?
     puts "!! ERROR - no league found for >#{basename}<"
     exit 1
  end
end


LEAGUE_TO_SLUG.each do |league, slug|

  path = "./slugs/#{league}.csv"

  if File.exist?( path ) && !OPTS[:force]

      recs = read_csv( path )
    ## skip; do nothing
      print "OK  "
      print "  %3d " % recs.size
      print "%-12s" % league 
      print " via >#{slug}<"
      print "\n"
  else
    ## download
    Worldfootball::Metal.download_schedule( slug )  

    page = Worldfootball::Page::Schedule.from_cache( slug )
    ## pp page.seasons

    recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
    pp recs
    puts "  #{recs.size} record(s)"

    headers = ['season','slug']
    write_csv( path, recs, headers: headers  )
  end
end

puts
puts "   #{LEAGUE_TO_SLUG.size} league(s)"


puts "bye"