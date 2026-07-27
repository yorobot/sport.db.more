
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)


def pp_matches(  season:,
                 slug:,
                 opts:,
                 indir: '.'  )


    season = Season( season )


    doc = Document.read( "#{indir}/#{season.to_path}/#{slug}.json" )




   buf = String.new


   ## add stats block (dates, teams, matches, venues, etc.)
   buf << pp_stats( doc,  opts: opts )
   buf << "\n"


last_round   = nil
last_date    = nil
last_year    = nil   ## track running year


doc.each_match do |m|


#   stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )


   ####
   ## note - make round
   ##         =  stage  +  group (optional)  +  matchday (optional)
   round  = m.stage
   round += ", #{m.group}"       if m.group
   round += " - #{m.matchday}"   if m.matchday



   if last_round.nil? || last_round != round

         buf << "\n"

         buf << "▪ #{round}\n"

        last_round = round
        last_date  = nil
   end



      if last_date && (last_date.year  == m.date_local.year &&
                       last_date.month == m.date_local.month &&
                       last_date.day   == m.date_local.day)
        ## skip date header if same (local) date
      else
          ## e.g.   Fri Jun 7   -or-   Fri Jun 7 2026
            if last_year.nil? || last_year != m.date_local.year
                 buf << "#{m.date_local.strftime('%a %b %-e %Y')}\n"
            else
                 buf << "#{m.date_local.strftime('%a %b %-e')}\n"
            end
      end


     ##  always print time for now
     if opts.timezone?
         ## use   20:30 UTC+1  or 20:30 UTC-3
         buf <<  "  #{m.date_local.strftime( '%H:%M' )} UTC%+d" % m.diff_in_hours
     else
         buf <<  "  #{m.date_local.strftime( '%H:%M' )}"
     end


     ##
     ##
     ## note - if score empty (e.g. '') use  A v B
     score =   if m.score
                  m.score.to_s
               else
                  ' v '
               end

     if opts.country?
        buf <<  "   #{m.team1.name} (#{m.team1.country})"
        buf <<  "  #{score}  "
        buf <<  "#{m.team2.name} (#{m.team2.country})   "
     else
        buf <<  "   #{m.team1.name}  #{score}  #{m.team2.name}   "
     end


     if opts.stadium?      ## stadium PLUS city
       buf << "@ #{m.stadium.name}, #{m.stadium.city}"
     elsif opts.city?      ## city only
       buf << "@ #{m.stadium.city}"
     else
        ## add nothing
     end

      buf << "\n"


   last_date = m.date_local
   last_year = m.date_local.year


    ## skip adding goals if teams not yet known!!
    ##  fix-fix-fix -- add more checks (e.g. ResultType = ??, MatchStatus = ??) !!!
    next   if m.team1.dummy? || m.team2.dummy?


     buf <<  pp_goals( m, indent:  17  )
  end

  buf
end
