
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)



##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


def pp_matches_min(  season:,
                 slug:,
                 opt_country: false,
                 opt_city:    false,
                 opt_stadium: false,
                 opt_timezone: true,
                 opt_teams: false,
                 indir: '.'  )

   season = Season( season )

    doc = Document.read( "#{indir}/#{season.to_path}/#{slug}.json" )

   ## puts "  #{matches.size} match(es) in season #{season}"

   ## matches = sort_matches( matches )




   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
##   buf << pp_stats( matches, teams: teams, stadiums: stadiums,
##                          opt_teams: opt_teams,
##                          opt_stadium: opt_stadium )
   buf << "\n"


 last_round  = nil

  doc.each_match do |m|



     ####
   ## note - make roundName  = stageName + matchDay (optional)
   round  = m.stage
   round += ", #{m.group}"       if m.group
   round += " - #{m.matchday}"   if m.matchday


#  stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )




   if last_round.nil? || last_round != round

         buf << "\n"

         buf << "▪ #{round}\n"

        last_round = round
   end



     ##
     ##
     ## note - if score empty (e.g. '') use  A v B
     score =   if m.score
                  m.score.to_s
               else
                  ''
               end


     if opt_country
        line = "#{m.team1.name} (#{m.team1.country})"
        line <<  " v "
        line <<  "#{m.team2.name} (#{m.team2.country})"

        buf <<  "  %-40s  " % line
        buf <<  "#{score}"
     else
        line = "#{m.team1.name} v #{m.team2.name}"

        buf <<  "  %-30s  " % line
        buf <<  "#{score}"
     end

      buf << "\n"
  end

  buf
end
