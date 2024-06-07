require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'


Webcache.root = '../../../cache'  ### c:\sports\cache





DATASETS = [
=begin
  ['eng.1',   %w[2023/24]],
  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],

  ['at.1',    %w[2023/24]],
  
  ['world',   %w[2022]],
  ['euro',    %w[2020]],
=end
# https://www.footballsquads.co.uk/usa/2024/usamls.htm

   ['us.1',  %w[2024 2023 2022 2021 2020 2019 2018 2017 2016 2015]],
]



DATASETS.each do |league, seasons|
  seasons.each do |season|

    league_page = Footballsquads.league( league: league, 
                                         season: season )
    pp league_page.title
    pp league_page.teams

    league_page.each_team do |team_page|
       pp team_page.title

=begin
       team_name         =  team_page.team_name
       pp team_name
       team_name_official = team_page.team_name_official
       pp team_name_official
=end
    
       current, past =  team_page.players
    
       puts "current (#{current.size}):"
       pp current
       puts "past (#{past.size}):"
       pp past 
    end 
  end
end


puts "bye"


