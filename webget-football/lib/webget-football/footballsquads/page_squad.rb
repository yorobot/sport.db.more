

module Footballsquads

class Page

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
        ::Metal::Base.download_page( url )
      end

      from_cache( url )
    end

    def self.from_cache( url )
      ## use - super.from_cache( url ) - why? why not?
      html = Webcache.read( url )
      new( html, url: url )
    end

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
    ::Metal::Base.download_page( url )
  end

  from_cache( url )
end


def self.from_cache( url )
  ## use - super.from_cache( url ) - why? why not?
  html = Webcache.read( url )
  new( html )
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



