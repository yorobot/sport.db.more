

def slugify( str )
   str = unaccent( str )
   ## replace space with underscore
   str = str.gsub( ' ', '_' )
   str = str.downcase
   ## remove all BUT a-z, 0-9, _-
   str = str.gsub( /[^a-z0-9_-]/, '' )
   str
end


def slugify_markdown( str )
   ## replace space with dash
   str = str.gsub( ' ', '-' )
   str = str.downcase
   ## remove all non unicode letters (a-z), 0-9, -
   str = str.gsub( /[^\p{L}0-9-]/, '' )
   str
end
