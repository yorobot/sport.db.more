
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches(  season:,
                 slug:,
                 opt_country: false,
                 opt_stadium: true,
                 opt_teams: false  )

    data  =  read_json( "#{CACHE_DIR}/#{season}/#{slug}.json" )
   matches = data['matches']  ## only use results (match) array

   puts "  #{matches.size} match(es) in season #{season}"


   ## read in stages for sorting
   ##   incl.  SequenceOrder, StageLevel (optional)
   ## stages = Stages.new
   ## stages.add( read_json( "./#{slug}/misc/#{season}_stages.json" )['Results'] )

   matches = sort_matches( matches )



   teams = Teams.new
   teams.add( data['teams'] )
   puts "  #{teams.size} team(s) in season #{season}"

   stadiums = Stadiums.new
   stadiums.add( data['stadiums'] )
   puts "  #{stadiums.size} stadium(s) in season #{season}"



   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   buf << pp_stats( matches, teams: teams, stadiums: stadiums,
                              opt_teams: opt_teams,
                              opt_stadium: opt_stadium )
   buf << "\n"


last_round   = nil
last_group   = nil

last_date      = nil


matches.each_with_index do |m, i|

   ## note - always lookup full team records (use match inline only as refs)
  team1 = teams.find_by!( name: m['team1'] )
  team2 = teams.find_by!( name: m['team2'] )


    dateTime       = parse_date_utc( m['date_utc'] )    ## utc
    localDateTime  = parse_date_local( m['date_local'] )

     assert( dateTime.sec == 0 && localDateTime.sec == 0,
                "sec 00 expected" )

    ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
    diff_in_hours = ((localDateTime - dateTime) * 24).to_f
    diff_in_days  =  localDateTime.jd - dateTime.jd
    ## pp [diff_in_hours, diff_in_days]


#   stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )

## move to convert !!!
  ## resultType  = m['ResultType']
  ##  assert( [0, 1,2,3,4,8].include?(resultType), "resultType 1,2,3,4 expected; got #{resultType}" )

    score =  _fmt_score( m )

   stage   = m['stage']
   group   = m['group']     # optional
   num     = m['number']    # optional

   matchday    = m['matchday']  # optional

   ####
   ## note - make roundName  = stageName + matchDay (optional)
   round  = stage
   round += " - #{matchday}"   if matchday


   ## note - always lookup full stadium record (use match inline only as ref)
   stadium  =  stadiums.find!( m['stadium'] )

    attendance = m['attendance']




   if last_round.nil? || last_round != round

         buf << "\n"

         buf << "▪ #{round}\n"

        last_round = round
        last_group = nil
        last_date = nil
   end

   if group && (last_group.nil? || last_group != group)
      ## note - skip extra newline on first group
      buf << "\n"    if last_group

      buf << "▪▪ #{group}\n"

      last_group = group
      last_date = nil
   end



 ##
 ##  move to ppdebug (or ppdump??) !!
 #  buf = String.new
 #  buf << "             #{stageName}"
 #  buf <<  ", #{groupName}"  if groupName
 #  buf << " \##{matchDay}" if matchDay
 #  buf << " (#{matchNumber})"  if matchNumber


      if last_date && (last_date.year  == localDateTime.year &&
                       last_date.month == localDateTime.month &&
                       last_date.day   == localDateTime.day)
        ## skip date header if same (local) date
      else
          ## e.g.   Fri Jun 7
       buf << "#{localDateTime.strftime('%a %b %-e')}\n"
      end

     ## use   20:30 UTC+1  or 20:30 UTC-3
     buf <<  "  #{localDateTime.strftime( '%H:%M' )} UTC%+d" % diff_in_hours


     ##
     ##
     ## note - if score empty (e.g. '') use  A v B
     score = ' v '  if score.empty?

     if opt_country
        buf <<  "   #{team1[:name]} (#{team1[:country]})"
        buf <<  "  #{score}  "
        buf <<  "#{team2[:name]} (#{team2[:country]})   "
     else
        buf <<  "   #{team1[:name]}  #{score}  #{team2[:name]}   "
     end

     if opt_stadium
       buf << "@ #{stadium[:name]}, #{stadium[:city]}"
     else
       buf << "@ #{stadium[:city]}"
     end

      buf << "\n"


   last_date = localDateTime


    ## skip adding goals if teams not yet known!!
    ##  fix-fix-fix -- add more checks (e.g. ResultType = ??, MatchStatus = ??) !!!
    next  if m['team1']=='?' && m['team2']=='?'


    buf <<  pp_goals( m, indent:  17  )
  end

  buf
end
