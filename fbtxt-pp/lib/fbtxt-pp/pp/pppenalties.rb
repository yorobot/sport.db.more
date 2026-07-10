

def _pp_pen( pen )
   ## (i)  41  - pen goal scored - 41
   ## (ii)  0  - goal scored - (when following pen awarded !!) 
   if pen[:type] == 0 || pen[:type] == 41      
     "#{pen[:pen][0]}-#{pen[:pen][1]} #{pen[:player][:name]}"
   else
     "    #{pen[:player][:name]} (missed)"
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
