
def pp_stats( doc, opts:  )


    buf = String.new

    ####
    #    dates
    #   - start/end dates and duration in days

    start_date, end_date  = doc.calc_start_end_dates

    diff_in_days  =   end_date.jd   - start_date.jd
    diff_in_years =   end_date.year - start_date.year

    buf << "# Dates    "
    if diff_in_years > 0
      buf << "#{start_date.strftime('%a %b %-e %Y')} - #{end_date.strftime('%a %b %-e %Y')}"
    else
      buf << "#{start_date.strftime('%a %b %-e')} - #{end_date.strftime('%a %b %-e %Y')}"
    end
    buf << " (#{diff_in_days}d)\n"

    ########
    #    teams
    #    - number of matches
    buf << "# Teams    #{doc.teams.size}\n"

    if opts.show_teams?
       ##
       ## sort teams by country - why? why not?
       doc.teams.each do |team|
          buf << "#   #{team.name} (#{team.country})\n"
       end
    end

    ######
    #    matches
    #     - number of teams
    buf << "# Matches  #{doc.matches.size}\n"


    #####
    #   venues
    #   - all stadiums

    if opts.show_stadiums?
      buf << "# Venues   #{doc.stadiums.size}"
      cities = doc.stadiums.cities
      buf << (cities.size == 1 ? " (in 1 city)" : " (in #{cities.size} cities)")
      buf << "\n"

      doc.stadiums.each do |stadium|
        buf << "#   #{stadium.name}, #{stadium.city} (#{stadium.country})\n"
      end
    end


    buf
end
