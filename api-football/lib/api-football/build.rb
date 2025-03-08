module ApiFootball
### add a nested namespace - why? why not?


def self.assert( cond, msg )
    if !cond 
       raise ArgumentError, "assert faild - #{msg}"
    end
end
  


def self._build_score( score:, status: )
   status_long  = status['long']   ##  Match Finished
   status_short = status['short'].upcase   ## make Canc into CANC
   status_elapsed = status['elapsed']  ## 90, 120
 

   if status_long == 'Match Cancelled' && status_short == 'CANC' 
      return '[cancelled]'  
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

     if pen[0] && pen[1]
         buf = "#{pen[0]}-#{pen[1]} pen "

         if et[0] && et[1]
           buf << "(#{et[0]+ft[0]}-#{et[1]+ft[1]}, #{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         else  ## no extra time
           buf << "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         end
         buf
     elsif et[0] && et[1]
         "#{et[0]+ft[0]}-#{et[1]+ft[1]} aet " +
         "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
     else 
         "#{ft[0]}-#{ft[1]} (#{ht[0]}-#{ht[1]})"
     end 
end


=begin
### parse time utc time
###     
"timezone": "UTC",
        "date": "2023-06-18T18:45:00+00:00",
        "timestamp": 1687113900,
=end



def self.norm_name( str )
  ## e.g. U.N.A.M. - Pumas   =>  U.N.A.M.-Pumas
  #          FavAC - Platz      =>    FavAC-Platz
  #
  #  Silz / Mötz                 =>  Silz/Mötz 
  #  Oberwart / Rotenturm        =>  Oberwart/Rotenturm
  #  Wallern / Marienkirchen

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
                ##     note - make sure timezone is UTC!!!
                l_utc = Time.at(l['fixture']['timestamp']).utc
                r_utc = Time.at(r['fixture']['timestamp']).utc
                l_date =  "%d-%02d-%02d" % [l_utc.year, l_utc.month, l_utc.day]
                r_date =  "%d-%02d-%02d" % [r_utc.year, r_utc.month, r_utc.day]
                cmp = l_date <=> r_date
                if cmp == 0 
                     l_round_index = rounds_by_index[l['league']['round']]
                     r_round_index = rounds_by_index[r['league']['round']] 
                     cmp =  l_round_index <=> r_round_index
                end 
                ## sort by timestamp (incl. hour/min/etc.)
                cmp =  l_utc <=> r_utc  if cmp == 0
                cmp
             end  
  end



  puts "  #{res.size} record(s)"


  last_round = nil
  last_date  = nil
  last_time  = nil
  last_year  = nil

## assert league_name, league_county and league_season  
=begin
"league"=>
     {"id"=>218,
      "name"=>"Bundesliga",
      "country"=>"Austria",
      "logo"=>"https://media.api-sports.io/football/leagues/218.png",
      "flag"=>"https://media.api-sports.io/flags/at.svg",
      "season"=>2023,
=end
   league_name    = res[0]['league']['name']
   league_country = res[0]['league']['country']
   league_season  = res[0]['league']['season']


  res.each do |rec|

     assert  rec['league']['name'] == league_name,       "league name NOT matching"
     assert  rec['league']['country'] == league_country, "league country NOT matching"
     assert  rec['league']['season'] == league_season,   "league season NOT matching"


### check dates
# "timezone": "UTC",
# "date": "2023-07-28T18:45:00+00:00",
# "timestamp": 1690569900,
 
      timezone     = rec['fixture']['timezone']
      assert timezone == 'UTC',                "timezone UTC expected; got #{timezone}"      

      date_str = rec['fixture']['date']

   
      utc       = Time.parse_utc( date_str )
      timestamp = Time.at( rec['fixture']['timestamp'] )
    
      ## pp utc, timestamp, utc == timestamp
      ##  note - utc datetime may move date to next day
      ##                e.g. if time is brazil or such!!!
      ##   later add a timezone option for changing timezone!!

      round      = rec['league']['round']

      if last_round != round
        puts "» #{round}"
        buf << "» #{round}\n"
        ## note - reset last_date & last_time 
        ##   will force printing of date & time
        last_date = nil
        last_time = nil
      end


      if last_year != utc.year   ## note - add year to date first time 
        date_utc = utc.strftime('%a %b %-d %Y')
        time_utc = utc.strftime('%H.%M')     
        puts "  #{date_utc}"
        buf << "  #{date_utc}\n"   ## note - start newline for new date
        buf << "    #{time_utc}"       
      else
        date_utc = utc.strftime('%a %b %-d')
        time_utc = utc.strftime('%H.%M')
    
        if date_utc != last_date
          puts "  #{date_utc}"
          buf << "  #{date_utc}\n"   ## note - start newline for new date
          buf << "    #{time_utc}"
        elsif date_utc == last_date && time_utc != last_time 
           buf << "    #{time_utc}"
        else  ## assume same date & time
           buf << "         "
        end
      end

      last_date = date_utc
      last_time = time_utc
      last_year = utc.year


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
        venue_city = rec['fixture']['venue']['city']
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


   league_name    = fixtures['response'][0]['league']['name']
   league_country = fixtures['response'][0]['league']['country']
   
   buf = String.new 
   if league_country != 'World'
      buf << "= #{league_country} | #{league_name}"  
   else
      buf << "= #{league_name}"
   end
   buf << " #{season}\n\n"


  ### collect stats
  stats = {  'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }

  fixtures['response'].each do |rec|
       date_str = rec['fixture']['date']   
       utc       = Time.parse_utc( date_str )


       stats['date']['start_date'] ||= utc
       stats['date']['end_date']   ||= utc

       stats['date']['start_date'] = utc  if utc < stats['date']['start_date']
       stats['date']['end_date']   = utc  if utc > stats['date']['end_date']
      
       [rec['teams']['home']['name'],
        rec['teams']['away']['name']].each do |team|
         stats['teams'][ team ] += 1   
       end
  end


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
   buf << "  # Note - All Times in UTC\n\n"


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