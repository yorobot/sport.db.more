
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches_min(  season:,
                 slug:,
                 opt_country: false,
                 opt_stadium: false,
                 opt_teams: false  )

   data =  read_json( "#{CACHE_DIR}/#{season}/#{slug}.json" )
   matches = data['matches']

   puts "  #{matches.size} match(es) in season #{season}"


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



 last_round  = nil
 last_group  = nil

matches.each_with_index do |m, i|

   ## note - always lookup full team records (use match inline only as refs)
  team1 = teams.find_by!( name: m['team1'] )
  team2 = teams.find_by!( name: m['team2'] )


   dateTime       = parse_date_utc( m['date_utc'] )    ## utc
   localDateTime  = parse_date_local( m['date_local'] )

     assert( dateTime.sec == 0 && localDateTime.sec == 0,
                "sec 00 expected" )

    score = _fmt_score( m )

   stage     = m['stage']
   group     = m['group']       # optional
   num       = m['num']         # optional
   matchday  =  m['matchday']   # optional

     ####
   ## note - make roundName  = stageName + matchDay (optional)
   round  = stage
   round += " - #{matchday}"   if matchday


#  stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )




   if last_round.nil? || last_round != round

         buf << "\n"

         buf << "▪ #{round}\n"

        last_round = round
        last_group = nil
   end

   if group && (last_group.nil? || last_group != group)

      ## note - skip extra newline on first group
      buf << "\n"    if last_group

      buf << "▪▪ #{group}\n"

      last_group = group
   end



     if opt_country
        line = "#{team1[:name]} (#{team1[:country]})"
        line <<  " v "
        line <<  "#{team2[:name]} (#{team2[:country]})"

        buf <<  "  %-40s  " % line
        buf <<  "#{score}"
     else
        line = "#{team1[:name]} v #{team2[:name]}"

        buf <<  "  %-30s  " % line
        buf <<  "#{score}"
     end

      buf << "\n"
  end

  buf
end
