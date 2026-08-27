
module Openliga


  def self.pp_matches( matches )

    buf = String.new

    last_round = nil
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
           buf << "#{m.date.strftime('%a %b %-d %Y')}\n"
           last_time = nil
        end

        if m.time
           if last_time && last_time == m.time
             buf << "       "    ## note - do NOT repeat time if same as last
           else
             buf << "  #{m.time}"
           end
        else
          '       '
        end

        buf << "  %-24s v %-24s" % [m.team1, m.team2]
        buf << "   #{m.score.to_s}"   if m.score


        if m.ground || m.city
          geo = [m.ground, m.city].compact  ## remove nils

          ## maybe use "smart" < -- if comma used already in ground
          buf << "  @ #{geo.join(', ')}"
          ## only add attendance if stadium - why? why not
          if m.att && m.att > 0
             buf << ",  Att: #{m.att}"
          end
        end


        buf << "\n"

        last_round = m.round
        last_date  = m.date
        last_time  = m.time
    end

    buf
  end
end ## module Openliga
