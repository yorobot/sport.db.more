
## build tournament (schedule/match results)



def build_tour( matches:,
                title: )


       buf = String.new
       buf << "= #{title}\n"
       buf << "\n"

       ## add stats (block) if more than one match
       ##   e.g.    date:
       ##           teams:
       ##           matches:   etc.
       if matches.size > 1
         buf << build_stats( matches )
         buf << "\n"
       end


       last_stage = nil
       last_date = nil

       matches.each do |rec|

         ##################
         ##  (i) check for (optional) stage (nested record)
         stage_rec = rec['stage']
         stage = if stage_rec
                    stage_rec['stage']
                 else
                   nil
                 end


         if stage && stage != last_stage
           buf << "\n▪ #{stage}\n"
           ## note - reset last_date if new stage (stage introduces "new scope")
           last_date = nil
         elsif stage.nil? && last_stage != nil
           ## note - add unknown marker
           ##    if switching from stage to non-stage (nil) section!!!
           ##     helps with debugging missing stages for matches
           buf << "\n▪ ??\n"
         end

         last_stage = stage

         ###############
         ##  (ii) add date header
         date = rec['date']
         buf <<  "#{date.strftime('%a %b %-d')}\n"   if date != last_date

         last_date = date



         ## note - score might by empty (upcoming worldcup!!)
         score =  if (rec['home_score'].nil? || rec['home_score'].empty?) &&
                     (rec['away_score'].nil? || rec['away_score'].empty?)
                      ' v '
                  else
                     "#{rec['home_score']}-#{rec['away_score']}"
                  end

         ## e.g.   England            v Scotland
         ##
         ## check for long names e.g.
         ##   Republic of Ireland
         ##   Republic of St. Pauli
         ##   Trinidad and Tobago

         match =  String.new
         match +=  '%-22s' % rec['home_team']
         match +=  ' ' + score + ' '
         match +=  '%-22s' % rec['away_team']



    ### fix city
    ##     Name starting with ' - what to do?  should be possible change back later!!
    #         @ 'Atele, Tonga
         city = rec['city']
         city = "Atele"   if city == "‘Atele"

         geo   = "#{city}, #{rec['country']}"
         # if neutral  add (*) to geo
         #  geo   += " (*)"  if rec['neutral'] == 'TRUE'

         buf << "  #{match}   @ #{geo}"

         ## check for (nested) shootout - win on penalities
         shootout_rec = rec['shootout']
         if shootout_rec
            buf << "   [#{shootout_rec['winner']} wins on penalties]"
         end

         buf << "\n"


         goal_recs = rec['goals']
         if goal_recs
            buf << build_goals( goal_recs )
         end

       end
       buf << "\n"

       buf
end
