require_relative 'squads_helper'



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

league_urls = leagues.map {|rec| rec['league_url'] }


league_urls.each_with_index do |league_url,i|
    league_relative_url = URI.parse( league_url ).request_uri
    
    puts "==> [#{i+1}/#{league_urls.size}]   #{league_relative_url} ..."

    league_page = Footballsquads::Page::League.get( league_url )
    puts league_page.title
  
    league_page.each_team do |team_page|
      puts '    ' + team_page.title
    end 
end


puts "bye"


