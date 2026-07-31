
def _pp_player( player, opts: )
   buf = String.new

   if opts.short?   ## use/prefer  short name - why? why not?
     buf << "#{player.short_name || player.name}"
   else
     buf << "#{player.name}"
   end

   buf << " [c]"  if player.captain?


   ## check for y/yr/r cards
   ##   todo/check  - change Y/R to YR - why? why ynot?
   buf << " [Y #{player.y.minute}']"      if player.yellow?
   buf << " [Y/R #{player.yr.minute}']"   if player.yellowred?
   buf << " [R #{player.r.minute}']"      if player.red?

    ## check for sub (recursive)
    if player.sub
       buf << " (#{player.sub.minute}' #{_pp_player( player.sub.player, opts: opts )})"
    end

   buf
end


##  note - allow (optional formation e.g.   5-3-2 etc.
##

def pp_lineup( players, indent: 6, formation: nil,
                        opts: )


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
        text  = String.new
        text  <<  _pp_player( player, opts: opts )


        next_player = players[i+1]
        if next_player
           if formation  ### use formation for separators
                if formation.include?( i+1  )
                    text << " - "
                else
                    text << ", "
                end
           elsif next_player.pos != player.pos
               text << " - "  ## separate gk/def/mid/forw
           else
               text << ", "
           end
        end

       if (line.length+text.length) > 88   ## start a new line
            lines << line.rstrip
            line = String.new
        end
        line << text
    end

    lines << line.rstrip
    lines

    lines.join( "\n#{' '*indent}" )
end



###########
#  officials  (that is, referees)

def pp_officials( recs, opts: )
   recs.map do |official|
               if opts.country?
                  "#{official.name} (#{official.country})"
               else
                  "#{official.name}"
               end
            end.join( ', ' )
end
