require_relative 'squads_helper'


Webcache.root = '../../../cache'  ### c:\sports\cache

Webget.config.sleep = 1  ## set to 1 second


# outdir = "./tmp/cache.footballsquads"
outdir = "../../../footballcsv/cache.footballsquads"




# page = Footballsquads.current_squads
# page = Footballsquads.national_squads
page = Footballsquads.archive_squads

pp page.title
leagues =  page.leagues

=begin
## for debugging
leagues = [
    {
    'league_url' => 'https://www.footballsquads.co.uk/eng/1998-1999/faprem.htm',
    'league_relative_url' => 'eng/1998-1999/faprem.htm',
    'league_name'  => '1998/99'        
    }
]
=end

pp leagues

## get league urls
league_urls  = leagues.map { |rec| rec['league_url'] }
pp league_urls
puts "    #{league_urls.size} page(s)"



write_squads( league_urls, outdir: outdir )


puts "bye"


