

module Footballsquads

class Page






  # LeagueSeasons used for
  #   - https://www.footballsquads.co.uk/squads.htm
  #   - https://www.footballsquads.co.uk/national.htm
  #   - https://www.footballsquads.co.uk/archive.htm
  #  find a better name ?

  class LeagueSeasons < Page
    def self.get( url, cache: true )
      ## download if not in cache
      ## check check first
      ##   todo/fix: move cache check here from Metal!!!!
      ##                 why? why not?

      ## check check first
      if cache && Webcache.cached?( url )
        ## puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
      else
        ## todo/fix: use something "generic" from webget gem!!!!
        Metal.download_page( url )
      end

      from_cache( url )
    end

    def self.from_cache( url )
      ## use - super.from_cache( url ) - why? why not?
      html = Webcache.read( url )
      new( html, url: url )
    end

    attr_reader :url
    def initialize( html, url: )
      super( html )
      @url = url
    end


    def leagues
      ## get all links inside div.main
      els = doc.css( 'div#main a' )

      ## todo - assert one table
      ## puts "  found #{els.size} h5(s)"
      data = []

      els.each_with_index do |el,i|
            a = el

            league_name         = squish( a.text )  
            league_relative_url = a['href']    
     
            ## note: return absolute url - keep relative too (for debugging) - why? why not?
            data << {  'league_url' => URI.join( @url, league_relative_url ).to_s,
                       'league_relative_url'  => league_relative_url,
                       'league_name'          => league_name,  
                    }
      end
      data
    end
  end  # class LeagueSeasons




  class League < Page  ## note: use nested class for now - why? why not?

   # todo/fix !!!!!!!!!!!!:
   #   use self.get( url, cache: true ) !!!!!
   #    no params allowed here - sorry!!!!
   #    keep it simple

    ## def self.get( country:, league:, season:, cache: true )
    def self.get( url, cache: true )
      ## download if not in cache
      ## check check first
      ##   todo/fix: move cache check here from Metal!!!!
      ##                 why? why not?

      ## check check first
      if cache && Webcache.cached?( url )
        ## puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
      else
        Metal.download_page( url )
      end

      from_cache( url )
    end

    def self.from_cache( url )
      ## use - super.from_cache( url ) - why? why not?
      html = Webcache.read( url )
      new( html, url: url )
    end

    attr_reader :url
    def initialize( html, url: )
      super( html )
      @url = url
    end

    ## add high-level convenience helper 
    ##  for all team (squad) pages
    def each_team
       teams = self.teams
       puts "   #{teams.size} team(s)"
       # pp teams
    
     # -- clubs
     # eng/2023-2024/engprem.htm
     # eng/2023-2024/engprem/arsenal.htm
     # eng/2023-2024/engprem/chelsea.htm
     # austria/2023-2024/ausbun.htm
     # austria/2023-2024/bundes/austvien.htm
     # austria/2023-2024/bundes/rapvien.htm  
     # portugal/2023-2024/porprim.htm
     # portugal/2023-2024/primeira/benfica.htm
     # -- national 
     # national/worldcup/wc2022.htm
     # national/worldcup/wc2022/argent.htm
     # national/worldcup/wc2022/mexico.htm
     # national/eurocham/euro2008.htm
     # national/eurocham/euro2008/austria.htm

       teams.each do |rec|

         #  fix - return complete team/squad team_url!!!
         #    with htm !!!
         #   keep it simple
         #   use urls only!!
         #    remove league,country, etc. in get/from_cache!!!

          team_url  = rec['team_url']
          team_name = rec['team_name']

         ###################
         ### note:    
         ## skip known pages with broken encodings e.g. Donovan L?n etc.
         ##    add with broken text e.g. ??? -  why? why not? 
         ##   add pages to ERRATA.md or such to document !!!!
         ##     
         ##  note - footer has ? and many ??? in names
         ##  All Rights Reserved ? FootballSquads.com   
         next if [
            'https://www.footballsquads.co.uk/france/2013-2014/ligue2/auxerre.htm',
            'https://www.footballsquads.co.uk/france/2012-2013/ligue2/auxerre.htm',
            'https://www.footballsquads.co.uk/greece/2010-2011/superl/kavala.htm',
            'https://www.footballsquads.co.uk/arg/2016-2017/primera/sarmiento.htm',
            'https://www.footballsquads.co.uk/australia/2016-2017/aleague/melbvic.htm',
                 ].include?( team_url )


          page = Squad.get( team_url )
          yield( page )
       end    
    end    


=begin
<div id="main">
<h5><a href="engprem/arsenal.htm">Arsenal</a></h5>

<h5><a href="engprem/avilla.htm">Aston Villa</a></h5>

<h5><a href="engprem/bourne.htm">Bournemouth</a></h5>

<h5><a href="engprem/brentf.htm">Brentford</a></h5>
=end

    def teams

      ## use anchor links (a) inside h5
      ##  works with leagues and national comp. ??? 
      els = doc.css( 'div#main h5 a' )

      ## todo - assert one table
      ## puts "  found #{els.size} h5(s)"
      data = []

      els.each_with_index do |el,i|
            a = el

            team_name         = squish( a.text )  
            team_relative_url = a['href']    
     
            ## note: return absolute url - keep relative too (for debugging) - why? why not?
            data << {  'team_url' => URI.join( @url, team_relative_url ).to_s,
                       'team_relative_url'  => team_relative_url,
                       'team_name'          => team_name,  
                    }
      end
      data
    end
  end  # class League



  class Squad < Page  ## note: use nested class for now - why? why not?


def self.get( url, cache: true )

  if cache && Webcache.cached?( url )
    ## puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
  else
    Metal.download_page( url )
  end

  from_cache( url )
end


def self.from_cache( url )
  ## use - super.from_cache( url ) - why? why not?
  html = Webcache.read( url )

  ## try quick hack
  ## ['https://www.footballsquads.co.uk/eng/1998-1999/faprem/arsenal.htm',
  #    'https://www.footballsquads.co.uk/eng/1998-1999/faprem/chelsea.htm', 
  #    'https://www.footballsquads.co.uk/eng/1998-1999/faprem/leeds.htm',
  ##   ]
    ## assume all "old" use latin1 encoding ??
    ## all 1998-1999, 1997-1998 etc.

    ## quick hack possible?
    ##   check for All Rights Reserved � FootballSquads.com
    ##     instead of All Rights Reserved © FootballSquads.com
    ##    for non-utf8 encoding ???

    #
    # todo/check - check auto-convert on "old" seasons - why? why not? 
    ##  only use for eng !!!!
=begin
   if url.index( '/1998-1999/' ) ||
      url.index( '/1997-1998/' ) ||
      url.index( '/1996-1997/' ) ||
      url.index( '/1995-1996/' ) ||
      url.index( '/1994-1995/' ) ||
      url.index( '/1993-1994/' ) 
    puts "!!! convert from windows-1252 encoding to utf-8"   ## ??
    ###  encoding: 'Windows-1252'
    html = html.force_encoding( 'Windows-1252' )
    html = html.encode( Encoding::UTF_8 )
    html 
=end

   if html.index( 'All Rights Reserved ©' )  ||
      html.index( 'All Rights Reserved ï¿½' )   
      ## note - ignore ï¿½ for now
      ##   - e.g. https://www.footballsquads.co.uk/eng/2018-2019/national/bromley.htm
      ##  assume utf-8 encoding
   else
     ### English Football League Championship 2005/06
     ###   and more with encoding: 'Windows-1252' ???

    ## assume Windows-1252 ???
    ###  encoding: 'Windows-1252'
    puts "!!! All rights reversed © FootballSquads.com - NOT found"
    pos = html.index( 'All Rights Reserved' )
    puts   html[pos, 40]  
    puts "!!! convert from windows-1252 encoding to utf-8"  
 
    html = html.force_encoding( 'Windows-1252' )
    html = html.encode( Encoding::UTF_8 )
    html 
   end

=begin 
=end  
  ###  index on string � NOT working - find proper chars ??
  ###  might require binary encoding?
   ## html.index( 'All Rights Reserved � FootballSquads.com' ) ||
   ##   html.index( 'All Rights Reserved � FootballSquads.com' )
   ##   url.index( '/eng/2007-2008/flcham/' ) ||
   ##  url.index( '/eng/2006-2007/flcham/' )

   ## note - utf-8 encoding for copyright char requires two bytes (> 127, 7-bit)!!
   ##  e.g.     ©  0xC2 0xA9   (0xC2 is extension marker)
   ##         unicode code is  0xA9 (169)
   ##          same as Windows-1252  

  new( html, url: url )
end

attr_reader :url
def initialize( html, url: )
  super( html )
  @url = url

  # puts "==>  squads page char encoding - #{html.encoding}"
  # pos = html.index( 'All Rights Reserved' )
  # puts   html[pos, 40]

  ###  assert encoding
  ##    for now MUST have copyright char (footer) e.g. ... © ... 
  unless html.index( 'All Rights Reserved © FootballSquads.com' ) ||
         html.index( 'All Rights Reserved ï¿½ FootballSquads.com' )   
     puts "!! ERROR - encoding error??"
     puts "   no © found in #{url}"
     exit 1
  end
end



=begin
<h2 style="margin-top: 0; margin-bottom: 0"><font color="#FF0000">RB Leipzig</font></h2>
<h3 style="margin-top: 0; margin-bottom: 0"><b>Official Name:</b> RasenBallsport 
Leipzig</h3>
=end

=begin
<h3 style="margin-top: 0; margin-bottom: 6"><b>Formed:</b>
 1909&nbsp; <b>Ground: </b>Lotto Park (21,500)&nbsp; <b>
Manager:</b> Brian Riemer [DEN]</h3>
=end

def _team_info
  @team_info ||= begin 
                     h2 = doc.css( 'div#main h2' )
                     ## note - squish whitespaces (name may include newlines and more)
                     name = squish( h2[0].text.to_s )

                     h3 = doc.css( 'div#main h3' )
                     ## note - squish whitespaces (name may include newlines and more)
                     ##  todo/check - text.to_s needed here (or use h3.text - returns string or something else?)
                     official_name = squish( h3[0].text.to_s ).sub( 'Official Name:', '' ).strip
              
                     ## check for <i>
                     ##   tags ground as "on loan" / temporary!!!
                     html = h3[1].inner_html   ## note: inner_html returns (plain vanilla) string
                     
                     html = html.gsub( "\u00a0", ' | ' ) 
                     html = html.gsub( %r{
                                         <b>|</b>|
                                         <strong>|</strong>
                                           }ix, 
                                           '' )
                     html = squish( html )
                     ## pp html
                     more = html

                     ##  split on &nbsp;  - why? why not?
                     # parts = html.split( "\u00a0" )
                     # parts = parts.map { |part| squish( part) }
                     # pp parts

                   { 'Name' => name,
                     'Official Name' => official_name,
                     'More'   =>  more,
                      # 'Formed' => '?',
                      # 'Ground' => '?',
                      # 'Manager' => '?'
                   }
                  end
end


def team_info()          _team_info['More'];  end 

def team_name()           _team_info['Name'];          end  # short name
def team_name_official()  _team_info['Official Name']; end  # long name



=begin
<tr>
    <TD COLSPAN=9>
<h4 class="normal" style="margin-top: 0; margin-bottom: 0">
<b>Players no longer at this club</b></h4>
    </TD>
  </tr>
=end


def _build_rows( data )
   ## use first row for columns

   data =  data.select do |values|
              ## all values starting with first empty?
              ##   if yes, skip line/row

              ##
              ##  fix: might include &nbsp; (non-breaking space)
              ##       different space encoding in unicode
              ##         use \u00a0 for &nbsp;
              
              line = squish( values[1..-1].join( '' ) )
              if line.empty?
                false
              else
                true
              end
           end
   cols = data.shift    ## get first row for column names

   rows =  data.map {|values| Hash[ cols.zip( values )] }
   rows 
end


def players
  tables = doc.css( 'div#main table' )

  ## todo - assert one table
  # puts "  found #{tables.size} table(s)"

  table = tables.first

  trs = table.css( 'tr' )
  # puts " #{trs.size} row(s)"


  ## step one - convert to string only array of strings
  data = []
  trs.each_with_index do |tr,i|
    tds = tr.css( 'td' )
    # puts "==> #{i}  - #{tds.size} col(s)"
    values = tds.map {|td| squish( td.text.to_s ) }
    # pp values
    data << values
  end

  ## split table if 
  ## ["Players no longer at this club"] or such  
  ## look for divider
   idx = nil
   data.each_with_index do |values,i|
       if values.size == 1 && values[0].downcase.index( 'players' )
          idx = i
          break
       end
   end

   current, past =  if idx
                      [_build_rows(data[0..(idx-1)]), 
                       _build_rows(data[(idx+1)..-1])]
                    else
                      [_build_rows(data), 
                        []]
                    end

   [current, past]
end


=begin


["Players no longer at this club"]
==> 47  - 9 col(s)
["Number", "Name", "Nat", "Pos", "Height", "Weight", "Date of Birth", "Birth Place", "New Club"]
==> 0  - 9 col(s)
["Number", "Name", "Nat", "Pos", "Height", "Weight", "Date of Birth", "Birth Place", "Previous Club"]
=end

end # class Squad
end # class Page
end # module Footballsquads



