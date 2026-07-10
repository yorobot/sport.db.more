
def pp_stats( data, teams:, stadiums:,
                    opt_teams:  false,
                    opt_stadium: true )

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
    buf << "# Teams    #{teams.size}\n"
    if opt_teams
       teams.each do |rec|
          buf << "#   #{rec[:name]} (#{rec[:country]})\n"
       end
    end

    ######
    #    matches
    #     - number of teams
    buf << "# Matches  #{data.size}\n"


    #####
    #   venues
    #   - all stadiums

    if opt_stadium
      buf << "# Venues   #{stadiums.size}"
      cities = stadiums.cities
      buf << (cities.size == 1 ? " (in 1 city)" : " (in #{cities.size} cities)")
      buf << "\n"

      stadiums.each do |rec|
        buf << "#   #{rec[:name]}, #{rec[:city]} (#{rec[:country]})\n"
      end
    end


    buf
end
