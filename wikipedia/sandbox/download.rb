##
#  download wikitext pages (.txt)
#     content_type: text/x-wiki
#
#  to run use:
#    $ ruby sandbox/download.rb


require_relative 'helper'


titles = [
=begin
### 1930
  '1930_FIFA_World_Cup_Group_1',
  '1930_FIFA_World_Cup_Group_2',
  '1930_FIFA_World_Cup_Group_3',
  '1930_FIFA_World_Cup_Group_4',
  '1930_FIFA_World_Cup_knockout_stage',
  '1930_FIFA_World_Cup_final', 

### 2022
  '2022_FIFA_World_Cup_Group_A',
  '2022_FIFA_World_Cup_Group_B',
  '2022_FIFA_World_Cup_Group_C',
  '2022_FIFA_World_Cup_Group_D',
  '2022_FIFA_World_Cup_Group_E',
  '2022_FIFA_World_Cup_Group_F',
  '2022_FIFA_World_Cup_Group_G',
  '2022_FIFA_World_Cup_Group_H',
  '2022_FIFA_World_Cup_knockout_stage',
  '2022_FIFA_World_Cup_final',
=end
]




titles.each do |title| 
  puts "==> #{title}"
  page = Wikiscript.get( title )
  pp page

  slug = slugify( title )
  path = "./pages/match/#{slug}.txt"
  write_text( path, page.text )

  secs = 1
  puts " sleeps #{secs} sec(s)"
  sleep( secs )  ## wait 
end


puts "bye"

