
module Footballsquads

##
##  todo - move Page upstream to webget for (shared) reuse!!!!! 
###        include Webget (module) or such??
##               to get (shared) Page and Metal::Base - why? why not?

class Page
def self.from_cache( url )    ### change/rename to read_cache( url ) - why? why not?
  html = Webcache.read( url )
  new( html )
end

def self.from_file( path )   ## change/rename to read( path ) - why? why not?
  html = File.open( path, 'r:utf-8' ) {|f| f.read }
  new( html )
end



def initialize( html )
  @html = html
end

def doc
  ## note: if we use a fragment and NOT a document - no access to page head (and meta elements and such)
  @doc ||= Nokogiri::HTML( @html )
end

def title
 # <title>Bundesliga 2010/2011 &raquo; Spielplan</title>
   @title ||= doc.css( 'title' ).first
   @title.text  ## get element's text content
end



####
# helpers
## todo/fix:
##  move upstream for reuse in all pages
##
def squish( str )
  ## rails squish! uses
  ##   gsub!(/[[:space:]]+/, " ")
  ##  strip!
  ##   see https://apidock.com/rails/v6.1.7.7/String/squish!

  ## note: add non-break space too 
  str.gsub( /[ \n\r\t\u00a0]+/, ' ' ).strip
end


end # class Page
end # module Footballsquads

