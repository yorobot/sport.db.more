module ApiFootball
### add a nested namespace - why? why not?


def self.assert( cond, msg )
    if !cond 
       raise ArgumentError, "assert faild - #{msg}"
    end
end
  

### change to build_leagues or such - why? why not?
##   - todo - add count for all leagues and seasons with reduce - why? why not?
def self.build( leagues,  outdir: './o' )
  leagues.each_with_index do |(league, seasons),i|
    seasons.each_with_index do |season,j|
       puts "==> #{i+1} | #{league} #{j+1}/#{seasons.size}"
       buf = build_fixtures( league: league, season: season ) 
       puts buf

       season = Season( season )
       path = "#{outdir}/#{season.to_path}/#{league}.txt"
       write_txt( path, buf )
    end
  end
end




def self._build_score( score:, status: )

  ## todo - fix
  ##  pass in fixture NOT score, status - need also access to goal section!!!


   status_long  = status['long']   ##  Match Finished
   status_short = status['short'].upcase   ## make Canc into CANC
   status_elapsed = status['elapsed']  ## 90, 120
   ## note - elapsed is nil for Walkover
 

   if status_long == 'Match Cancelled' && status_short == 'CANC' 
      return '[cancelled]'  
   end       
  
   if status_long == 'Match Postponed' && status_short == 'PST'
      return '[postponed]'
   end

   if status_long == 'Walkover' && status_short == 'WO'
      return '[w/o]'    ##  use [w/o] for now, NOT [walkover]  - why? why not?
      ## note -  walkover has no winner or such
      ##           not possible what team didn't show up
   end


   assert status_long == 'Match Finished', "match status finished expected; got #{status_long}"
   assert [90,120].include?( status_elapsed ), "match elapsed 90|120 expected; got #{status_elapsed}"

   ## double check if PEN possible with elapsed 90 minutes !!!
   ##    is wrong upstream (always 120 even if no extra time)???
   assert ['PEN', 'AET', 'FT'].include?( status_short ), "match status PEN|AET|FT expected; got #{status_short}" 

=begin
"score"=>
     {"halftime"=>{"home"=>0, "away"=>0},
      "fulltime"=>{"home"=>1, "away"=>0},
      "extratime"=>{"home"=>nil, "away"=>nil},
      "penalty"=>{"home"=>nil, "away"=>nil}}}]}
=end
 
     ht = [score['halftime']['home'],
           score['halftime']['away']
          ]
     ft = [score['fulltime']['home'],
           score['fulltime']['away']
          ]
     et = [score['extratime']['home'],
           score['extratime']['away']
          ]
     pen = [score['penalty']['home'],
            score['penalty']['away']
           ]


##
##  pass in status and check elapsed e.g. 90 or 120???
##
##  todo/fix - use match status for score format - why? why not?

##
##  note - for austrian cup the penalties are missing
##            many score are aet with a draw, for example
##              nothing we can do here (if the data is wrong upstream)

     if pen[0] && pen[1]
         buf = "#{pen[0]}-#{pen[1]} pen "

         ###  note - really NOT working;  et[0] && et[1] is 0-0 
         ##                                cannot tell if extra time used or not
         ##                                 status also has always elapsed 120 mins!!
         ##                                     not 90!!!
         ##                                 example is copa america and others!!
         if et[0] && et[1]
           buf << "(#{et[0]+ft[0]}-#{et[1]+ft[1]}, #{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         else  ## no extra time
           buf << "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         end
         buf
     elsif et[0] && et[1]
         ## quick fix 
         if et[0] == 0 && et[1] == 0 &&
            ht[0] == 0 && ht[1] == 0
             ## todo/fix - use goal[0] && goal[1]
               "#{ft[0]}-#{ft[1]} aet"       ## assume ft score is really aet score
         else
               "#{et[0]+ft[0]}-#{et[1]+ft[1]} aet " +
               "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         end
     elsif ft[0] && ft[1] && !ht[0] && !ht[1]   ## no halftime score available/present 
          "#{ft[0]}-#{ft[1]}"
     else   ## assume fulltime & halftime
         "#{ft[0]}-#{ft[1]} (#{ht[0]}-#{ht[1]})"
     end 
end




def self.norm_name( str )
  ##  note - fixed with GEO_TEXT_RE
  ##
  ##    handle  v (vs.) in name e.g.
  ##       Stadion v Městských sadech  
  #
  #     handle  time like numbers e.g. 106.9 
  #    Cheshire Silk 106.9 Stadium   --  Silk 106.9 (is a radio station)
  #


   ###
   ##  Stade Communal de  Quevaucamps  =>  Stade Communal de Quevaucamps 
   ##  Sands  Stadium                  =>  Sands Stadium
   ##  Stade  Gierle F.C.              =>  Stade Gierle F.C.
   ##    fix - norm spaces to one
   str = str.gsub( /[ ]{2,}/, ' ' )


   ### how to deal with  
   ##    - Ashford Town (Middlesex)
   ##    - Westfield (Surrey)
   ##    - Bradford (Park Avenue)
   ##   quick fix for now remove () e.g.
   ##    =>  Ashford Town Middlesex
   ##    =>  Westfield Surrey
   str = str.gsub(  %r{\(
                         ([^)]+?)
                       \)
                    }x, '\1' )


  ## e.g. U.N.A.M. - Pumas   =>  U.N.A.M.-Pumas
  #          FavAC - Platz      =>    FavAC-Platz
  #      CITY ARENA – Štadión Antona Malatinského  =>  CITY ARENA–Štadión Antona Malatinského
  #
  #  Silz / Mötz                 =>  Silz/Mötz 
  #  Oberwart / Rotenturm        =>  Oberwart/Rotenturm
  #  Wallern / Marienkirchen
  #
  #  Oswestry / Croesoswallt, Shropshire   =>  Oswestry/Croesoswallt, Shropshire 

  ### change unicode dash (–)  to ascii dash (-) !!!
  ##   todo/fix - make gerneric for complete text!!!
  str = str.gsub( /[–]/, '-' )
  ##  K’s Denki Stadium › Mito
  str = str.gsub( /[’]/, "'" )

  ## data fix  remove colon in name with space e.g.
  ##   Pro:Direct Stadium
  ##   or use  Pro_Direct Stadium ??
  str = str.gsub( ':', ' ')

  #######
  ## use / ([/-]) /, '\1'   -- why? why not?
  str = str.gsub( / - /, '-' )
  str = str.gsub( / \/ /, '/' )
  str
end




def self._build_fixtures( fixtures, 
                          sort: true, 
                          teams: nil )



    ####
    #   auto-add (fifa) country code if int'l club tournament
    if teams  
      clubs_intl = true

     ## collect all teams
     teams_by_id = {}
     teams['response'].each do |rec|
     
       team_id      = rec['team']['id']
       ## team_name    = norm_name( rec['team']['name'] ) 
       team_country = rec['team']['country']
    
       cty = Fifa.world.find_by_name( team_country )
       if cty.nil?
         pp rec['team']
         puts "!! ERROR - no country found for >#{team_country}<"
         exit 1
       end
    
       teams_by_id[ team_id ] = cty.code
     end
   end



  buf = String.new

## assert fixture status
##      plus league and year always same etc.


  res = fixtures['response']

  

####  
### sort by timestamp
##   first sort by timestamp
###   if same timestamp
###      sort round my insertion order
  if sort
                
    ## get insert order of rounds
    rounds =  Hash.new(0)
    res.each do |rec|
       ## note - ignore if status is CANC (Cancelled)
       ##          cancelled match are not sorted and "out-of-order"
       ##               messing up insertion order
       if rec['fixture']['status']['short'].upcase == 'CANC'
          ## do nothing; skip
       else
          rounds[ rec['league']['round'] ] += 1   
      end
    end
    rounds_by_index = rounds.each_with_index.to_h { |(round, _), i| [round, i] }

    ## sort by insert order of round & if same timestamp
    res = res.sort do |l,r|
                ## 1) sort by date only (first - no time)
                l_local = l['fixture']['local']
                r_local = r['fixture']['local']
                l_date =  "%d-%02d-%02d" % [l_local.year, l_local.month, l_local.day]
                r_date =  "%d-%02d-%02d" % [r_local.year, r_local.month, r_local.day]
                cmp = l_date <=> r_date
                if cmp == 0 
                     l_round_index = rounds_by_index[l['league']['round']]
                     r_round_index = rounds_by_index[r['league']['round']] 
                     cmp =  l_round_index <=> r_round_index
                end 
                ## sort by local date&time (incl. hour/min/etc.)
                cmp =  l_local <=> r_local  if cmp == 0
                cmp
             end  
  end



  puts "  #{res.size} record(s)"


  last_round = nil
  last_date  = nil
  last_time  = nil
  last_year  = nil


  res.each do |rec|

      ## note - local date&time (as object of class Time required)
      ##           auto-add upstream!!!
      local = rec['fixture']['local']
      round  = rec['league']['round']

      if last_round != round
        puts "» #{round}"
        buf << "» #{round}\n"
        ## note - reset last_date & last_time 
        ##   will force printing of date & time
        last_date = nil
        last_time = nil
      end


      if last_year != local.year   ## note - add year to date first time 
        date_local = local.strftime('%a %b %-d %Y')
        time_local = local.strftime('%H.%M')     
        puts "  #{date_local}"
        buf << "  #{date_local}\n"   ## note - start newline for new date
        buf << "    #{time_local}"       
      else
        date_local = local.strftime('%a %b %-d')
        time_local = local.strftime('%H.%M')
    
        if date_local != last_date
          puts "  #{date_local}"
          buf << "  #{date_local}\n"   ## note - start newline for new date
          buf << "    #{time_local}"
        elsif date_local == last_date && time_local != last_time 
           buf << "    #{time_local}"
        else  ## assume same date & time
           buf << "         "
        end
      end

      last_date = date_local
      last_time = time_local
      last_year = local.year


      team1_name =  norm_name( rec['teams']['home']['name'] )
      team2_name =  norm_name( rec['teams']['away']['name'] )
      

      if clubs_intl   ## auto-add country code
          team1_id =  rec['teams']['home']['id'] 
          team2_id =  rec['teams']['away']['id'] 
         
          team1_cty = teams_by_id[ team1_id ]
          team2_cty = teams_by_id[ team2_id ]

         if team1_cty.nil? || team2_cty.nil?
           pp rec['teams']
           puts "!! error - no team mapping (with country) found"
           exit 1
         end
         
         team1_name = "#{team1_name} (#{team1_cty})"
         team2_name = "#{team2_name} (#{team2_cty})"
      end
      

      buf << "     #{team1_name} v #{team2_name}"
      
      score =  _build_score( score: rec['score'], 
                            status: rec['fixture']['status'] )
      buf << "  #{score}"


      if rec['fixture']['venue'] && rec['fixture']['venue']['name']
        ## note - venue_name/city MAY incl. comma!!

        venue_name = norm_name( rec['fixture']['venue']['name'] )
        venue_city = norm_name( rec['fixture']['venue']['city'] )

###
##   mods / data fixes:
##  Gem Sportcentrum Rooienberg Pitch 3 › 2570
        if venue_name == 'Gem Sportcentrum Rooienberg Pitch 3' &&
           venue_city == '2570'
           ## change to Duffel   - 2570 for now not valid geo name!!!
           venue_city = 'Duffel'
        end

        buf << "   @ #{venue_name} › #{venue_city}"
      else
        print " !!! no venue found"
      end
      
      buf << "\n"

      last_round = round
  end

  puts "  #{res.size} record(s)"
  buf   ## return buffer
end



def self.build_fixtures( league:, season: )

   fixtures = fixtures( league: league, season: season )
   ## pp fixtures

   zone = find_zone!( league: league, season: season )
 

   league_name    = fixtures['response'][0]['league']['name']
   league_country = fixtures['response'][0]['league']['country']
   league_season  = fixtures['response'][0]['league']['season']
   

  ### collect stats and do asserts and add (local timezone) date conversions
  stats = {  'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }



  fixtures['response'].each do |rec|
       assert  rec['league']['name'] == league_name,       "league name NOT matching"
       assert  rec['league']['country'] == league_country, "league country NOT matching"
       assert  rec['league']['season'] == league_season,   "league season NOT matching"

       timezone     = rec['fixture']['timezone']
       assert timezone == 'UTC', "timezone UTC expected; got #{timezone}"      

       date_str = rec['fixture']['date']   
       utc       = Time.parse_utc( date_str )

       ## timestamp = Time.at( rec['fixture']['timestamp'] )
       ##
       ## pp utc, timestamp, utc == timestamp
  
       ### change to local time
       local     = zone.to_local( utc )
       rec['fixture']['local'] = local   ## note: is ruby object (of Time class) NOT string!!!



       stats['date']['start_date'] ||= local
       stats['date']['end_date']   ||= local

       stats['date']['start_date'] = local  if local < stats['date']['start_date']
       stats['date']['end_date']   = local  if local > stats['date']['end_date']
      
       [rec['teams']['home']['name'],
        rec['teams']['away']['name']].each do |team|
         stats['teams'][ team ] += 1   
       end
  end


   buf = String.new 
   if league_country != 'World'
      buf << "= #{league_country} | #{league_name}"  
   else
      buf << "= #{league_name}"
   end
   buf << " #{season}\n\n"

  buf << "  # Date       "
  start_date = stats['date']['start_date']
  end_date   = stats['date']['end_date']
  if start_date.year != end_date.year
    buf << "#{start_date.strftime('%a %b/%-d %Y')} - #{end_date.strftime('%a %b/%-d %Y')}"
  else
    buf << "#{start_date.strftime('%a %b/%-d')} - #{end_date.strftime('%a %b/%-d %Y')}"
  end
  ## todo - use a different method for calc diff in days - why? why not?
  buf << " (#{end_date.to_datetime.jd-start_date.to_datetime.jd}d)"   ## add days
  buf << "\n"

   buf << "  # Teams      #{stats['teams'].size}\n"
   buf << "  # Matches    #{fixtures['response'].size}\n"
   buf << "\n"
   buf << "  # Note - All times in #{zone.name}\n\n"


   buf +=   if ['copa.l', 'copa.s',
                'uefa.cl', 'uefa.el', 'uefa.conf',
               ].include?( league ) 
               teams = teams( league: league, season: season )
               _build_fixtures( fixtures, 
                                teams: teams )
            else
              _build_fixtures( fixtures )
            end

   buf
end
end  # ApiFootball