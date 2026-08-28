module Openliga


def self._clean( str )
  ## note - accept nil
  ##   turn blank strings e.g "" or "  " into nil
  ##    remove leading and trailing spaces
   return nil if str.nil?

    str = str.strip
    if str.empty?
       nil
    else
      str
    end
end

=begin
@ Sportpark Ronhof | Thomas Sommer, Fürth
@ Sportforum "Sojus 31", Zwickau
@ "Allianz Arena, München

  or add into protected_name token - why? why not?
e.g.
@ ‹Sportpark Ronhof | Thomas Sommer›, Fürth
@ ‹Sportforum "Sojus 31"›, Zwickau
@ ‹"Allianz Arena›, München       -- really better FIX typo
=end

def self._clean_geo( str )
   return nil if str.nil?

   str = str.gsub( %r{["|]}, '' )       ## remove "|
   str = str.gsub( %r{[ ]{2,}}, ' ' )   ## squish spaces (maybe move "upstream" to clean)

   _clean( str )
end


def self._clean_name( str ) ## player name
  ## e.g.
  ##  Poulsen, Yussuf   =>  Poulsen Yussuf
  ##  Günther-Schmidt, Julian
  ##  Hercher, Philipp
  ##    maybe auto-turn around later - why? why not?
  ##
  ##  E. N‘Dicka   =>   E. N'Dicka


   return nil if str.nil?

   ## move asciify "upstream" - why? why not?
   str = str.gsub( /[‘]/, "'" )   ## asciify "smart/unicode" quotes


   ## str = str.gsub( /[,]/, '' )       ## remove ","  -- todo - add a warn(ing) on replace
   ## tr = str.sub(  'Poulsen, Yussuf', 'Yussuf Poulsen' )
   ##
   ##  turn "Poulsen, Yussuf" into "Yussuf Poulsen"
   if str.include?(',')
       last_name, first_name = str.split( ',', 2 )
       str   = "#{first_name} #{last_name}"
   end


   str = str.gsub( /[ ]{2,}/, ' ' )   ## squish spaces (maybe move "upstream" to clean)

   _clean( str )
end



end   ## module Openliga
