

ALPHA_RE = %r{ \A
                   \p{L}
                   [\p{L} '.-]*
               \z
              }ix

##
##  J. HARTING               - note: include .
##   Jose BUSTAMANTE-NAVA    - note: include -
##   Yannick N'Djeng         - note: include '
##    Ismail JAKOBS  Ismail JAKOBS

def is_alpha?( name )  ## use is_alpha_name? or is_unialpha? or such??
    ALPHA_RE.match( name ) ? true : false
end


def pp_alpha( name )
  ##
##  note:  e is decomposed   !!!!  - will break lexer!!!
##   e (101)
##   ́  (769)
##   vs
##     é (233)

  buf = String.new
  buf << ">#{name}< => "
  name.each_char do |char|
      buf << "#{char} (#{char.ord}) | "
  end
  buf
end
