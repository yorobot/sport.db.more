
## pretty print matches ("summary" - not full w/ line-up, penalties etc.)


def pp_matches_min(  season:,
                 slug:,
                 opts:,
                 indir: '.'  )

   season = Season( season )

    doc = Document.read( "#{indir}/#{season.to_path}/#{slug}.json" )





   buf = String.new

   ## add stats block (dates, teams, matches, venues, etc.)
   buf << pp_stats( doc,  opts: opts )
   buf << "\n"


 last_round  = nil

  doc.each_match do |m|


   round  = m.stage
   round += ", #{m.group}"       if m.group
   round += " - #{m.matchday}"   if m.matchday


   if last_round.nil? || last_round != round
         buf << "\n"
         buf << "▪ #{round}\n"

         last_round = round
   end



     score =   if m.score
                  m.score.to_s
               else
                  ''
               end


     if opts.clubs? && opts.country?
        line = "#{m.team1.name} (#{m.team1.country})"
        line <<  " v "
        line <<  "#{m.team2.name} (#{m.team2.country})"

        buf <<  "  %-40s  " % line
     else
        line = "#{m.team1.name} v #{m.team2.name}"

        buf <<  "  %-30s  " % line
     end
     buf <<  "#{score}"

      buf << "\n"
  end

  buf
end
