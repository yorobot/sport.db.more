


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

    ## for champs default for not to cet (central european time) - why? why not?
    'uefa.cl'  => 'Europe/Paris',
    'euro'     => 'Europe/Paris',

    ## todo/fix - pt.1
    ##  one team in madeira!!! check for different timezone??
    ##  CD Nacional da Madeira

    'br.1'  => 'America/Sao_Paulo',
    ## todo/fix - brazil has 4 timezones
    ##           really only two in use for clubs
    ##             west and east (amazonas et al)
    ##           for now use west for all - why? why not?
    'copa.l'  => 'America/Sao_Paulo',
  }




def self.convert_score( score )
  ## duration: REGULAR  · PENALTY_SHOOTOUT  · EXTRA_TIME
  ft, ht, et, pen = ["","","",""]

  if score['duration'] == 'REGULAR'
    ft  = "#{score['fullTime']['home']}-#{score['fullTime']['away']}"
    ht  = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
  elsif score['duration'] == 'EXTRA_TIME'
    et  =  "#{score['regularTime']['home']+score['extraTime']['home']}"
    et << "-"
    et << "#{score['regularTime']['away']+score['extraTime']['away']}"

    ft =  "#{score['regularTime']['home']}-#{score['regularTime']['away']}"
    ht =  "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
  elsif score['duration'] == 'PENALTY_SHOOTOUT'
    if score['extraTime']
      ## quick & dirty hack - calc et via regulartime+extratime
      pen = "#{score['penalties']['home']}-#{score['penalties']['away']}"
      et  = "#{score['regularTime']['home']+score['extraTime']['home']}"
      et << "-"
      et << "#{score['regularTime']['away']+score['extraTime']['away']}"

      ft = "#{score['regularTime']['home']}-#{score['regularTime']['away']}"
      ht = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
    else  ### south american-style (no extra time)
        ## quick & dirty hacke - calc ft via fullTime-penalties
        pen =  "#{score['penalties']['home']}-#{score['penalties']['away']}"
        ft  =  "#{score['fullTime']['home']-score['penalties']['home']}"
        ft << "-"
        ft << "#{score['fullTime']['away']-score['penalties']['away']}"
        ht  = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
    end
  else
    puts "!! unknown score duration:"
    pp score
    exit 1
  end

  [ft,ht,et,pen]
end


#######
##  map round-like to higher-level stages
STAGES = {
  'REGULAR_SEASON'          => ['Regular'],

  'PRELIMINARY_ROUND'       => ['Qualifying', 'Preliminary Round' ],
  'PRELIMINARY_SEMI_FINALS' => ['Qualifying', 'Preliminary Semifinals' ],
  'PRELIMINARY_FINAL'       => ['Qualifying', 'Preliminary Final' ],
  '1ST_QUALIFYING_ROUND'    => ['Qualifying', 'Qual. Round 1' ],
  '2ND_QUALIFYING_ROUND'    => ['Qualifying', 'Qual. Round 2' ],
  '3RD_QUALIFYING_ROUND'    => ['Qualifying', 'Qual. Round 3' ],
  'QUALIFICATION_ROUND_1'   => ['Qualifying', 'Qual. Round 1' ],
  'QUALIFICATION_ROUND_2'   => ['Qualifying', 'Qual. Round 2' ],
  'QUALIFICATION_ROUND_3'   => ['Qualifying', 'Qual. Round 3' ],
  'ROUND_1'                 => ['Qualifying', 'Round 1'],    ##  use Qual. Round 1 - why? why not?
  'ROUND_2'                 => ['Qualifying', 'Round 2'],
  'ROUND_3'                 => ['Qualifying', 'Round 3'],
  'PLAY_OFF_ROUND'          => ['Qualifying', 'Playoff Round'],
  'PLAYOFF_ROUND_1'         => ['Qualifying', 'Playoff Round 1'],

  'LEAGUE_STAGE'            => ['League'],
  'GROUP_STAGE'             => ['Group'],
  'PLAYOFFS'                => ['Playoffs'],

  'ROUND_OF_16'             => ['Finals',     'Round of 16'],
  'LAST_16'                 => ['Finals',     'Round of 16'],  ## use Last 16 - why? why not?
  'QUARTER_FINALS'          => ['Finals',     'Quarterfinals'],
  'SEMI_FINALS'             => ['Finals',     'Semifinals'],
  'FINAL'                   => ['Finals',     'Final'],
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

  ## pp teams_by_name.keys



mods = MODS[ league.downcase ] || {}


recs = []

teams = Hash.new( 0 )


# stat  =  Stat.new

  ## track stage, match status et
  stats = { 'status'    => Hash.new(0),
            'stage'     => Hash.new(0),
           }




matches = data[ 'matches']
matches.each do |m|
  # stat.update( m )

  ## use ? or N.N. or ? for nil  - why? why not?
  team1 = m['homeTeam']['name'] || 'N.N.'
  team2 = m['awayTeam']['name'] || 'N.N.'

  score = m['score']


  stage_key = m['stage']

  stats['stage'][ stage_key ] += 1   ## track stage counts

  ## map stage to stage + round
  stage, stage_round  =  STAGES[ stage_key ]

  if stage.nil?
      puts "!! ERROR - no stage mapping found for stage >#{stage_key}<"
      exit 1
  end

  matchday_num = m['matchday']
  matchday_num = nil   if matchday_num == 0   ## change 0 to nil (empty) too

  if stage_round.nil?  ## e.g. Regular, League, Group, Playoffs
     ## keep/assume matchday number is matchday .e.g
     ##   matchday 1, 2 etc.
     matchday = matchday_num.to_s
  else
    ## note - if matchday defined; assume leg e.g. 1|2
    ##     skip if different than one or two for now
    matchday = String.new
    matchday << stage_round
    matchday << " | Leg #{matchday_num}"  if matchday_num &&
                                         (matchday_num == 1 || matchday_num == 2)
  end



  group = m['group'] || ''
  ## GROUP_A
  ##  shorten group to A|B|C etc.
  group = group.sub( /^GROUP_/, '' )



    teams[ team1 ] += 1
    teams[ team2 ] += 1

    ### mods - rename club names
    unless mods.nil? || mods.empty?
      team1 = mods[ team1 ]      if mods[ team1 ]
      team2 = mods[ team2 ]      if mods[ team2 ]
    end


   ## auto-fix copa.l 2024
   ##  !! ERROR: unsupported match status >IN_PLAY< - sorry:
   if m['status'] == 'IN_PLAY' &&
      team1 == 'Club Aurora' && team2 == 'FBC Melgar'
        m['status'] = 'FINISHED'
   end


    comments = ''
    ft       = ''
    ht       = ''
    et       = ''
    pen      = ''

    stats['status'][m['status']]  += 1  ## track status counts

    case m['status']
    when 'SCHEDULED', 'TIMED'   ## , 'IN_PLAY'
      ft = ''
      ht = ''
    when 'FINISHED'
      ft, ht, et, pen = convert_score( score )
    when 'AWARDED'
      assert( score['duration'] == 'REGULAR', 'score.duration REGULAR expected' )
      ft = "#{score['fullTime']['home']}-#{score['fullTime']['away']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'CANCELLED'
      ## note cancelled might have scores!! -- add/fix later!!!
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
    recs << [stage,
             group,
             matchday,
             local.strftime( '%Y-%m-%d' ),
             ['SCHEDULED','POSTPONED'].include?( m['status'] ) ? '' : local.strftime( '%H:%M' ),
             local.strftime( '%Z / UTC%z' ),
             team1,
             ft,
             ht,
             team2,
             et,
             pen,
             comments,
             ## add more columns e.g. utc date, status
             m['status'],  # e.g. FINISHED, TIMED, etc.
             m['utcDate'],
            ]
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
buf << "#{teams.keys.size} teams, "
buf << "#{recs.size} matches"
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
     f.write "  #{stats.inspect}\n"
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
           rec[3] = Date.strptime( rec[3], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )
           rec
       end

## pp recs

## check if all status colums
###  are FINISHED
###   if yes, set all to empty (for vacuum)

if stats['status'].keys.size == 1 && stats['status'].keys[0] == 'FINISHED'
  recs = recs.map { |rec| rec[-2] = ''; rec }
end

if stats['stage'].keys.size == 1 && stats['stage'].keys[0] == 'REGULAR_SEASON'
  recs = recs.map { |rec| rec[0] = ''; rec }
end


recs, headers = vacuum( recs )




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
    if name == 'N.N.'
      ## ignore missing record
    else
      puts "!! ERROR  - no team record found in teams.json for #{name}"
      exit 1
    end
  end
  print "\n"
end

## pp stat
end   # method convert



MAX_HEADERS = [
  'Stage',    # 0
  'Group',    # 1
  'Matchday', # 2
  'Date',     # 3
  'Time',     # 4
  'Timezone',   # 5 ## move back column - why? why not?
  'Team 1',     # 6
  'FT',         # 7
  'HT',         # 8
  'Team 2',     # 9
  'ET',         # 10     # extra: incl. extra time
  'P',          # 11     # extra: incl. penalties
  'Comments',   # 12
  'Status',     # 13 / -2  # e.g.
  'UTC',        # 14 / -1 # date utc
]

MIN_HEADERS = [   ## always keep even if all empty
'Date',
'Team 1',
'FT',
'Team 2'
]



def self.vacuum( rows, headers: MAX_HEADERS, fixed_headers: MIN_HEADERS )
  ## check for unused columns and strip/remove
  counter = Array.new( MAX_HEADERS.size, 0 )
  rows.each do |row|
     row.each_with_index do |col, idx|
       counter[idx] += 1  unless col.nil? || col.empty?
     end
  end

  ## pp counter

  ## check empty columns
  headers       = []
  indices       = []
  empty_headers = []
  empty_indices = []

  counter.each_with_index do |num, idx|
     header = MAX_HEADERS[ idx ]
     if num > 0 || (num == 0 && fixed_headers.include?( header ))
       headers << header
       indices << idx
     else
       empty_headers << header
       empty_indices << idx
     end
  end

  if empty_indices.size > 0
    rows = rows.map do |row|
             row_vacuumed = []
             row.each_with_index do |col, idx|
               ## todo/fix: use values or such??
               row_vacuumed << col   unless empty_indices.include?( idx )
             end
             row_vacuumed
         end
    end

  [rows, headers]
end
end #  module Footballdata


