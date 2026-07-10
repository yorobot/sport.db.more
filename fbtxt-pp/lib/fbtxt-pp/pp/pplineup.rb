
def _pp_player( player )
   buf = String.new
  
   buf << "#{player[:name]}"
   buf << " [c]"  if player[:captain]

   ## check for y/r/yr cards
   buf << " [Y #{player[:y][:minute]}]"      if player[:y]
   buf << " [Y/R #{player[:yr][:minute]}]"   if player[:yr]
   buf << " [R #{player[:r][:minute]}]"      if player[:r]

    ## check for sub (recursive)
    sub = player[:sub] 
    if sub
       buf << " (#{sub[:minute]} #{_pp_player( sub[:player_ref])})"
    end

   buf
end


def pp_lineup( players, indent: 6 )
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
           if next_player[:pos] != player[:pos]
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

def _pp_official( h )
   "#{h[:name]} (#{h[:idCountry]})"
end

def pp_officials( recs )
   recs.map do |rec| 
                _pp_official( rec )
            end.join( ', ' )
end


