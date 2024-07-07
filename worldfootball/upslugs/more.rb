##################
# to run use:
#    ruby upslugs\more.rb


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'



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