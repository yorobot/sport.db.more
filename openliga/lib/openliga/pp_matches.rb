
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

####
##     check for goals


        if m.goals.is_a?(Array) && m.goals.size > 0

## note - filter out penalties from penalty shootout
##         SG Sonnenhof Großaspach  v DSC Arminia Bielefeld      2-2 aet (2-2, 1-2), 5-2 pen
##            (3-2 Arbnor Nuraj (p)
##             4-2 Luca Molinari (p)
##             5-2 Franz Xaver Bleicher (p)

       goals =   if m.score && m.score.et? && m.score.pen?
                     m.goals.select do |goal|
                         if goal.score[0] <= m.score.et[0] &&
                            goal.score[1] <= m.score.et[1]
                               true
                         else
                             puts "!! WARN - ignoring penalty shootout goal - #{goal.to_s}"
                               false
                         end
                      end
                 else
                    m.goals
                 end

   ###
   ##  check if goals have any player names or minutes
   ##         if none - skip print of goals
         has_goal_details =  false
         goals.each do |goal|
             if goal.name || goal.m
                has_goal_details = true
                break
             end
         end



         if has_goal_details

           ###
           ### note - sort goals first (might not be in order!)
           ##        use total of goals e.g. [0,1] => 1 [2,2] => 4 etc.

           goals = goals.sort do |l,r|
                                    l_sum = l.score[0]+l.score[1]
                                    r_sum = r.score[0]+r.score[1]
                                    l_sum <=> r_sum
                               end

          goals.each_with_index do |goal,i|
               line = String.new

               if  i == 0
                 line << "            ("
               else
                 line << "             "
               end

               line << goal.to_s

               line  << ")"   if  i+1 == goals.size

               buf << line
               buf << "\n"
            end
          else
            puts "!! WARN - skipping goals line w/o details (name, minute, etc.)"
          end
        end



        last_round = m.round
        last_year  = m.date.year
        last_date  = m.date
        last_time  = m.time
    end

    buf
  end
end ## module Openliga
