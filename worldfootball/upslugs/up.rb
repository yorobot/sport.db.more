##################
# to run use:
#    ruby upslugs\up.rb


require_relative 'helper'



###########
### todo/fix
###  move league_to_slug  to leagues.rb  file for (re)use!!!
##    and fold in more.rb etc.

## league to slug/page
league_to_slug = {

  ### British Isles / Western Europe
  'eng.1'  => 'eng-premier-league-2024-2025',
  'eng.2'  => 'eng-championship-2024-2025',
  'ie.1' =>  'irl-premier-division-2024',
  'sco.1'  => 'sco-premiership-2024-2025',

 ### Northern Europe
  'se.1' => 'swe-allsvenskan-2024',
  'se.2' => 'swe-superettan-2024', 
  'fi.1' => 'fin-veikkausliiga-2024',
  'dk.1' => 'den-superliga-2024-2025',
  
 ### Benelux / Western Europe
  'nl.1' => 'ned-eredivisie-2024-2025',
  'be.1'    => 'bel-eerste-klasse-a-2024-2025',
  'be.2'    => 'bel-eerste-klasse-b-2024-2025',
  'be.cup'  => 'bel-beker-van-belgie-2023-2024',
  'lu.1' => 'lux-nationaldivision-2024-2025',
   
 #### Central Europe
   'at.1'    => 'aut-bundesliga-2024-2025',
   'at.2'    => 'aut-2-liga-2024-2025',
   'at.cup'  => 'aut-oefb-cup-2024-2025',
   'at.3.o'  => 'aut-regionalliga-ost-2024-2025',
   'ch.1'  =>  'sui-super-league-2024-2025',
   'ch.2'  =>  'sui-challenge-league-2024-2025',
   'hu.1'  =>  'hun-nb-i-2024-2025',
   'cz.1'  =>  'cze-1-fotbalova-liga-2024-2025',
   'pl.1'  =>  'pol-ekstraklasa-2024-2025',
   
 ### Southern Europe
   'pt.1' => 'por-primeira-liga-2023-2024',
    'pt.2' => 'por-segunda-liga-2023-2024',
    
  'gr.1' => 'gre-super-league-2023-2024',
  'tr.1' => 'tur-sueperlig-2023-2024',
  
 ### Eastern Europe
 'ro.1' => 'rou-liga-1-2023-2024',
 'ru.1' => 'rus-premier-liga-2024-2025',
 
 ### Asia
 'cn.1' => 'chn-super-league-2024',
 'jp.1' => 'jpn-j1-league-2024', 
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



puts "bye"