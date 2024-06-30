
module Worldfootball
  class Page

class Report < Page  ## note: use nested class for now - why? why not?


  def self.from_cache( slug )
    url  = Metal.report_url( slug )
    html = Webcache.read( url )
    new( html )
  end



  def find_table_tore
    # <table class="" cellpadding="3" cellspacing="1">
    # <tr>
    #   <td colspan="2" class="ueberschrift" align="center">Tore</td>
    # </tr>

   ## get table
   ##   first table row is Tore
    tables = doc.css( 'table.standard_tabelle' )
    # puts "  found #{tables.size} table.standard_tabelle" # e.g. found 6 table.standard_tabelle
    tables.each do |table|
      trs = table.css( 'tr' )
      ## puts "     found #{trs.size} trs"
      tds = trs[0].css( 'td' )
      ## puts "     found #{tds.size} tds"

      if tds.size > 0 && tds[0].text == 'Tore'
        return table
      end
    end

    nil  ## nothing found; auto-report error -why? why not?
  end

  def goals
    @goals ||= begin

 # <div class="data">
 # <table class="standard_tabelle" cellpadding="3" cellspacing="1">

 # puts table.class.name  #=> Nokogiri::XML::Element
 # puts table.text

 table  = find_table_tore
 ## pp table

 trs   = table.css( 'tr' )
 # puts trs.size



 rows = []
 last_score1 = 0
 last_score2 = 0

 trs.each_with_index do |tr,i|

   next if i==0   # skip Tore headline row

   break if i==1 && tr.text.strip == 'keine'  ## assume 0:0 - no goals

# <tr>
#  <td class="hell" align="center" width="20%">
#   <b>0 : 1</b>
#  </td>
#  <td class="hell" style="padding-left: 50px;">
#   <a href="/spieler_profil/luis-phelipe/" title="Luis Phelipe">Luis Phelipe</a> 34. / Rechtsschuss								&nbsp;(<a href="/spieler_profil/alexander-prass/" title="Alexander Prass">Alexander Prass</a>)
# </td>
# </tr>

       tds = tr.css( 'td' )

     score_str  = squish( tds[0].text )

     player_str = squish( tds[1].text )

     print '[%03d] ' % i
     print score_str
     print " | "
     print player_str
     print "\n"

     score_str = score_str.gsub( ':', '-' )
     score_str = score_str.gsub( ' ', '' )   ## remove all white space


     ### todo/fix: use new Score.split helper here
     ## score1, score2 = Score.split( score_str )
     parts = score_str.split('-')
     score1 = parts[0].to_i
     score2 = parts[1].to_i

     if last_score1+1 == score1 && last_score2 == score2
       team = 1
     elsif last_score2+1 == score2 && last_score1 == score1
       team = 2
     else
       puts "!! ERROR - unexpected score advance (one goal at a time expected):"
       puts "  #{last_score1}-#{last_score2}=> #{score1}-#{score2}"
       exit 1
     end


     last_score1 = score1
     last_score2 = score2



     if player_str.index('/')
       parts = player_str.split('/')
       # pp parts
       notes = parts[1].strip

       if parts[0].strip =~ /^([^0-9]+)[ ]+([0-9]+)\.$/
         player_name = $1
         goal_minute = $2
          # puts " >#{player_name}< | >#{goal_minute}<"
       else
         puts "!! ERROR - unknown goal format (in part i):"
         puts player_str
         pp parts
         exit 1
       end
      else  # (simple line with no divider (/)
        #  Andrés Andrade 88.  (Nicolas Meister)
        if m = %r{^([^0-9]+)
                  [ ]+
                 ([0-9]+)\.
                  (?:
                    [ ]+
                    (\([^)]+\))
                  )?
                $}x.match( player_str )
            player_name = m[1]
            goal_minute = m[2]
            notes       = m[3] ? m[3] : ''
        else
          puts "!! ERROR - unknown goal format:"
          puts player_str
          exit 1
        end
      end


     ## check for "flags" e.g. own goal or penalty
     ##   if found - remove from notes (use its own flag)
     owngoal = false
     penalty = false

    if notes.index( 'Eigentor' )
       owngoal = true
       notes = notes.sub('Eigentor', '' ).strip
    elsif notes.index( 'Elfmeter' )
      ## e.g.  Elfmeter  (Marco Hausjell)
       penalty = true
       notes = notes.sub('Elfmeter', '' ).strip
    else
      ## nothing - keep going
    end

     rec = { score:   score_str,
             team:    team,     # 1 or 2
             player:  player_name,
             minute:  goal_minute
             }
      rec[:owngoal] = true   if owngoal
      rec[:penalty] = true   if penalty
      rec[:notes]   = notes  unless notes.empty?

      rows << rec
   end ## each tr
      rows
   end
 end  # goals


end # class Report


  end # class Page
end # module Worldfootball
