
## build tournament (schedule/match results)


def build_tour( tournament:,
                year:,
                matches:,
                goals:,
                shootouts: )

       buf = String.new
       buf << "= #{tournament} #{year}\n"


       ## add stats if more than one match
       if matches.size > 1
         stats = calc_stats( matches )

         buf << "\n"
         buf << "# Date       "
         start_date = stats['date']['start_date']
         end_date   = stats['date']['end_date']
         if start_date.year != end_date.year
           buf << "#{start_date.strftime('%a %b/%-d %Y')} - #{end_date.strftime('%a %b/%-d %Y')}"
         else
           buf << "#{start_date.strftime('%a %b/%-d')} - #{end_date.strftime('%a %b/%-d %Y')}"
         end
         buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
         buf << "\n"

         buf << "# Teams      #{stats['teams'].size}\n"
         buf << "# Matches    #{matches.size}\n"
       end

       buf << "\n"

       last_date = nil
       matches.each do |rec|
         match = "#{rec['home_team']} - #{rec['away_team']}"
         score = "#{rec['home_score']}-#{rec['away_score']}"


### fix city
##     Name starting with ' - what to do?
#         @ 'Atele, Tonga
          city = rec['city']
          city = "Atele"   if city == "‘Atele"

         geo   = "#{city}, #{rec['country']}"
         # if neutral  add (*) to geo
         #  geo   += " (*)"  if rec['neutral'] == 'TRUE'

         date = Date.strptime( rec['date'], '%Y-%m-%d')
         buf <<  "[#{date.strftime('%a %b %-d')}]\n"   if date != last_date
         buf << "  #{match}  #{score}   @ #{geo}"



         ## check for win on penalities
         key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
         shootout = shootouts[key]
         if shootout
            buf << "   [#{shootout['winner']} wins on penalties]"
         end
         buf << "\n"


         goal_recs = goals[key]
         if goal_recs
            buf << build_goals( goal_recs )
         end

         last_date = date
       end
       buf << "\n"

       buf
end
