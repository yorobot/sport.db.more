
def pp_stats( data, opt_teams: false,
                    opt_stadiums: true )

    buf = String.new

    ####
    #    dates  
    #   - start/end dates and duration in days
    dates = { start: nil, end: nil }
    collect_dates( data, dates )

    diff_in_days =   dates[:end].jd - dates[:start].jd  
    buf << "# Dates    #{dates[:start].strftime('%a %b %-e')} - #{dates[:end].strftime('%a %b %-e %Y')} (#{diff_in_days}d)\n"

    ########
    #    teams
    #    - number of matches
    teams = Teams.new
    teams.add( data )

    buf << "# Teams    #{teams.size}\n"
    if opt_teams
       teams.each( sort: false ) do |rec|
          buf << "#   #{rec[:name]} (#{rec[:country]})\n"
       end
    end

    
    ######
    #    matches
    #     - number of teams
    buf << "# Matches  #{data.size}\n"


    #####
    #   venues
    #   - get all stadiums

    if opt_stadiums
      stadiums = Stadiums.new
      stadiums.add( data )

      buf << "# Venues   #{stadiums.size}"
      cities = stadiums.cities
      buf << (cities.size == 1 ? " (in 1 city)" : " (in #{cities.size} cities)")
      buf << "\n"


      stadiums.each do |rec|
        buf << "#   #{rec[:name]}, #{rec[:city_name]} (#{rec[:id_country]})\n"
      end
    end

    
    buf
end


