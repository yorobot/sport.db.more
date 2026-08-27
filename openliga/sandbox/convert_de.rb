#####
#  to run use
#   $ ruby sandbox/test_convert.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = './cache'  ### c:\sports\cache



## outdir = "./tmp2"
outdir = "/sports/openfootball/deutschland/openliga"


['de.1', 'de.2', 'de.3', 'de.cup'].each do |code|

   seasons = Openliga::LEAGUES[ code ]
   puts "==> #{code} w/ #{seasons.size} season(s)"

   seasons.each_with_index do |(season, info), i|
      puts "  [#{i+1}/#{seasons.size}] #{season}:"
      pp info
      buf = Openliga::convert( league: code, season: season )

      season = Season( season )

      outpath = "#{outdir}/#{season.to_path}_#{code}.txt"
      write_text( outpath, buf )
   end
end


puts "bye"