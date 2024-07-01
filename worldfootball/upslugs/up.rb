##################
# to run use:
#    ruby upslugs\up.rb


require 'pp'
require 'optparse'


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


## league to slug/page
league_to_slug = {
    'eng.1'  => 'eng-premier-league-2024-2025',
    'eng.2'  => 'eng-championship-2024-2025',

    'be.1'    => 'bel-eerste-klasse-a-2024-2025',
    'be.2'    => 'bel-eerste-klasse-b-2024-2025',
    'be.cup'  => 'bel-beker-van-belgie-2023-2024',

    'at.1'    => 'aut-bundesliga-2024-2025',
    'at.2'    => 'aut-2-liga-2024-2025',
    'at.cup'  => 'aut-oefb-cup-2024-2025',
}



league  = ARGV[0] || 'eng.1'

slug = league_to_slug[league]

if slug.nil?
    puts "!! ERROR - no slug / page configured for league >#{league}<; sorry"
    exit 1 
end



Worldfootball::Metal.download_schedule( slug )    if OPTS[:download]

page = Worldfootball::Page::Schedule.from_cache( slug )

pp page.seasons

=begin
[{:text=>"2024/2025", :ref=>"aut-oefb-cup-2024-2025"},
 {:text=>"2023/2024", :ref=>"aut-oefb-cup-2023-2024"},
 {:text=>"2022/2023", :ref=>"aut-oefb-cup-2022-2023"},
 {:text=>"2021/2022", :ref=>"aut-oefb-cup-2021-2022"},
=end

recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
pp recs
puts "  #{recs.size} record(s)"

headers = ['season','slug']
write_csv( "./slugs/#{league}.csv", recs, headers: headers  )



__END__

# Worldfootball.config.convert.out_dir = './o'

Worldfootball.convert( league: league,
                       season: season )


Writer.config.out_dir = './tmp'

Writer.write( league: league,
              season: season,
              normalize: false,
                  source: Worldfootball.config.convert.out_dir )


puts "bye"