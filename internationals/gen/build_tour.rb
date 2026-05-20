
## build tournament (schedule/match results)


def build_tour( tournament:,
                year:,
                matches:,
                goals:,
                shootouts:,
                stages: )


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
           buf << "#{start_date.strftime('%a %b %-d %Y')} - #{end_date.strftime('%a %b %-d %Y')}"
         else
           buf << "#{start_date.strftime('%a %b %-d')} - #{end_date.strftime('%a %b %-d %Y')}"
         end
         buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
         buf << "\n"

         buf << "# Teams      #{stats['teams'].size}\n"
         buf << "# Matches    #{matches.size}\n"
       end

       buf << "\n"


       last_stage = nil
       last_date = nil
       matches.each do |rec|

         ##################
         ## check for stage (record
         key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
         stage_rec = stages[key]
         stage = if stage_rec
                    stage_rec['stage']
                 else
                   nil
                 end

         ## note - reset last_date if new stage (stage introduces "new scope")
         last_date = nil   if stage && stage != last_stage


         ## e.g.   England            v Scotland
         ##
         ## check for long names e.g.
         ##   Republic of Ireland
         ##   Republic of St. Pauli
         ##   Trinidad and Tobago

         match =  String.new
         match +=  '%-20s' % rec['home_team']
         match +=  ' v '
         match +=  '%-20s' % rec['away_team']

         ## note - score might by empty (upcoming worldcup!!)
         score =  if (rec['home_score'].nil? || rec['home_score'].empty?) &&
                     (rec['away_score'].nil? || rec['away_score'].empty?)
                      '   '
                  else
                     "#{rec['home_score']}-#{rec['away_score']}"
                  end

### fix city
##     Name starting with ' - what to do?
#         @ 'Atele, Tonga
          city = rec['city']
          city = "Atele"   if city == "‘Atele"

         geo   = "#{city}, #{rec['country']}"
         # if neutral  add (*) to geo
         #  geo   += " (*)"  if rec['neutral'] == 'TRUE'


         buf << "▪ #{stage}\n"    if stage && stage != last_stage

         ## add unknown marker if switching from stage to non-stage (nil) section!!!
         buf << "▪ ??\n"     if stage.nil? && last_stage != nil

         last_stage = stage


         date = Date.strptime( rec['date'], '%Y-%m-%d')
         buf <<  "#{date.strftime('%a %b %-d')}\n"   if date != last_date
         buf << "  #{match}  #{score}   @ #{geo}"



         ############
         ## check for win on penalities
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
