require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'


Webcache.root = '../../../cache'  ### c:\sports\cache


# page = Footballsquads.current_squads
# page = Footballsquads.national_squads
page = Footballsquads.archive_squads

pp page.title
leagues =  page.leagues


## for debugging
=begin
leagues = [
    {
    'league_url' => 'https://www.footballsquads.co.uk/eng/1998-1999/faprem.htm',
    'league_relative_url' => 'eng/1998-1999/faprem.htm',
    'league_name'  => '1998/99'        
    }
]
=end

pp leagues


outdir = "./tmp/cache.footballsquads"

# outdir = "../../../footballcsv/cache.footballsquads"



leagues.each do |league|
    league_url          = league['league_url']
    league_relative_url = league['league_relative_url']
    league_name         = league['league_name']

    puts "==> #{league_name} @ #{league_relative_url} ..."


    league_page = Footballsquads::Page::League.get( league_url )
    league_title =  league_page.title
    pp league_title
 
   league_page.each_team do |team_page|
       team_title = team_page.title
       team_title = team_title.sub( 'FootballSquads - ', '' ).strip
       pp team_title
    end 
end


puts "bye"


