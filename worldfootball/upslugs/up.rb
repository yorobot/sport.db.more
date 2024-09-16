##################
# to run use:
#    ruby upslugs\up.rb


require_relative 'helper'





league  = ARGV[0] || 'eng.1'

slug = LEAGUE_TO_SLUG[league]

if slug.nil?
    puts "!! ERROR - no slug / page configured for league >#{league}<; sorry"
    exit 1
end

puts "==> #{league} - using page/slug >#{slug}<"


Worldfootball::Metal.download_schedule( slug )


page = Worldfootball::Page::Schedule.from_cache( slug )

## pp page.seasons

=begin
[{:text=>"2024/2025", :ref=>"aut-oefb-cup-2024-2025"},
 {:text=>"2023/2024", :ref=>"aut-oefb-cup-2023-2024"},
 {:text=>"2022/2023", :ref=>"aut-oefb-cup-2022-2023"},
 {:text=>"2021/2022", :ref=>"aut-oefb-cup-2021-2022"},
=end

recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
pp recs
puts "  #{recs.size} record(s)"


## note - only update local csv dataset on download

headers = ['season','slug']
write_csv( "./slugs/#{league}.csv", recs, headers: headers  )


puts "bye"