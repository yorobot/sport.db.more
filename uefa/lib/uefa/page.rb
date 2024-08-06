module Uefa
class Page
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

######################
##  helper methods
def squish( str )
 str = str.strip
 str = str.gsub( "\u{00A0}", ' ' )  # Unicode Character 'NO-BREAK SPACE' (U+00A0)
 str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
 str
end

def assert( cond, msg )
 if cond
   # do nothing
 else
   puts "!!! assert failed (in parse page) - #{msg}"
   exit 1
 end
end


def log( msg )  ### append to log
 File.open( './logs.txt', 'a:utf-8' ) do |f|
   f.write( msg )
   f.write( "\n" )
 end
end
end # class Page
end # module Uefa
