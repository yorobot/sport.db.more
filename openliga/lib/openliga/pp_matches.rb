
module Openliga


  def self.pp_matches( matches )

    buf = String.new

    last_round = nil
    last_year  = nil
    last_date  = nil
    last_time  = nil

    matches.each do |m|
        ## add stage/round/group header
        if last_round.nil? || last_round != m.round
            buf << "\n▪ #{m.round}\n"
            last_date = nil
            last_time = nil
        end

        ## add date header
        if last_date.nil? || last_date != m.date
          ## note - only print year (on first time or if changed to new year)
          if last_year.nil? || last_year != m.date.year
             buf << "#{m.date.strftime('%a %b %-d %Y')}\n"
          else
             buf << "#{m.date.strftime('%a %b %-d')}\n"
          end
           last_time = nil
        end


        line = String.new

        if m.time
           if last_time && last_time == m.time
             line << "       "    ## note - do NOT repeat time if same as last
           else
             line << "  #{m.time}"
           end
        else
          line << '       '
        end

        line << "  %-24s v %-24s" % [m.team1, m.team2]
        line << "   #{m.score.to_s}"   if m.score


        if m.ground || m.city
          geo = [m.ground, m.city].compact  ## remove nils

          ## maybe use "smart" < -- if comma used already in ground
          line << "  @ #{geo.join(', ')}"
          ## only add attendance if stadium - why? why not
          if m.att && m.att > 0
             line << ",  Att: #{m.att}"
          end
        end

        buf << line.rstrip   ## note - remove trailing spaces
        buf << "\n"


        last_round = m.round
        last_year  = m.date.year
        last_date  = m.date
        last_time  = m.time
    end

    buf
  end
end ## module Openliga
