
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches(  season:,
                 slug:,
                 opt_country: false,
                 opt_city:    true,
                 opt_stadium: true,
                 opt_teams: false,
                 opt_timezone: true,
                 indir: '.'  )


    season = Season( season )


    doc = Document.read( "#{indir}/#{season.to_path}/#{slug}.json" )


    ## matches = data['matches']  ## only use results (match) array

   ## puts "  #{matches.size} match(es) in season #{season}"


   ## read in stages for sorting
   ##   incl.  SequenceOrder, StageLevel (optional)
   ## stages = Stages.new
   ## stages.add( read_json( "./#{slug}/misc/#{season}_stages.json" )['Results'] )

   ## matches = sort_matches( matches )






   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   ## buf << pp_stats( matches, teams: teams, stadiums: stadiums,
   ##                           opt_teams: opt_teams,
   ##                           opt_stadium: opt_stadium )
   buf << "\n"


last_round   = nil
last_date    = nil


doc.each_match do |m|


#   stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )

## move to convert !!!
  ## resultType  = m['ResultType']
  ##  assert( [0, 1,2,3,4,8].include?(resultType), "resultType 1,2,3,4 expected; got #{resultType}" )

    score = ''  ## _fmt_score( _m )

   ####
   ## note - make roundName  = stageName + groupName (optional) +  matchDay (optional)
   round  = m.stage
   round += ", #{m.group}"       if m.group
   round += " - #{m.matchday}"   if m.matchday



   if last_round.nil? || last_round != round

         buf << "\n"

         buf << "▪ #{round}\n"

        last_round = round
        last_date  = nil
   end


 ##
 ##  move to ppdebug (or ppdump??) !!
 #  buf = String.new
 #  buf << "             #{stageName}"
 #  buf <<  ", #{groupName}"  if groupName
 #  buf << " \##{matchDay}" if matchDay
 #  buf << " (#{matchNumber})"  if matchNumber


      if last_date && (last_date.year  == m.date_local.year &&
                       last_date.month == m.date_local.month &&
                       last_date.day   == m.date_local.day)
        ## skip date header if same (local) date
      else
          ## e.g.   Fri Jun 7
       buf << "#{m.date_local.strftime('%a %b %-e')}\n"
      end

     ##  always print time for now
     if opt_timezone
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

     if opt_country
        buf <<  "   #{m.team1.name} (#{m.team1.country})"
        buf <<  "  #{score}  "
        buf <<  "#{m.team2.name} (#{m.team2.country})   "
     else
        buf <<  "   #{m.team1.name}  #{score}  #{m.team2.name}   "
     end


     if opt_stadium      ## stadium PLUS city
       buf << "@ #{m.stadium.name}, #{m.stadium.city}"
     elsif opt_city      ## city only
       buf << "@ #{m.stadium.city}"
     else
        ## add nothing
     end

      buf << "\n"


   last_date = m.date_local


    ## skip adding goals if teams not yet known!!
    ##  fix-fix-fix -- add more checks (e.g. ResultType = ??, MatchStatus = ??) !!!
    next   if m.team1.dummy? || m.team2.dummy?


     buf <<  pp_goals( m.data, indent:  17  )
  end

  buf
end
