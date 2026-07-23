


def pp_matches_full( season:,
                     slug:,
                     opt_country: false,
                     opt_teams: false,
                     indir: '.'  )

   season = Season( season )

   data =  read_json( "#{indir}/#{season.to_path}/#{slug}.json" )

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
                          opt_stadium: true )
   buf << "\n"



  last_round  = nil
  last_group  = nil


matches.each_with_index do |m, i|

  ## note - always lookup full team records (use match inline only as refs)
  team1 = teams.find_by!( name: m['team1'] )
  team2 = teams.find_by!( name: m['team2'] )


  score = _fmt_score( m )


   stage    =  m['stage']
   group    =  m['group']   # optional
   num      =  m['num']         # optional
   matchday =  m['matchday']           # optional

   ####
   ## note - make roundName  = stageName + matchDay (optional)
   round  = stage
   round += " - #{matchday}"   if matchday





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



    ##
    ##  for debugging output match line (before goals, line-up, penalties, etc)
    puts "  #{team1[:name]} v #{team2[:name]}  #{score}   - #{localDateTime}"


    ## note - always lookup full stadium record (use match inline only as ref)
    stadium  =  stadiums.find!( m['stadium'] )

    attendance = m['attendance']



   if last_round.nil? || last_round != round

         buf << "▪ #{round}\n"

        last_round = round
        last_group = nil
   end

   if group && (last_group.nil? || last_group != group)

      buf << "▪▪ #{group}\n"

      last_group = group
   end


     use_date_utc = false    # true

##
## e.g. sample with DAY SHIFT!!!
##          Sat Jan 6 22:00 -300 (01:00 UTC, +1d)

   if use_date_utc
    ##  Fri Jan 7 20:30 +200 (18:30 UTC)
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " %+d00" % diff_in_hours

     if localDateTime.hour    != dateTime.hour &&
        localDateTime.minutes != dateTime.minutes
       buf << " (#{dateTime.strftime( '%H:%M')} UTC"
       buf << ", %+dd" % -diff_in_days   if diff_in_days != 0
       buf << ")"
     end
   else
        ## use Fir Jan 7 20:30 UTC+1  or 20:30 UTC-3
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " UTC%+d" % diff_in_hours
   end


   buf << " @ #{stadium[:name]}, #{stadium[:city]}"
   buf << ", Att: #{attendance}"   if attendance
   buf << "\n"

   if opt_country
     buf <<  "  #{team1[:name]} (#{team1[:country]}) v #{team2[:name]} (#{team2[:country]})"
     buf <<  "  #{score}"
   else
     buf <<  "  #{team1[:name]} v #{team2[:name]}  #{score}"
   end

   buf << "\n"



   ## skip adding goals if teams not yet known!!
   ##  fix-fix-fix -- add more checks (e.g. ResultType = ??, MatchStatus = ??) !!!
   next  if m['team1'] == '?' && m['team2'] == '?'


   buf <<  pp_goals( m,  indent:  4 )


   ### get match (live) details
   live = read_json( "#{indir}/#{season.to_path}/#{slug}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:code]}-#{team2[:code]}.json" )

=begin

   players = Players.new
   players.add( live['HomeTeam']['Players'] )
   players.add( live['AwayTeam']['Players'] )


   ##########
   ##   add penalty kicks / penalties

   if resultType == 2   ## aet, win on pens
      ### get timeline with penalty shoot-out details
      timeline = read_json( "./#{slug}/timelines/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{team1[:abbrev]}-#{team2[:abbrev]}__#{idMatch}.json" )

      pens = build_penalties( timeline['Event'], players: players )
      ## pp pens

      buf << "\n"
      buf << "Penalties: #{pp_penalties( pens, indent: 11 )}\n"
   end






   players1 = Players.new
   players1.add( live['HomeTeam']['Players'] )
   players1.add_subs( live['HomeTeam']['Substitutions'])
   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add( live['AwayTeam']['Players'] )
   players2.add_subs( live['AwayTeam']['Substitutions'])
   players2.add_bookings( live['AwayTeam']['Bookings'])


   lineup1 = players1.lineup
   lineup2 = players2.lineup

   if players1.size == 0 &&
      players2.size == 0
      puts "!! WARN - no players available - skipping line-ups for teams!!!!!"
   else
     ##  1954-06-20  - only 10 player in south koera team listed!!
     ##   2021-02-07T21:00:00+00:00 expected 11 players, got 10
     ##   2021-02-11T18:00:00+00:00 expected 11 players, got 10
     if !((team1[:name] == 'Turkey' && team2[:name] == 'South Korea')  ||
          (team1[:name] == 'Palmeiras' && team2[:name] == 'Tigres UANL')  ||
          (team1[:name] == 'Al Ahly FC' && team2[:name] == 'Palmeiras')
         )


       [lineup1,lineup2].each do |lineup|
         if lineup.size != 11

         players1.dump
         puts "---"
         players2.dump
         puts "---"

         pp lineup

          puts " in match #{team1[:name]} v #{team2[:name]}  #{score}"
          puts "   #{localDateTime}"
        end

        assert( lineup.size == 11, "expected 11 players, got #{lineup.size}" )
       end
     end

     buf << "\n"
     buf << "#{team1[:name]}: "+ pp_lineup( lineup1 ) + "\n"
     buf << "#{team2[:name]}: "+ pp_lineup( lineup2 ) + "\n"
     buf << "\n"
   end

###
##  add referees
    officials = build_officials( m['Officials'] )

    if officials.size == 0
      puts "!! WARN no refs / officials found"
    else
      buf << "Refs: " + pp_officials( officials )
      buf << "\n"
    end
=end

    buf << "\n\n"
end


  buf
end
