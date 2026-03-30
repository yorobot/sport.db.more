
def pp_stats( data, opt_teams: false )

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
    collect_teams( data, teams )

    buf << "# Teams    #{teams.size}\n"
    if opt_teams
       teams.recs( sort: false ).each do |rec|
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
    stadiums = Stadiums.new
    collect_stadiums( data, stadiums )

    buf << "# Venues   #{stadiums.size}"
    cities = stadiums.cities
    buf << (cities.size == 1 ? " (in 1 city)" : " (in #{cities.size} cities)")
    buf << "\n"


    stadiums.recs.each do |rec|
       buf << "#   #{rec[:name]}, #{rec[:city_name]} (#{rec[:id_country]})\n"
    end
    
    buf
end



