


module Footballdata


  TIMEZONES = {
    'eng.1' => 'Europe/London',  
    'eng.2' => 'Europe/London',
  
    'es.1'  => 'Europe/Madrid',
  
    'de.1'  => 'Europe/Berlin',
    'fr.1'  => 'Europe/Paris', 
    'it.1'  => 'Europe/Rome',
    'nl.1'  => 'Europe/Amsterdam',
  
    'pt.1'  => 'Europe/Lisbon',   

    ## todo/fix - pt.1
    ##  one team in madeira!!! check for different timezone??
    ##  CD Nacional da Madeira 

    'br.1'  => 'America/Sao_Paulo',
    ## todo/fix - brazil has 4 timezones
    ##           really only two in use for clubs
    ##             west and east (amazonas et al)
    ##           for now use west for all - why? why not?
  }


def self.convert( league:, season: )

  ### note/fix: cl (champions league for now is a "special" case)
  # if league.downcase == 'cl'
  #   convert_cl( league: league,
  #              season: season )
  #  return
  # end

  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  league_code = LEAGUES[league.downcase]

  matches_url = Metal.competition_matches_url( league_code, season.start_year )
  teams_url   = Metal.competition_teams_url(   league_code, season.start_year )

  data           = Webcache.read_json( matches_url )
  data_teams     = Webcache.read_json( teams_url )

  
  ## check for time zone
  tz_name = TIMEZONES[ league.downcase ]
  if tz_name.nil?
    puts "!! ERROR - sorry no timezone configured for league #{league}"
    exit 1
  end
  
  tz  = TZInfo::Timezone.get( tz_name )
  pp tz

  ## build a (reverse) team lookup by name
  puts "#{data_teams['teams'].size} teams"

  teams_by_name = data_teams['teams'].reduce( {} ) do |h,rec|
     h[ rec['name'] ] = rec
     h
  end

  pp teams_by_name.keys

  

mods = MODS[ league.downcase ] || {}


recs = []

teams = Hash.new( 0 )


# stat  =  Stat.new

#  track stati counts 
stati = Hash.new(0)


matches = data[ 'matches']
matches.each do |m|
  # stat.update( m )

  team1 = m['homeTeam']['name']
  team2 = m['awayTeam']['name']

  score = m['score']



  if m['stage'] == 'REGULAR_SEASON'
    teams[ team1 ] += 1
    teams[ team2 ] += 1

    ### mods - rename club names
    unless mods.nil? || mods.empty?
      team1 = mods[ team1 ]      if mods[ team1 ]
      team2 = mods[ team2 ]      if mods[ team2 ]
    end



    comments = ''
    ft       = ''
    ht       = ''

    stati[m['status']] += 1  ## track stati counts for logs

    case m['status']
    when 'SCHEDULED', 'TIMED'   ## , 'IN_PLAY'
      ft = ''
      ht = ''
    when 'FINISHED'
      ## todo/fix: assert duration == "REGULAR"
      assert( score['duration'] == 'REGULAR', 'score.duration REGULAR expected' ) 
      ft = "#{score['fullTime']['home']}-#{score['fullTime']['away']}"
      ht = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
    when 'AWARDED'
      ## todo/fix: assert duration == "REGULAR"
      assert( score['duration'] == 'REGULAR', 'score.duration REGULAR expected' ) 
      ft = "#{score['fullTime']['home']}-#{score['fullTime']['away']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'CANCELLED'
      ## note cancelled might have scores!!
      ##   ht only or ft+ht!!!  (see fr 2021/22)
      ft = '(*)'
      ht = ''
      comments  = 'canceled'   ## us eng ? -> canceled, british eng. cancelled ?
    when 'POSTPONED'
      ft = '(*)'
      ht = ''
      comments = 'postponed'
    else
      puts "!! ERROR: unsupported match status >#{m['status']}< - sorry:"
      pp m
      exit 1
    end


    ##
    ##  add time, timezone(tz)
    ##    2023-08-18T18:30:00Z
    ## e.g. "utcDate": "2020-05-09T00:00:00Z",
    ##      "utcDate": "2023-08-18T18:30:00Z",

    ## -- todo - make sure / assert it's always utc - how???
    ## utc   = ## tz_utc.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
    ##  note:  DateTime.strptime  is supposed to be unaware of timezones!!!
    ##            use to parse utc
    utc = DateTime.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' ).to_time.utc 
    assert( utc.strftime( '%Y-%m-%dT%H:%M:%SZ' ) == m['utcDate'], 'utc time mismatch' )
    
    local = tz.to_local( utc )
   

    ## do NOT add time if status is SCHEDULED
    ##                        or POSTPONED for now
    ##   otherwise assume time always present - why? why not?
  

    ## todo/fix: assert matchday is a number e.g. 1,2,3, etc.!!!
    recs << [m['matchday'].to_s,   ## note: convert integer to string!!!
             local.strftime( '%Y-%m-%d' ),
             ['SCHEDULED','POSTPONED'].include?( m['status'] ) ? '' : local.strftime( '%H:%M' ),
             local.strftime( '%Z / UTC%z' ), 
             team1,
             ft,
             ht,
             team2,
             comments,
             ## add more columns e.g. utc date, status
             m['status'],  # e.g. FINISHED, TIMED, etc.
             m['utcDate'],
            ]


    print '%2s' % m['matchday']
    print ' - '
    print '%-26s' % team1
    print '  '
    print ft
    print ' '
    print "(#{ht})"    unless ht.empty?
    print '  '
    print '%-26s' % team2
    print '  '
    print comments
    print ' | '
    ## print date.to_date  ## strip time
    print utc.strftime( '%a %b %-d %Y' )
    print ' -- '
    print utc
    print "\n"
  else
    puts "!!! unexpected stage:"
    puts "-- skipping #{m['stage']}"
    # exit 1
  end
end # each match



## note: get season from first match
##   assert - all other matches include the same season
## e.g.
# "season": {
#  "id": 154,
#  "startDate": "2018-08-03",
#  "endDate": "2019-05-05",
#  "currentMatchday": 46
# }

start_date = Date.strptime( matches[0]['season']['startDate'], '%Y-%m-%d' )
end_date   = Date.strptime( matches[0]['season']['endDate'],   '%Y-%m-%d' )

dates = "#{start_date.strftime('%b %-d')} - #{end_date.strftime('%b %-d')}"

buf = ''
buf << "#{season.key} (#{dates}) - "
buf << "#{teams.keys.size} clubs, "
# buf << "#{stat[:regular_season][:matches]} matches, "
# buf << "#{stat[:regular_season][:goals]} goals"
buf << "\n"

puts buf


=begin
   ## note: warn if stage is greater one and not regular season!!
   File.open( './errors.txt' , 'a:utf-8' ) do |f|
     if stat[:all][:stage].keys != ['REGULAR_SEASON']
      f.write "!! WARN - league: #{league}, season: #{season.key} includes non-regular stage(s):\n"
      f.write "   #{stat[:all][:stage].keys.inspect}\n"
     end
   end
=end


   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write "====  #{league} #{season.key}  =============\n"
     f.write "  match stati: #{stati.inspect}\n"
   end

=begin
    f.write "\n================================\n"
     f.write "====  #{league}  =============\n"
     f.write buf
     f.write "  match status: #{stat[:regular_season][:status].inspect}\n"
     f.write "  match duration: #{stat[:regular_season][:duration].inspect}\n"

     f.write "#{teams.keys.size} teams:\n"
     teams.each do |name, count|
        rec = teams_by_name[ name ]
        f.write "  #{count}x  #{name}"
        if rec
          f.write " | #{rec['shortName']} "   if name != rec['shortName']
          f.write " › #{rec['area']['name']}"
          f.write "  - #{rec['address']}"
        else
          puts "!! ERROR - no team record found in teams.json for >#{name}<"
          exit 1
        end
        f.write "\n"
     end
   end
=end


##
##  sort buy utc date ??? - why? why not?

# recs = recs.sort { |l,r| l[1] <=> r[1] }


## reformat date / beautify e.g. Sat Aug 7 1993
recs = recs.map do |rec| 
           rec[1] = Date.strptime( rec[1], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) 
           rec
       end


headers = [
  'Matchday',
  'Date',
  'Time',
  'Timezone',  ## move back column - why? why not?
  'Team 1',
  'FT',
  'HT',
  'Team 2',
  'Comments',
  ##
  'Status', # e.g. 
  'UTC',    # date utc
]

## note: change season_key from 2019/20 to 2019-20  (for path/directory!!!!)
  write_csv( "#{config.convert.out_dir}/#{season.to_path}/#{league.downcase}.csv",
                             recs,
                             headers: headers )


teams.each do |name, count|
  rec = teams_by_name[ name ]
  print "  #{count}x  "
  print name
  if rec
    print " | #{rec['shortName']} "   if name != rec['shortName']
    print " › #{rec['area']['name']}"
    print "  - #{rec['address']}"
  else
    puts "!! ERROR  - no team record found in teams.json for #{name}"
    exit 1
  end
  print "\n"
end

## pp stat
end   # method convert
end #  module Footballdata


