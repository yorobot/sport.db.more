
module Worldfootball
  class Page

  def self.from_file( path )
    html = File.open( path, 'r:utf-8' ) {|f| f.read }
    new( html )
  end

  def initialize( html )
    ## todo/fix - fix upstream in wget!!!! why? why not?
    ##    normalize unicode (to nfc - ruby's default norm form)
    @html = html.unicode_normalize
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

  def keywords
     # <meta name="keywords"
     #  content="Bundesliga, 2010/2011, Spielplan, KSV Superfund, SC Magna Wiener Neustadt, SV Ried, FC Wacker Innsbruck, Austria Wien, Sturm Graz, SV Mattersburg, LASK Linz, Rapid Wien, RB Salzburg" />
     @keywords ||= doc.css( 'meta[name="keywords"]' ).first
     @keywords[:content]  ## get content attribute
     ## or      doc.xpath( '//meta[@name="keywords"]' ).first
     ## pp keywords
     # puts "  #{keywords[:content]}"

     # keywords = doc.at( 'meta[@name="Keywords"]' )
     # pp keywords
     ## check for
  end

  # <meta property="og:url"
  #       content="//www.weltfussball.de/alle_spiele/aut-bundesliga-2010-2011/" />
  def url
    @url ||= doc.css( 'meta[property="og:url"]' ).first
    @url[:content]
  end



##  <!-- [generated 2020-06-30 22:30:19] -->
##  <!-- [generated 2020-06-30 22:30:19] -->
GENERATED_RE = %r{
  <!--
    [ ]+
    \[generated
        [ ]+
      (?<date>\d+-\d+-\d+)
        [ ]+
      (?<time>\d+:\d+:\d+)
    \]
    [ ]+
    -->
   }x


   def generated
      @generated ||= begin
        m=GENERATED_RE.match( @html )
        if m
         DateTime.strptime( "#{m[:date]} #{m[:time]}", '%Y-%m-%d %H:%M:%S')
        else
         puts "!! WARN - no generated timestamp found in page"
         nil
        end
      end
   end

   ### convenience helper / formatter
   def generated_in_days_ago
     if generated
      diff_in_days = Date.today.jd - generated.jd
      "#{diff_in_days}d"
     else
      '?'
     end
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
end # module Worldfootball
