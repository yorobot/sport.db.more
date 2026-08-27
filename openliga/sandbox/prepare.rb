$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'  ### c:\sports\cache



## download (cache) all configured leagues

Openliga::LEAGUES.each do |code, seasons|

   puts "==> #{code} w/ #{seasons.size} season(s)"
   seasons.each_with_index do |(season, info), i|
      puts "  [#{i+1}/#{seasons.size}] #{season}:"
      pp info
      Openliga::download( league: code, season: season )
   end
end



puts "bye"