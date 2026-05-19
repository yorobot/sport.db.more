

def slugify( str )
   str = unaccent( str )
   ## replace space with underscore
   str = str.gsub( ' ', '_' )
   str = str.downcase
   ## remove all BUT a-z, 0-9, _-
   str = str.gsub( /[^a-z0-9_-]/, '' )
   str
end
