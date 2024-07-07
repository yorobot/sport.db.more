##################
# to run use:
#    ruby upslugs\more.rb


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'



Webcache.root = '../../../cache'  ### c:\sports\cache




more_league_to_slug = {

'it.1' => 'ita-serie-a-2020-2021',

'es.1' => 'esp-primera-division-2020-2021',

'jp.1' => 'jpn-j1-league-2020',

'br.1' =>  'bra-serie-a-2020',

'tr.1' => 'tur-sueperlig-2020-2021',

'ua.1' => 'ukr-premyer-liga-2019-2020',

'se.1' => 'swe-allsvenskan-2020',

'ch.1' => 'sui-super-league-2020-2021',


'nl.1' =>  'ned-eredivisie-2020-2021',

'lu.1' =>  'lux-nationaldivision-2020-2021',

'cn.1' =>  'chn-super-league-2020',


'ar.1' => 'arg-primera-division-2019-2020',

'uefa.cl' =>  'champions-league-2020-2021',
'eufa.el' =>  'europa-league-2020-2021',
'copa.l' =>  'copa-libertadores-2020',
'concacaf.cl'  =>  'concacaf-champions-league-2020',


'us.1'   =>  'usa-major-league-soccer-2020',
'us.2'   =>  'usa-usl-championship-2020',
'us.cup'  =>  'usa-u-s-open-cup-2019',


'mx.1' =>  'mex-primera-division-2020-2021-apertura',
'mx.cup' => 'mex-copa-mx-2019-2020',
'mx.2' => 'mex-liga-de-expansion-2020-2021-apertura',
'mx.3' => 'mex-premier-de-ascenso-2020-2021-grupo-b',

'cr.1' => 'crc-primera-division-2020-2021-apertura',
'sv.1' => 'slv-primera-division-2020-2021-apertura',

'gt.1' => 'gua-liga-nacional-2020-2021-apertura',
'hn.1' => 'hon-liga-nacional-2020-2021-apertura',

'ni.1' => 'nca-liga-primera-2020-2021-apertura',

'pe.1' => 'per-primera-division-2020-apertura',
'cl.1' => 'chi-primera-division-2020',
'uy.1' => 'uru-primera-division-2020-apertura',
'co.1' => 'col-primera-a-2020',

'bo.1' => 'bol-liga-profesional-2024-clausura',
'ec.1' => 'ecu-serie-a-2024-segunda-etapa',

'eg.1' => 'egy-premiership-2019-2020',


}


more_league_to_slug.each do |league, slug|

  path = "./slugs/#{league}.csv"

  if File.exist?( path )
    ## skip; do nothing
  else
    ## download
    Worldfootball::Metal.download_schedule( slug )  

    page = Worldfootball::Page::Schedule.from_cache( slug )

    pp page.seasons


    recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
    pp recs
    puts "  #{recs.size} record(s)"

    headers = ['season','slug']
    write_csv( path, recs, headers: headers  )
  end
end


puts "bye"