

def _pp_pen( pen )
   if pen.scored?
     "#{pen.score[0]}-#{pen.score[1]} #{pen.name}"
   else
     ###  fix - check for saved or crossbar or ????
     "    #{pen.name} (missed)"
   end
end

def _pp_pens( pen1, pen2 )
   buf = String.new
   buf << _pp_pen( pen1 )
   if pen2
      buf << ", "
      buf << _pp_pen( pen2 )
   end
   buf
end


def pp_penalties( pens, indent:  )
      lines = []
      line = String.new

      pens.each_slice(2) do |pen1, pen2|
           lines << _pp_pens( pen1, pen2 )
      end

      lines.join( ",\n#{' '*indent}" )
end
