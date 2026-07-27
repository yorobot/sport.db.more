
def _pp_player( player )
   buf = String.new

   buf << "#{player.name}"
   buf << " [c]"  if player.captain?

=begin
   ## check for y/r/yr cards
   buf << " [Y #{player[:y][:minute]}]"      if player[:y]
   buf << " [Y/R #{player[:yr][:minute]}]"   if player[:yr]
   buf << " [R #{player[:r][:minute]}]"      if player[:r]
=end

    ## check for sub (recursive)
    if player.sub
       buf << " (#{player.sub.minute}' #{_pp_player( player.sub.player)})"
    end

   buf
end


##  note - allow (optional formation e.g.   5-3-2 etc.
##

def pp_lineup( players, indent: 6, formation: nil )


    if formation
         ## split into integers
         parts = formation.split( /[ ]*-[ ]*/ )
         ## add 1 upfront for (implied) goalie
         formation =  ['1']+parts
         ## e.g.
         ##  1-4-3-3
         ##  1-5-8-11
         sum = 0   ## make cumulate sum (index)
         formation = formation.map { |part| sum += part.to_i(10) }
    end


    lines = []
    line = String.new

    players.each_with_index do |player,i|
        if line.length > 68   ## start a new line
            lines << line.rstrip
            line = String.new
        end
        line  << _pp_player( player )

        next_player = players[i+1]
        if next_player
           if formation  ### use formation for separators
                if formation.include?( i+1  )
                    line << " - "
                else
                    line << ", "
                end
           elsif next_player.pos != player.pos
               line << " - "  ## separate gk/def/mid/forw
           else
               line  << ", "
           end
        end
    end

    lines << line.rstrip
    lines

    lines.join( "\n#{' '*indent}" )
end



###########
#  officials  (that is, referees)

def pp_officials( recs )
   recs.map do |official|
               "#{official.name} (#{official.country})"
            end.join( ', ' )
end
