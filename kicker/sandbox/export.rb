$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'
require 'season/formats'

Webcache.root = '/sports/cache'


## 3rd party
require 'nokogiri'


require_relative 'leagues'
require_relative 'datasets'


def export( league:, season: )
    season = Season( season )

    tmpl = LEAGUES[league]
    path = tmpl.sub( '{season}', season.to_path )
    url = "#{BASE_URL}/#{path}/"
 

    html = Webcache.read( url )
    ## pp html[0,600]

    ## note: if we use a fragment and NOT a document -
    ##   no access to  page head (and meta elements and such)
 
    doc =  Nokogiri::HTML( html )

    puts
    title =  doc.css( 'title' ).first.text
    pp title

    els = doc.css( 'td.kick__table--ranking__teamname' )
    teams = els.map { |el| el.text.strip }
    ## pp teams
    puts  "  #{teams.size} team(s)"
    puts

    ## wrap team name in (values) record 
    rows = teams.map {|team| [team] } 

    base = league.split( '.' )[0]
    outpath = "../../clubs.sandbox/kicker/#{base}/#{league}_#{season.to_path}_(#{teams.size}).csv"
    outpath = File.expand_path( outpath )

    puts "   writing to >#{outpath}<"
    headers = ['name']
    write_csv( outpath, rows, headers: headers )
end



datasets = DATASETS
datasets.each_with_index do |(league, seasons),i|
   seasons.each_with_index do |season, j|
       puts "===> #{league} #{season}..."
       export( league: league, season: season )
   end 
end



puts "bye"


__END__

<td class="kick__t__a__l 
 kick__table--ranking__teamname 
 kick__table--ranking__index 
 kick__respt-m-w-160">
<a href="/sturm-graz/info/bundesliga-oesterreich/1995-96">
  Sturm Graz
</a>
</td>
