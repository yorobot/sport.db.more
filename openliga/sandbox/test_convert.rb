#####
#  to run use
#   $ ruby sandbox/test_convert.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'  ### c:\sports\cache



## recs = Openliga::convert( league: 'euro', season: '2024' )

## recs = Openliga::convert( league: 'southamerica', season: '2024' )


## recs = Openliga::convert( league: 'de.cup', season: '2024/25' )


## buf = Openliga::convert( league: 'de.1', season: '2020/21' )
## buf = Openliga::convert( league: 'de.cup', season: '2026/27' )
## buf = Openliga::convert( league: 'de.cup', season: '2025/26' )
## buf = Openliga::convert( league: 'de.cup', season: '2024/25' )
## puts buf



Openliga::LEAGUES.each do |code, seasons|

   puts "==> #{code} w/ #{seasons.size} season(s)"
   seasons.each_with_index do |(season, info), i|
      puts "  [#{i+1}/#{seasons.size}] #{season}:"
      pp info
      buf = Openliga::convert( league: code, season: season )

      season = Season( season )
      outpath = "./tmp/#{season.to_path}_#{code}.txt"
      write_text( outpath, buf )
   end
end


puts "bye"