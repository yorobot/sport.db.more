##########
#  to run use:
#   $ ruby upslugs/export.rb


##
#  export slug pages to json

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


Webcache.config.root = '../../../cache'


def export( slug, league: )
 
   page = Worldfootball::Page::Schedule.from_cache( slug )

   ## note - use league (code/key) as directory
   path = "/sports/cache.wfb.slugs/#{league}/#{slug}.json"

  ###
  ### todo/fix -   skip if file exists
  ##                  add overwrite/update/force option - why? why not?

   ## add more stats
   ##  dates: first, last !!!
   ##
   ## add league key e.g. eng.1, es.1 etc, - why? why not?

   matches = page.matches
   teams   = page.teams
   rounds  = page.rounds         

   first = '9999-99-99'
   last  = '0000-00-00'
   matches.each do |m|
     if m[:date]
         first = m[:date ]  if m[:date] < first
         last  = m[:date]   if m[:date] > last
     end
   end


   data = {  page: { title: page.title.sub('» Spielplan', '').strip,
                     slug: slug,
                     ## add season (text) - why? why not?
                     match_count: matches.size,
                     team_count:  teams.size,
                     rounds_count: rounds.size,
                     dates: { first: first, 
                              last:  last }
                      },
             matches: matches,
             teams:   teams,
             rounds:  rounds,         
          }

  puts "#{slug} -- #{matches.size} match(es)"
   write_json( path, data )
end # method export



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


more_league_to_slug.keys.each do |league|

  path = "./slugs/#{league}.csv"

  recs = read_csv( path )
  puts "  #{recs.size} record(s)"

  recs.each_with_index do |rec,i|
    slug = rec['slug']
    puts "#{league} [#{i+1}/#{recs.size}] >#{slug}<"
    export( slug, league: league )
  end
end


puts "bye"
