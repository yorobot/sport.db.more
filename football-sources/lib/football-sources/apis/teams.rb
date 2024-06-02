require 'cocos'   ## fix - add  in  main require page for all !!!



module Footballdata

### export teams


def self.export_teams( league:, season: )

    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)
  
    data_teams = Webcache.read_json( MetalV4.competition_teams_url(  
                                  LEAGUES[league.downcase], season.start_year ))

    ## build a (reverse) team lookup by name
    puts "#{data_teams['teams'].size} teams"

=begin
      "address": "null null null",
      "website": null,
      "founded": null,
      "clubColors": null,
      "venue": null,
=end

  

    clubs = {}   ## by country

    data_teams['teams'].each do |rec|
    
        buf = String.new  ### use for string buffer (or String.new('') - why? why not?      
        buf << "#{rec['name']}"
        buf << ", #{rec['founded']}"  if rec['founded']
        if rec['venue'] 
          buf << ", @ #{rec['venue']}"   
          # buf << "  # #{rec['area']['name']}"
        end
        buf << "\n"
        buf << " "
        buf << " | #{rec['shortName']}"  if rec['shortName'] != rec['name']  
        buf << " | #{rec['tla']}"
        buf << "\n"
        buf << "  address: #{rec['address']}"
        buf << "\n"
        buf << "  web:     #{rec['website']}"
        buf << "\n"
        buf << "  colors:  #{rec['clubColors']}"
        buf << "\n"

        country = rec['area']['name'] 
        ary = clubs[ country] ||= []
        ary << buf
    end
    # puts buf
   
    ## pp clubs

  
    buf = String.new

    if clubs.size > 1
      clubs.each do |country, ary|
        buf << "#  #{country} - #{ary.size} clubs\n"
      end  
      buf << "\n"
    end

    clubs.each do |country, ary|
      buf << "= #{country}    # #{ary.size} clubs\n\n"
      buf << ary.join( "\n" )
      buf << "\n\n"
    end

    path = "#{config.convert.out_dir}/#{season.to_path}/#{league.downcase}.clubs.txt"
    write_text( path, buf )                            
end


end  # module Footballdata
 