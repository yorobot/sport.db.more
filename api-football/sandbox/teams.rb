
require_relative 'helper'



teams  = ApiFootball.teams( league: 'copa.l', season: '2023' )
## teams  = ApiFootball.teams( league: 'world', season: '2022' )

pp teams


#### lookup country codes for teams

teams['response'].each do |rec|

   team_name    = rec['team']['name'] 
   team_country = rec['team']['country']

   cty = Fifa.world.find_by_name( team_country )
   if cty.nil?
     pp rec['team']
     puts "!! ERROR - no country found for >#{team_country}<"
     exit 1
   end

   puts "   #{team_name}, #{team_country} => (#{cty.code})"
end


puts "bye"

__END__

    ####
    #   auto-add (fifa) country code if int'l club tournament
    if clubs_intl
        ##
        ##   get country codes for team ref
              teams_by_ref.each do |team_slug, h|
                 Metal.download_team( team_slug, cache: true )
                 team_page = Page::Team.from_cache( team_slug )
                 props = team_page.props
                 pp props
                 country_name = props[:country]
                 cty = Fifa.world.find_by_name( country_name )
                 if cty.nil?
                   puts "!! ERROR - no country found for #{country_name}"
                   exit 1
                 end
                 h[:code] = cty.code
              end
       
              ## generate lookup by name
              teams_by_name = teams_by_ref.reduce( {} ) do |h, (slug,rec)|
         ### todo/fix
         ##    report warning if names size is > 1!!!!
         ##
                    rec[:names].each do |name|
                       h[ name ] = rec
                     end
                     h
              end
       
       
