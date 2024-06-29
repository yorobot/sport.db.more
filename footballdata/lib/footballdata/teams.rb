
###########
### export teams


module Footballdata

def self.export_teams( league:, season: )

    season      = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)
    league_code = LEAGUES[league.downcase]

    teams_url = Metal.competition_teams_url( league_code, 
                                             season.start_year )
    data_teams = Webcache.read_json( teams_url )

    ## build a (reverse) team lookup by name
    puts "#{data_teams['teams'].size} teams"



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

        alt_names = String.new
        alt_names << " | #{rec['shortName']}"  if rec['shortName'] &&
                                                  rec['shortName'] != rec['name'] &&
                                                  rec['shortName'] != rec['tla']

        alt_names << " | #{rec['tla']}"        if rec['tla'] &&
                                                  rec['tla'] != rec['name']
        
        if alt_names.size > 0
          buf << " "
          buf << alt_names
          buf << "\n"
        end

        ## clean null in address (or keep nulls) - why? why not?
        ##  e.g. null Rionegro null
        ##       Calle 104 No. 13a - 32 Bogotá null 

        buf << "  address: #{rec['address'].gsub( /\bnull\b/, '')}"
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
 