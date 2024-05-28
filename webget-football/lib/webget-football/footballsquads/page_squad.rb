

module Footballsquads

class Page

  class League < Page  ## note: use nested class for now - why? why not?

    def self.get( country:, league:, season:, cache: true )
      ## download if not in cache
      ## check check first
      ##   todo/fix: move cache check here from Metal!!!!
      ##                 why? why not?
      Metal.league( country: country, 
                    league:  league, 
                    season:  season,
                    cache:   cache )

      from_cache( country: country,
                  league:  league,
                  season:  season )
    end

    def self.from_cache( country:, league:, season: )
      url = Metal.league_url( country: country, league: league, season: season )
    
      ## use - super.from_cache( url ) - why? why not?
      html = Webcache.read( url )
      new( html, country: country,
                 league:  league,
                 season:  season )
    end

    def initialize( html, country:,
                          league:,
                          season: )
      super( html )
      @country_slug = country
      @league_slug  = league
      @season_slug  = season
    end

    ## add high-level convenience helper 
    ##  for all team (squad) pages
    def each_team
       teams = self.teams
       puts "   #{teams.size} team(s)"
       pp teams
    
       teams.each do |rec|
          league_slug = rec['league_slug']
          team_slug   = rec['team_slug']
          page = Squad.get(
                   country:  @country_slug,
                   league:   league_slug,  ## note: different slug/key from league!!!
                   season:   @season_slug,
                   team:     team_slug
                  )
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
      h5s = doc.css( 'div#main h5' )

      ## todo - assert one table
      puts "  found #{h5s.size} h5(s)"
      data = []

      h5s.each_with_index do |h5,i|
            a = h5.at( 'a' )

            team_name = a.text.to_s.strip
            href =      a['href']
            ## split into league slug
            ##  and        team  slug
            ##    engprem/brentf.htm
            values  =  href.sub( /\.htm$/, '' ).split( '/' )
            league_slug = values[0]
            team_slug   = values[1]

            data << {  'team_name'   => team_name,
                       'team_slug'   => team_slug,
                       'league_slug' => league_slug,
                     }
      end
      data
    end
  end  # class League



  class Squad < Page  ## note: use nested class for now - why? why not?


def self.get( country:, league:, season:, team:, cache: true )
  ## download if not in cache
  ## check check first
  ##   todo/fix: move cache check here from Metal!!!!
  ##                 why? why not?
  Metal.squad( country: country, 
               league:  league, 
               season:  season,
               team:    team,
               cache:   cache )

  from_cache( country: country, 
              league:  league, 
              season:  season, 
              team:    team )
end

def self.from_cache( country:, league:, season:,
                     team:
                   )
  url = Metal.squad_url( country: country, league: league, season: season,
                         team: team )

  ## use - super.from_cache( url ) - why? why not?
  html = Webcache.read( url )
  new( html )
end

=begin
<h2 style="margin-top: 0; margin-bottom: 0"><font color="#FF0000">RB Leipzig</font></h2>
<h3 style="margin-top: 0; margin-bottom: 0"><b>Official Name:</b> RasenBallsport 
Leipzig</h3>
=end
def team_name  # short name
  @team_name ||= begin
                h2 = doc.css( 'div#main h2' ).first
                   ## note - squish whitespaces (name may include newlines and more)
                   h2.text.strip.gsub( /[ \n\r\t]+/, ' ' )
               end
end

def team_name_official  # long name
  @team_name_official ||= begin
                   h3 = doc.css( 'div#main h3' ).first
                   ## note - squish whitespaces (name may include newlines and more)
                   h3.text.sub( 'Official Name:', '' ).strip.gsub( /[ \n\r\t]+/, ' ' )
                 end
end



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
              
              line = values[1..-1].join( '' ).gsub( /\u00a0/, '' ).strip
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
  puts "  found #{tables.size} table(s)"

  table = tables.first

  trs = table.css( 'tr' )
  puts " #{trs.size} row(s)"


  ## step one - convert to string only array of strings
  data = []
  trs.each_with_index do |tr,i|
    tds = tr.css( 'td' )
    puts "==> #{i}  - #{tds.size} col(s)"
    values = tds.map {|td| td.text.to_s.strip }
    pp values
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



