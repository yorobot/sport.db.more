
module Worldfootball
  class Page

class Schedule < Page  ## note: use nested class for now - why? why not?


  def self.from_cache( slug )
    url  = Metal.schedule_url( slug )
    html = Webcache.read( url )
    new( html )
  end



  def matches
    @matches ||= begin

 # <div class="data">
 # <table class="standard_tabelle" cellpadding="3" cellspacing="1">

 ## note: use > for "strict" sibling (child without any in-betweens)
 table = doc.css( 'div.data > table.standard_tabelle' ).first    ## get table
 # puts table.class.name  #=> Nokogiri::XML::Element
 # puts table.text

 assert( table, 'no table.standard_tabelle found in schedule page!!')

 trs   = table.css( 'tr' )
 # puts trs.size
 i = 0

 last_date_str = nil
 last_round    = nil

 rows = []



 trs.each do |tr|

## ghost trs? what for? see for an example in bra
##    check for style display:none - why? why not?
##
## <tr class="e2-parent" data-liga_id="88" data-gs_match_id="9062777"
##                         style="display:none;">
##          <td colspan="2"></td>
##          <td colspan="3">
##            <span class="e2" data-liga_id="88"  data-gs_match_id="9062777"></span>
##          </td>
##          <td colspan="2"></td>
##        </tr>
  ##
  #   <tr class="e2-parent" data-liga_id="530" data-gs_match_id="10259222" 
  #       style="display:none;">
  ##    <td colspan="2"></td>
  ##    <td colspan="3">
  ##      <span class="e2" data-liga_id="530" data-gs_match_id="10259222"></span>
  ##    </td>
  ##    <td colspan="2"></td>
  ##  </tr>
   if tr['style'] && tr['style'].index( 'display') &&
                     tr['style'].index( 'none')
     puts "!! WARN: skipping ghost line >#{tr.text.strip}<"
     next
   end


   i += 1

    ## puts "[debug] row #{i} >#{tr.text.strip}<" 

    ### note - assume for now match lines use tds
    ##            and round lines use ths (NOT tds)!!
    ##  e.g. <th colspan="7">8. Spieltag</th>

    ths =  tr.css( 'th' )
    tds =  tr.css( 'td' )
    
   if tr.text.strip =~ /Spieltag/ ||
      tr.text.strip =~ /[1-9]\.[ ]Runde|
                           Qual\.[ ][1-9]\.[ ]Runde|  # see EL or CL Quali
                           Qualifikation|     # see CA Championship
                           Sechzehntelfinale|   # see EL
                           Achtelfinale|
                           Viertelfinale|
                           Halbfinale|
                           Finale|
                           Gruppe[ ][A-Z]|    # see CL
                           Gruppe[ ][1-9]|    # see slv-primera-division-2020-2021-clausura_3
                           Playoffs|           # see EL Quali
                           Entscheidungsspiel|   # see Serie A 2022-23 Entscheidung Abstieg
                           Spiele|                # see Serie A 1960-61 Relegation
                           3\.[ ]Platz|      # see bra-serie-a-2000-yellow-module-playoffs
                           Spiel[ ]um[ ]Platz[ ]3|  # see campeonato-2009-cuadrangulares-deportivo-cuenca-cs-emelec
                           Relegation|     # see egy-premiership-2013-2014-abstiegsplayoff    
                           Copa[ ]Libertadores|  # see ecu-campeonato-2012-segunda-etapa-playoffs 
                           Copa[ ]Sudamericana|  # see campeonato-2012-liguilla-final-playoffs-cs-emelec-ldu-quito
                           Repechaje|  # see nca-liga-primera-2023-2024-clausura-playoffs 
                           Final[ ]de[ ]Grupos|   # see hon-liga-nacional-2020-2021-clausura-playoffs  
                           Gran[ ]Final|   # see liga-nacional-2020-2021-apertura-playoffs-finale-olimpia-motagua
                           Finalrunde|  # see hon-liga-nacional-2019-2020-apertura-pentagonal
                           Zona[ ]A|    # see gua-liga-nacional-2020-2021-clausura      
                           Zona[ ]B|    # see liga-nacional-2020-2021-clausura-zona-a-comunicaciones-deportivo-malacateco    
                           Interzone|    # see liga-nacional-2020-2021-clausura-zona-b-achuapa-sanarate
                           Final[ ]Segunda[ ]Ronda|    # see crc-primera-division-2018-2019-apertura-playoffs
                           Quadrangular      # see crc-primera-division-2016-2017-verano-playoffs
                           /x
                          
     puts
     print '[%03d] ' % i
     ## print squish( tr.text )
     print "round >#{tr.text.strip}<"
     print "\n"

     last_round = tr.text.strip
   elsif ths.count > 0 && 
         tds.count == 0
       ## check for round NOT yet configured!!!
       puts "!! WARN: found unregistered round line >#{tr.text.strip}<"
       log( "!! WARN: found unregistered round line >#{tr.text.strip}< in page #{title}" )

       last_round = tr.text.strip
   else   ## assume table row (tr) is match line

     date_str  = squish( tds[0].text )
     time_str  = squish( tds[1].text )

     date_str = last_date_str    if date_str.empty?

     ## note: for debugging - print as we go along (parsing)
     print '[%03d]    ' % i
     print "%-10s | " % date_str
     print "%-5s | " % time_str


     # was: team1_str = squish( tds[2].text )

     ## <td><a href="/teams/hibernian-fc/" title="Hibernian FC">Hibernian FC</a></td>
     ##  todo/check: check if tooltip title always equals text - why? why not?
     team1_anchor = tds[2].css( 'a' )[0]
     if team1_anchor  # note: <a> might be optional (and team name only be plain text)
       team1_str    = squish( team1_anchor.text )
       team1_ref    = norm_team_ref( team1_anchor[:href] )
     else
       team1_str    = squish( tds[2].text )
       team1_ref    = nil
       puts "!! WARN: no team1_ref for >#{team1_str}< found"
     end

     ## note: for debugging - print as we go along (parsing)
     print "%-22s | " % team1_str

     ##  <td> - </td>
     ## e.g. -
     vs_str =    squish( tds[3].text )  ## use to assert column!!!
     assert( vs_str == '-',  "- for vs. expected; got #{vs_str}")
     ## was: team2_str = squish( tds[4].text )

     ## <td><a href="/teams/st-johnstone-fc/" title="St. Johnstone FC">St. Johnstone FC</a></td>
     team2_anchor = tds[4].css( 'a' )[0]
     if team2_anchor
       team2_str    = squish( team2_anchor.text )
       team2_ref    = norm_team_ref( team2_anchor[:href] )
     else
       team2_str    = squish( tds[4].text )
       team2_ref    = nil
       puts "!! WARN: no team2_ref for >#{team2_str}< found"
     end

     ## note: for debugging - print as we go along (parsing)
     print "%-22s | " % team2_str



     ### was: score_str = squish( tds[5].text )
     ## <a href="/spielbericht/premiership-2020-2021-hibernian-fc-st-johnstone-fc/" title="Spielschema Hibernian FC - St. Johnstone FC">-:-</a>

     score_anchor = tds[5].css( 'a' )[0]
     if score_anchor   ## note: score ref (match report) is optional!!!!
       score_str    = squish( score_anchor.text )
       score_ref    = norm_score_ref( score_anchor[:href] )
     else
       score_str    = squish( tds[5].text )
       score_ref    = nil
     end


     ##  todo - find a better way to check for live match
     ## check for live badge image
     ## <td>
     ##   <img src="https://s.hs-data.com/bilder/shared/live/2.png" /></a>
     ## </td>
     img = tds[6].css( 'img' )[0]
     if img && img[:src].index( '/live/')
       puts "!! WARN: live match badge, resetting score from #{score_str} to -:-"
       score_str = '-:-'  # note: -:- gets replaced to ---
     end


     print "%-10s | " % score_str
     print (score_ref ? score_ref : 'n/a')
     print "\n"


     ## change  2:1 (1:1)  to 2-1 (1-1)
     score_str = score_str.gsub( ':', '-' )

     ## convert date from 25.10.2019 to 2019-25-10

     ## special case for '00.00.0000'
     ##   CANNOT parse
     ##   use empty date - why? why not?

     date     = if date_str == '00.00.0000'
                  nil
                else 
                  Date.strptime( date_str, '%d.%m.%Y' )
                end

     ## note: keep structure flat for now
     ##        (AND not nested e.g. team:{text:,ref:}) - why? why not?
     rows << { round:      last_round,
               date:       date ? date.strftime( '%Y-%m-%d' ) : '',
               time:       time_str,
               team1:      team1_str,
               team1_ref:  team1_ref,
               score:      score_str,
               team2:      team2_str,
               team2_ref:  team2_ref,
               report_ref: score_ref
             }

     last_date_str = date_str
   end
  end # each tr (table row)

    rows
   end
 end  # matches



 def teams
  @teams ||= begin
     h = {}
     matches.each do |match|
       ## index by name/text for now NOT ref - why? why not?
       [{text: match[:team1],
         ref:  match[:team1_ref]},
        {text: match[:team2],
         ref:  match[:team2_ref]}].each do |team|
         rec = h[ team[:text] ] ||= { count: 0,
                                      name: team[ :text],
                                      ref:  team[ :ref ] }
         rec[ :count ] += 1
         ## todo/check:  check/assert that name and ref are always equal - why? why not?
       end
     end

     h.values
  end
 end

 def rounds
  @rounds ||= begin
     h = {}
     matches.each do |match|
       rec = h[ match[:round] ] ||= { count: 0,
                                      name: match[ :round] }
        rec[ :count ] += 1
     end

     h.values
  end
 end


 def seasons
  # <select name="saison" ...
  @seasons ||= begin
     recs = []
     season = doc.css( 'select[name="saison"]').first
     options = season.css( 'option' )

     options.each do |option|
        recs << { text: squish( option.text ),
                  ref:  norm_season_ref( option[:value] )
                }
     end
     recs
  end
end


######
## helpers

## todo/check - rename/use HREF and not REF - why? why not?
REF_SCORE_RE = %r{^/spielbericht/
                     ([a-z0-9_-]+)/$}x

def norm_score_ref( str )
  ## check ref format / path
  if m=REF_SCORE_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected score href format >#{str}<"
    exit 1
  end
end


REF_TEAM_RE  = %r{^/teams/
                     ([a-z0-9_-]+)/$}x

def norm_team_ref( str )
  ## check ref format / path
  if m=REF_TEAM_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected team href format >#{str}<"
    exit 1
  end
end


REF_SEASON_RE = %r{^/alle_spiele/
                        ([a-z0-9_-]+)/$}x

def norm_season_ref( str )
  ## check ref format / path
  if m=REF_SEASON_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected season href format >#{str}<"
    exit 1
  end
end
end # class Schedule


  end # class Page
end # module Worldfootball
