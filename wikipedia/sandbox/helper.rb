
$LOAD_PATH.unshift( '/sports/wikiscript/wikiscript/wikiscript/lib' )
$LOAD_PATH.unshift( '/sports/wikiscript/wikiscript/wikiscript-parser/lib' )
$LOAD_PATH.unshift( '/sports/wikiscript/wikiscript/wikitree/lib' )

require 'wikiscript'
require 'wikiscript/parser'




def slugify( title )
  ## change to "plain ascii" dash
  slug = title.gsub( '–', '-' )
  slug
end


