


def pp_matches_full( season:,
                     slug:,
                     opt_country: false,
                     opt_teams: false,
                     indir: '.'  )

   season = Season( season )

   doc = Document.read( "#{indir}/#{season.to_path}/#{slug}.json" )

   ## matches = sort_matches( matches )




   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   ## buf << pp_stats( matches, teams: teams, stadiums: stadiums,
   ##                       opt_teams: opt_teams,
   ##                       opt_stadium: true )
   buf << "\n"



  last_round  = nil


  doc.each_match do |m|

      ####
   ## note - make round
   ##         =  stage  +  group (optional)  +  matchday (optional)
   round  = m.stage
   round += ", #{m.group}"       if m.group
   round += " - #{m.matchday}"   if m.matchday


   score = if m.score
              m.score.to_s
           else
              ''
           end

    ##
    ##  for debugging output match line (before goals, line-up, penalties, etc)
    puts "  #{m.team1.name} v #{m.team2.name}  #{score}    - #{m.date_local}"



   if last_round.nil? || last_round != round

         buf << "▪ #{round}\n"

        last_round = round
   end



     ## use Fir Jan 7 20:30 UTC+1  or 20:30 UTC-3
     buf << m.date_local.strftime( '%a %b %-e %H:%M' )
     buf << " UTC%+d" % m.diff_in_hours


   buf << " @ #{m.stadium.name}, #{m.stadium.city}"
   buf << ", Att: #{m.attendance}"   if m.attendance
   buf << "\n"



   if opt_country
     buf <<  "  #{m.team1.name} (#{m.team1.country}) v #{m.team2.name} (#{m.team2.country})"
   else
     buf <<  "  #{m.team1.name} v #{m.team2.name}"
   end
   buf <<  "  #{score}"

   buf << "\n"



   ## skip adding goals if teams not yet known!!
   ##  fix-fix-fix -- add more checks (e.g. ResultType = ??, MatchStatus = ??) !!!
   next  if m.team1.dummy? || m.team2.dummy?


   buf <<  pp_goals( m,  indent:  4 )


   ##  fix-fix-fix
   ## hack -   code is missing in teams!!!
   pp m.team1
   pp m.team2
   team1_code = m.team1.code || m.team1.country
   team2_code = m.team2.code || m.team2.country

   ### get match (live) details
   live = read_json( "#{indir}/#{season.to_path}/#{slug}/#{m.date_local.strftime('%Y-%m-%d')}_#{team1_code}-#{team2_code}.json" )


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
=end



   players1 = Players.new
   players1.add_starter( live['lineup1'] )
##   players1.add_subs( live['HomeTeam']['Substitutions'])
##   players1.add_bookings( live['HomeTeam']['Bookings'])

   players2 = Players.new
   players2.add_starter( live['lineup2'] )
##   players2.add_subs( live['AwayTeam']['Substitutions'])
##   players2.add_bookings( live['AwayTeam']['Bookings'])

   lineup1 = players1.lineup
   lineup2 = players2.lineup

   pp lineup1
   pp lineup2

     buf << "\n"
     buf << "#{m.team1.name}: "+ pp_lineup( lineup1 ) + "\n"
     buf << "#{m.team2.name}: "+ pp_lineup( lineup2 ) + "\n"
     buf << "\n"



=begin

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
