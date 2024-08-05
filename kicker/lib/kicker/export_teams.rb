
module Kicker

class Page
class Teams < Page  ## note: use nested class for now - why? why not?
   def self.read_cache( url )
      html = Webcache.read( url )
      new( html )
   end

   def teams
     els = doc.css( 'td.kick__table--ranking__teamname' )
     teams = els.map { |el| el.text.strip }
     ## pp teams
     puts  "  #{teams.size} team(s)"
     puts
     teams
   end
end  # class Teams (nested inside Page)
end  # class Page


def self.export_teams( league:, season: )
    season = Season( season )

    tmpl = LEAGUES[league]
    path = tmpl.sub( '{season}', season.to_path )
    url = "#{BASE_URL}/#{path}/"


    page = Page::Teams.read_cache( url )

    title = page.title
    puts title

    teams = page.teams

    ## wrap team name in (values) record
    rows = teams.map {|team| [team] }

    #######
    #  todo/fix - make outpath configurable !!!!

    base = league.split( '.' )[0]
    outpath = "../../clubs.sandbox/kicker/#{base}/#{league}_#{season.to_path}_(#{teams.size}).csv"
    outpath = File.expand_path( outpath )

    puts "   writing to >#{outpath}<"
    headers = ['name']
    write_csv( outpath, rows, headers: headers )
end
end   # module Kicker



__END__

<td class="kick__t__a__l
 kick__table--ranking__teamname
 kick__table--ranking__index
 kick__respt-m-w-160">
<a href="/sturm-graz/info/bundesliga-oesterreich/1995-96">
  Sturm Graz
</a>
</td>
