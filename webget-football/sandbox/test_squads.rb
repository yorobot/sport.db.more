require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'


Webcache.root = '../../../cache'  ### c:\sports\cache





DATASETS = [
  ['eng.1',   %w[2023/24]],
  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],

  ['at.1',    %w[2023/24]],
]



DATASETS.each do |league, seasons|
  seasons.each do |season|

    league_page = Footballsquads.league( league: league, 
                                         season: season )
    pp league_page.title
    
    league_page.each_team do |team_page|
       pp team_page.title
    
       team_name         =  team_page.team_name
       pp team_name
       team_name_official = team_page.team_name_official
       pp team_name_official
    
       current, past =  team_page.players
    
       puts "current (#{current.size}):"
       pp current
       puts "past (#{past.size}):"
       pp past 
    end 
  end
end


puts "bye"


