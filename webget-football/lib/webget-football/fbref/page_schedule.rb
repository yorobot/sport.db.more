
module Fbref

class Page
  class Schedule < Page  ## note: use nested class for now - why? why not?

def self.from_cache( league:, season: )
  url = Fbref.schedule_url( league: league, season: season )

  ## use - super.from_cache( url ) - why? why not?
  html = Webcache.read( url )
  new( html )
end


SCHED_KS_ID_RE = %r{(sched_ks_[a-z0-9_]+)}

def stages

  stages = []
  buttons = doc.css( 'div#all_sched_ks_all div.section_heading div.sub_section_heading button' )
  puts "#{buttons.size} button(s):"
  ## pp buttons

  buttons.each do |button|
    name     = button.text
    table_id = ''
    if button['onclick'].to_s =~ SCHED_KS_ID_RE
       table_id = $1
    else
       puts "!! ERROR - no table id found"
       exit 1
    end

    if table_id == 'sched_ks_all'  ## skip all-in-one
    else
      stages << { name:     name,
                  table_id: table_id }
    end
  end

=begin
  <div class="section_heading">
    <span class="section_anchor" id="sched_ks_all_link" data-label="Scores & Fixtures" data-no-inpage="1"></span><h2>Scores & Fixtures <span style="color: #777; font-size:smaller">2019-2020 Austrian Bundesliga</span></h2>    <div class="section_heading_text">
        <ul><li><span class="shim"></span></li>
        </ul>
      </div>
      <div class="sub_section_heading">
      <button onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_all'); }, 100);" data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_all">All Rounds</button>
      <button onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_1'); }, 100);" data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_1">Regular Season</button>
      <button onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_2'); }, 100);" data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_2">Championship round</button>
      <button onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_3'); }, 100);" data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_3">Relegation round</button>
      <button onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_4'); }, 100);" data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_4">Europa League play-offs</button>
  </div>
=end
  stages
end



def matches
  tables = @doc.css( 'table.stats_table' )

  puts " found #{tables.size} table(s):"
  tables.each do |table|
     puts "     table >#{table['id']}<"   ## add no of rows too?
  end

  rows = []
  if tables.size == 2
    ## note:  if tables size == 2 assume   all table and "regular" season table, thus, is the same (missing table for more stages!!!)
    rows += match_rows( tables[1] )
    ## todo/fix: issue a warning about missing table!!!!
    puts "!! WARN: missing stage table(s):"
    pp stages
  elsif tables.size > 1
    stages.each do |stage|
      name     = stage[:name]
      table_id = stage[:table_id]

      table = tables.find {|table| table['id'] == table_id }
      if table
       puts " adding stage >#{name}<..."
       rows += match_rows( table, stage: name )
      else
       puts "!! ERROR: table with id >< for stage >< not found; mismatch sorry"
       exit 1
      end
    end
  else
    ## assume single-table
    rows += match_rows( tables[0] )
  end

  puts " found #{tables.size} table(s):"
  tables.each do |table|
     puts "     table >#{table['id']}<"   ## add no of rows too?
  end

  rows
end


=begin
def matches_all
  rows = []

  table = @doc.css( 'table#sched_ks_all' ).first

  ths = table.css( 'thead tr th')

  puts " #{ths.size} column heading(s):"
  ths.each_with_index do |th,i|
     puts "#{i+1}: >#{th.text}< - #{th.attr('data-stat')}"
  end

  rows += match_rows( table )
  rows
end
=end


#######
# helpers

COLUMN_RENAMES = {
  'gameweek' => 'matchweek',
  'squad_a'  => 'team1',
  'squad_b'  => 'team2',
  'notes'    => 'comments',
}


def match_rows( table, **fixed_columns )
  rows = []

  trs = table.css( 'tbody tr')
  puts " #{trs.size} row(s):"

  trs.each_with_index do |tr,i|
    print "#{i+1}: "

    if tr.attr('class').to_s.index( 'spacer')
      print "---"
    else
      row = {}
      row = row.merge( fixed_columns )

      tds = tr.css( 'th,td' )
      tds.each do |td|
        key   = td.attr('data-stat')
        value = td.text.strip

        print "#{key}: >#{value}< | "

        ## note: skip expected goal (xg) for now
        next if ['xg_a', 'xg_b'].include?( key )

        ### note: rename some column keys!!
        key =  COLUMN_RENAMES[ key ] if COLUMN_RENAMES[ key ]


        if key == 'score'
          value = value.gsub( '–', '-' )  ## translate fancy dash (\u2013)
        end

        if key == 'attendance'
          ## remove thousand seperator e.g.
          ##     24,200  => 24200   etc.
          ##      1,900  =>  1900
          value = value.gsub( ',', '' )
        end

        if key == 'match_report'
          ## get href from embedded anchor link (<a href="">)
          links = td.css('a')
          value = if links.size > 0
                     links[0]['href']
                  else
                    ''   # no (linked) match report found
                  end
        end

        ## note: use ALwAYS symbols for now - why? why not?
        row[ key.to_sym ] = value
      end
      rows << row
    end
    print "\n\n"
  end

  rows
end

end # class Schedule
end # class Page
end # module Fbref





=begin
#   <table class="min_width sortable stats_table min_width" id="sched_ks_all"

13 column heading(s):
1: >Round< - round
2: >Wk< - gameweek
3: >Day< - dayofweek
4: >Date< - date
5: >Time< - time
6: >Home< - squad_a
7: >Score< - score
8: >Away< - squad_b
9: >Attendance< - attendance
10: >Venue< - venue
11: >Referee< - referee
12: >Match Report< - match_report
13: >Notes< - notes=end

<tbody>
<tr >
  <th scope="row" class="left " data-stat="round" >
   <a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a>
  </th>
  <td class="right " data-stat="gameweek" >1</td>
  <td class="left " data-stat="dayofweek" csk="6" >Fri</td>
  <td class="left " data-stat="date" csk="20190726" ><a href="/en/matches/2019-07-26">2019-07-26</a></td>
  <td class="right " data-stat="time" csk="20:45:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564166700" data-venue-time="20:45">20:45</span> <span class="localtime" data-label="your time"></span></td>
  <td class="right " data-stat="squad_a" ><a href="/en/squads/912e4c40/2019-2020/Rapid-Wien-Stats">Rapid Wien</a></td>
  <td class="center " data-stat="score" ><a href="/en/matches/341a27e4/Rapid-Wien-Red-Bull-Salzburg-July-26-2019-Austrian-Bundesliga">0&ndash;2</a></td>
  <td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/50f2a074/2019-2020/Red-Bull-Salzburg-Stats">RB Salzburg</a></td>
  <td class="right " data-stat="attendance" csk="24200" >24,200</td>
  <td class="left " data-stat="venue" >Allianz Stadion</td>
  <td class="left " data-stat="referee" csk="Alexander Harkam2019-07-26" >Alexander Harkam</td>
  <td class="left " data-stat="match_report" ><a href="/en/matches/341a27e4/Rapid-Wien-Red-Bull-Salzburg-July-26-2019-Austrian-Bundesliga">Match Report</a></td>
  <td class="left iz" data-stat="notes" ></td>
</tr>
<tr >
  <th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th>
  <td class="right sort_show" data-stat="gameweek" >1</td><td class="left " data-stat="dayofweek" csk="7" >Sat</td><td class="left " data-stat="date" csk="20190727" ><a href="/en/matches/2019-07-27">2019-07-27</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564239600" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/d7d06475/2019-2020/Admira-Wacker-Modling-Stats">Admira</a></td><td class="center " data-stat="score" ><a href="/en/matches/c32792aa/Admira-Wacker-Modling-Wolfsberger-AC-July-27-2019-Austrian-Bundesliga">0&ndash;3</a></td><td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/426658a6/2019-2020/Wolfsberger-AC-Stats">Wolfsberger AC</a></td><td class="right " data-stat="attendance" csk="1900" >1,900</td><td class="left " data-stat="venue" >BSFZ-Arena</td><td class="left " data-stat="referee" csk="Christian-Petru Ciochirca2019-07-27" >Christian-Petru Ciochirca</td><td class="left " data-stat="match_report" ><a href="/en/matches/c32792aa/Admira-Wacker-Modling-Wolfsberger-AC-July-27-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >1</td><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20190727" ><a href="/en/matches/2019-07-27">2019-07-27</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564239600" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/c63dd2d5/2019-2020/WSG-Wattens-Stats">WSG Wattens</a></td><td class="center " data-stat="score" ><a href="/en/matches/1cbbfd76/WSG-Wattens-Austria-Wien-July-27-2019-Austrian-Bundesliga">3&ndash;1</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/ee0bccc5/2019-2020/Austria-Wien-Stats">Austria Wien</a></td><td class="right " data-stat="attendance" csk="4600" >4,600</td><td class="left " data-stat="venue" >Tivoli Stadion Tirol</td><td class="left " data-stat="referee" csk="Christopher Jäger2019-07-27" >Christopher Jäger</td><td class="left " data-stat="match_report" ><a href="/en/matches/1cbbfd76/WSG-Wattens-Austria-Wien-July-27-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >1</td><td class="left " data-stat="dayofweek" csk="1" >Sun</td><td class="left " data-stat="date" csk="20190728" ><a href="/en/matches/2019-07-28">2019-07-28</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564326000" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/d20821dd/2019-2020/LASK-Stats">LASK</a></td><td class="center " data-stat="score" ><a href="/en/matches/96a71a15/LASK-Rheindorf-Altach-July-28-2019-Austrian-Bundesliga">2&ndash;0</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/80beba99/2019-2020/Rheindorf-Altach-Stats">SCR Altach</a></td><td class="right " data-stat="attendance" csk="5333" >5,333</td><td class="left " data-stat="venue" >TGW Arena </td><td class="left " data-stat="referee" csk="Harald Lechner2019-07-28" >Harald Lechner</td><td class="left " data-stat="match_report" ><a href="/en/matches/96a71a15/LASK-Rheindorf-Altach-July-28-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >1</td><td class="left sort_show" data-stat="dayofweek" csk="1" >Sun</td><td class="left sort_show" data-stat="date" csk="20190728" ><a href="/en/matches/2019-07-28">2019-07-28</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564326000" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/2ff6d16e/Mattersburg-Stats">Mattersburg</a></td><td class="center " data-stat="score" ><a href="/en/matches/6ae7c604/Mattersburg-Hartberg-July-28-2019-Austrian-Bundesliga">2&ndash;1</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/f6d9c820/2019-2020/Hartberg-Stats">Hartberg</a></td><td class="right " data-stat="attendance" csk="2850" >2,850</td><td class="left " data-stat="venue" >Pappelstadion</td><td class="left " data-stat="referee" csk="Manuel Schüttengruber2019-07-28" >Manuel Schüttengruber</td><td class="left " data-stat="match_report" ><a href="/en/matches/6ae7c604/Mattersburg-Hartberg-July-28-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >1</td><td class="left sort_show" data-stat="dayofweek" csk="1" >Sun</td><td class="left sort_show" data-stat="date" csk="20190728" ><a href="/en/matches/2019-07-28">2019-07-28</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564326000" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/3f4fe568/2019-2020/Sturm-Graz-Stats">Sturm Graz</a></td><td class="center " data-stat="score" ><a href="/en/matches/0427bf0f/Sturm-Graz-St-Polten-July-28-2019-Austrian-Bundesliga">3&ndash;0</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/f722bd04/2019-2020/St-Polten-Stats">St. Pölten</a></td><td class="right " data-stat="attendance" csk="7194" >7,194</td><td class="left " data-stat="venue" >Merkur Arena</td><td class="left " data-stat="referee" csk="Walter Altmann2019-07-28" >Walter Altmann</td><td class="left " data-stat="match_report" ><a href="/en/matches/0427bf0f/Sturm-Graz-St-Polten-July-28-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr class="spacer partial_table" style="background-color:#ddd" >
  <th scope="row" class="left iz" data-stat="round" ></th>
  <td class="right iz" data-stat="gameweek" ></td>
  <td class="left iz" data-stat="dayofweek" ></td>
  <td class="left iz" data-stat="date" ></td>
  <td class="right iz" data-stat="time" ></td>
  <td class="right iz" data-stat="squad_a" ></td>
  <td class="center iz" data-stat="score" ></td>
  <td class="left iz" data-stat="squad_b" ></td>
  <td class="right iz" data-stat="attendance" ></td>
  <td class="left iz" data-stat="venue" ></td>
  <td class="left iz" data-stat="referee" ></td>
  <td class="left iz" data-stat="match_report" ></td>
  <td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right " data-stat="gameweek" >2</td><td class="left " data-stat="dayofweek" csk="7" >Sat</td><td class="left " data-stat="date" csk="20190803" ><a href="/en/matches/2019-08-03">2019-08-03</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564844400" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/ee0bccc5/2019-2020/Austria-Wien-Stats">Austria Wien</a></td><td class="center " data-stat="score" ><a href="/en/matches/ec58586a/Austria-Wien-LASK-August-3-2019-Austrian-Bundesliga">0&ndash;3</a></td><td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/d20821dd/2019-2020/LASK-Stats">LASK</a></td><td class="right " data-stat="attendance" csk="9350" >9,350</td><td class="left " data-stat="venue" >Generali Arena</td><td class="left " data-stat="referee" csk="Sebastian Gishamer2019-08-03" >Sebastian Gishamer</td><td class="left " data-stat="match_report" ><a href="/en/matches/ec58586a/Austria-Wien-LASK-August-3-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >2</td><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20190803" ><a href="/en/matches/2019-08-03">2019-08-03</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564844400" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/80beba99/2019-2020/Rheindorf-Altach-Stats">SCR Altach</a></td><td class="center " data-stat="score" ><a href="/en/matches/df2d69d0/Rheindorf-Altach-WSG-Wattens-August-3-2019-Austrian-Bundesliga">3&ndash;2</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/c63dd2d5/2019-2020/WSG-Wattens-Stats">WSG Wattens</a></td><td class="right " data-stat="attendance" csk="4038" >4,038</td><td class="left " data-stat="venue" >CASHPOINT Arena</td><td class="left " data-stat="referee" csk="Gerhard Grobelnik2019-08-03" >Gerhard Grobelnik</td><td class="left " data-stat="match_report" ><a href="/en/matches/df2d69d0/Rheindorf-Altach-WSG-Wattens-August-3-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Regular Season</a></th><td class="right sort_show" data-stat="gameweek" >2</td><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20190803" ><a href="/en/matches/2019-08-03">2019-08-03</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1564844400" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/f6d9c820/2019-2020/Hartberg-Stats">Hartberg</a></td><td class="center " data-stat="score" ><a href="/en/matches/7d8949d5/Hartberg-Admira-Wacker-Modling-August-3-2019-Austrian-Bundesliga">4&ndash;1</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/d7d06475/2019-2020/Admira-Wacker-Modling-Stats">Admira</a></td><td class="right " data-stat="attendance" csk="2624" >2,624</td><td class="left " data-stat="venue" >PROfertil ARENA</td><td class="left " data-stat="referee" csk="Josef Spurny2019-08-03" >Josef Spurny</td><td class="left " data-stat="match_report" ><a href="/en/matches/7d8949d5/Hartberg-Admira-Wacker-Modling-August-3-2019-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>

<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Championship round</a></th><td class="right sort_show" data-stat="gameweek" >10</td><td class="left sort_show" data-stat="dayofweek" csk="1" >Sun</td><td class="left sort_show" data-stat="date" csk="20200705" ><a href="/en/matches/2020-07-05">2020-07-05</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1593961200" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/426658a6/2019-2020/Wolfsberger-AC-Stats">Wolfsberger AC</a></td><td class="center " data-stat="score" ><a href="/en/matches/ee9840f1/Wolfsberger-AC-Rapid-Wien-July-5-2020-Austrian-Bundesliga">3&ndash;1</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/912e4c40/2019-2020/Rapid-Wien-Stats">Rapid Wien</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Lavanttal-Arena</td><td class="left " data-stat="referee" csk="Alexander Harkam2020-07-05" >Alexander Harkam</td><td class="left " data-stat="match_report" ><a href="/en/matches/ee9840f1/Wolfsberger-AC-Rapid-Wien-July-5-2020-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr class="spacer partial_table" style="background-color:#ddd" >
<th scope="row" class="left iz" data-stat="round" ></th>
<td class="right iz" data-stat="gameweek" ></td>
<td class="left iz" data-stat="dayofweek" ></td>
<td class="left iz" data-stat="date" ></td>
<td class="right iz" data-stat="time" ></td>
<td class="right iz" data-stat="squad_a" ></td>
<td class="center iz" data-stat="score" ></td>
<td class="left iz" data-stat="squad_b" ></td><td class="right iz" data-stat="attendance" ></td><td class="left iz" data-stat="venue" ></td><td class="left iz" data-stat="referee" ></td><td class="left iz" data-stat="match_report" ></td><td class="left iz" data-stat="notes" ></td></tr>
<tr >
  <th scope="row" class="left " data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Semi-final</a></th>
  <td class="right iz" data-stat="gameweek" ></td>
  <td class="left " data-stat="dayofweek" csk="4" >Wed</td>
  <td class="left " data-stat="date" csk="20200708" ><a href="/en/matches/2020-07-08">2020-07-08</a></td><td class="right " data-stat="time" csk="20:30:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1594233000" data-venue-time="20:30">20:30</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/ee0bccc5/2019-2020/Austria-Wien-Stats">Austria Wien</a></td><td class="center " data-stat="score" ><a href="/en/matches/6a1148ed/Austria-Wien-Rheindorf-Altach-July-8-2020-Austrian-Bundesliga">1&ndash;0</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/80beba99/2019-2020/Rheindorf-Altach-Stats">SCR Altach</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Generali Arena</td><td class="left " data-stat="referee" csk="Sebastian Gishamer2020-07-08" >Sebastian Gishamer</td><td class="left " data-stat="match_report" ><a href="/en/matches/6a1148ed/Austria-Wien-Rheindorf-Altach-July-8-2020-Austrian-Bundesliga">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="left " data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Finals</a></th><td class="right iz" data-stat="gameweek" ></td><td class="left " data-stat="dayofweek" csk="7" >Sat</td><td class="left " data-stat="date" csk="20200711" ><a href="/en/matches/2020-07-11">2020-07-11</a></td><td class="right " data-stat="time" csk="17:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1594479600" data-venue-time="17:00">17:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/ee0bccc5/2019-2020/Austria-Wien-Stats">Austria Wien</a></td><td class="center " data-stat="score" ><a href="/en/matches/5be35bf7/Austria-Wien-Hartberg-July-11-2020-Austrian-Bundesliga">2&ndash;3</a></td><td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/f6d9c820/2019-2020/Hartberg-Stats">Hartberg</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Generali Arena</td><td class="left " data-stat="referee" csk="Christopher Jäger2020-07-11" >Christopher Jäger</td><td class="left " data-stat="match_report" ><a href="/en/matches/5be35bf7/Austria-Wien-Hartberg-July-11-2020-Austrian-Bundesliga">Match Report</a></td><td class="left " data-stat="notes" >Leg 1 of 2</td></tr>
<tr ><th scope="row" class="left sort_show" data-stat="round" ><a href="/en/comps/56/3213/2019-2020-Austrian-Bundesliga-Stats">Finals</a></th><td class="right iz" data-stat="gameweek" ></td><td class="left " data-stat="dayofweek" csk="4" >Wed</td><td class="left " data-stat="date" csk="20200715" ><a href="/en/matches/2020-07-15">2020-07-15</a></td><td class="right " data-stat="time" csk="20:30:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1594837800" data-venue-time="20:30">20:30</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/f6d9c820/2019-2020/Hartberg-Stats">Hartberg</a></td><td class="center " data-stat="score" ><a href="/en/matches/c8376d96/Hartberg-Austria-Wien-July-15-2020-Austrian-Bundesliga">0&ndash;0</a></td><td class="left " data-stat="squad_b" ><a href="/en/squads/ee0bccc5/2019-2020/Austria-Wien-Stats">Austria Wien</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >PROfertil ARENA</td><td class="left " data-stat="referee" csk="Manuel Schüttengruber2020-07-15" >Manuel Schüttengruber</td><td class="left " data-stat="match_report" ><a href="/en/matches/c8376d96/Hartberg-Austria-Wien-July-15-2020-Austrian-Bundesliga">Match Report</a></td><td class="left " data-stat="notes" >Leg 2 of 2; Hartberg won</td></tr>


<div class="sub_section_heading">
<button class="sr_preset tooltip visible  active" type="button"
onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_all'); }, 100);"
data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_all">All Rounds</button>
<button class="sr_preset tooltip visible " type="button"
onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_1'); }, 100);"
data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_1">Regular Season</button>
<button class="sr_preset tooltip visible "
type="button" onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_2'); }, 100);" data-hide="[id^=all_sched_ks]"
data-show="#all_sched_ks_3213_2">Championship round</button>
<button class="sr_preset tooltip visible "
type="button" onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_3'); }, 100);" data-hide="[id^=all_sched_ks]"
data-show="#all_sched_ks_3213_3">Relegation round</button>
<button class="sr_preset tooltip visible "
type="button" onclick="setTimeout(function(){sr_st_construct_stats_table_features('sched_ks_3213_4'); }, 100);"
data-hide="[id^=all_sched_ks]" data-show="#all_sched_ks_3213_4">Europa League play-offs</button>


<tr ><th scope="row" class="right " data-stat="gameweek" >1</th><td class="left " data-stat="dayofweek" csk="7" >Sat</td><td class="left " data-stat="date" csk="20200912" ><a href="/en/matches/2020-09-12">2020-09-12</a></td><td class="right iz" data-stat="time" ></td><td class="right " data-stat="squad_a" ><a href="/en/squads/943e8050/Burnley-Stats">Burnley</a></td><td class="right iz" data-stat="xg_a" ></td><td class="center iz" data-stat="score" ></td><td class="right iz" data-stat="xg_b" ></td><td class="left " data-stat="squad_b" ><a href="/en/squads/19538871/Manchester-United-Stats">Manchester Utd</a></td><td class="right iz" data-stat="attendance" ></td><td class="left " data-stat="venue" >Turf Moor</td><td class="left iz" data-stat="referee" csk="2020-09-12" ></td><td class="left iz" data-stat="match_report" ></td><td class="left " data-stat="notes" >Match Postponed</td></tr>
<tr ><th scope="row" class="right sort_show" data-stat="gameweek" >1</th>
 <td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td>
 <td class="left sort_show" data-stat="date" csk="20200912" >
   <a href="/en/matches/2020-09-12">2020-09-12</a></td>
  <td class="right iz" data-stat="time" ></td>
  <td class="right " data-stat="squad_a" ><a href="/en/squads/b8fd03ef/Manchester-City-Stats">Manchester City</a></td><td class="right iz" data-stat="xg_a" ></td><td class="center iz" data-stat="score" ></td><td class="right iz" data-stat="xg_b" ></td><td class="left " data-stat="squad_b" ><a href="/en/squads/8602292d/Aston-Villa-Stats">Aston Villa</a></td><td class="right iz" data-stat="attendance" ></td><td class="left " data-stat="venue" >Etihad Stadium</td><td class="left iz" data-stat="referee" csk="2020-09-12" ></td><td class="left iz" data-stat="match_report" ></td><td class="left " data-stat="notes" >Match Postponed</td></tr>
<tr ><th scope="row" class="right sort_show" data-stat="gameweek" >1</th><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20200912" ><a href="/en/matches/2020-09-12">2020-09-12</a></td><td class="right " data-stat="time" csk="12:30:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1599910200" data-venue-time="12:30">12:30</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/fd962109/Fulham-Stats">Fulham</a></td><td class="right " data-stat="xg_a" >0.2</td><td class="center " data-stat="score" ><a href="/en/matches/bf52349b/Fulham-Arsenal-September-12-2020-Premier-League">0&ndash;3</a></td><td class="right " data-stat="xg_b" >1.8</td><td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/18bb7c10/Arsenal-Stats">Arsenal</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Craven Cottage</td><td class="left " data-stat="referee" csk="Chris Kavanagh2020-09-12" >Chris Kavanagh</td><td class="left " data-stat="match_report" ><a href="/en/matches/bf52349b/Fulham-Arsenal-September-12-2020-Premier-League">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="right sort_show" data-stat="gameweek" >1</th><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20200912" ><a href="/en/matches/2020-09-12">2020-09-12</a></td><td class="right " data-stat="time" csk="15:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1599919200" data-venue-time="15:00">15:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/47c64c55/Crystal-Palace-Stats">Crystal Palace</a></td><td class="right " data-stat="xg_a" >0.7</td><td class="center " data-stat="score" ><a href="/en/matches/db261cb0/Crystal-Palace-Southampton-September-12-2020-Premier-League">1&ndash;0</a></td><td class="right " data-stat="xg_b" >0.8</td><td class="left " data-stat="squad_b" ><a href="/en/squads/33c895d4/Southampton-Stats">Southampton</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Selhurst Park</td><td class="left " data-stat="referee" csk="Jonathan Moss2020-09-12" >Jonathan Moss</td><td class="left " data-stat="match_report" ><a href="/en/matches/db261cb0/Crystal-Palace-Southampton-September-12-2020-Premier-League">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr >
  <th scope="row" class="right sort_show" data-stat="gameweek" >1</th>
  <td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td>
  <td class="left sort_show" data-stat="date" csk="20200912" ><a href="/en/matches/2020-09-12">2020-09-12</a></td>
  <td class="right " data-stat="time" csk="17:30:00" >
     <span class="venuetime" data-venue-time-only="1" data-venue-epoch="1599928200" data-venue-time="17:30">17:30</span>
     <span class="localtime" data-label="your time"></span>
  </td>
  <td class="right " style="font-weight: bold;" data-stat="squad_a" ><a href="/en/squads/822bd0ba/Liverpool-Stats">Liverpool</a></td><td class="right " data-stat="xg_a" >3.3</td><td class="center " data-stat="score" ><a href="/en/matches/21b58926/Liverpool-Leeds-United-September-12-2020-Premier-League">4&ndash;3</a></td><td class="right " data-stat="xg_b" >0.6</td><td class="left " data-stat="squad_b" ><a href="/en/squads/5bfb9659/Leeds-United-Stats">Leeds United</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >Anfield</td><td class="left " data-stat="referee" csk="Michael Oliver2020-09-12" >Michael Oliver</td><td class="left " data-stat="match_report" ><a href="/en/matches/21b58926/Liverpool-Leeds-United-September-12-2020-Premier-League">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>
<tr ><th scope="row" class="right sort_show" data-stat="gameweek" >1</th><td class="left sort_show" data-stat="dayofweek" csk="7" >Sat</td><td class="left sort_show" data-stat="date" csk="20200912" ><a href="/en/matches/2020-09-12">2020-09-12</a></td><td class="right " data-stat="time" csk="20:00:00" ><span class="venuetime" data-venue-time-only="1" data-venue-epoch="1599937200" data-venue-time="20:00">20:00</span> <span class="localtime" data-label="your time"></span></td><td class="right " data-stat="squad_a" ><a href="/en/squads/7c21e445/West-Ham-United-Stats">West Ham</a></td><td class="right " data-stat="xg_a" >1.1</td><td class="center " data-stat="score" ><a href="/en/matches/78495ced/West-Ham-United-Newcastle-United-September-12-2020-Premier-League">0&ndash;2</a></td><td class="right " data-stat="xg_b" >1.5</td><td class="left " style="font-weight: bold;" data-stat="squad_b" ><a href="/en/squads/b2b47a98/Newcastle-United-Stats">Newcastle Utd</a></td><td class="right iz" data-stat="attendance" csk="0" ></td><td class="left " data-stat="venue" >London Stadium</td><td class="left " data-stat="referee" csk="Stuart Attwell2020-09-12" >Stuart Attwell</td><td class="left " data-stat="match_report" ><a href="/en/matches/78495ced/West-Ham-United-Newcastle-United-September-12-2020-Premier-League">Match Report</a></td><td class="left iz" data-stat="notes" ></td></tr>

=end

