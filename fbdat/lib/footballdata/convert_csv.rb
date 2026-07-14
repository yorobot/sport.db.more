
module Footballdata


####
## beautify stages constant names
STAGES = {
  'REGULAR_SEASON'          => 'Regular Season',

  'QUALIFICATION'           => 'Qualification',
  'PRELIMINARY_ROUND'       => 'Preliminary Round',
  'PRELIMINARY_SEMI_FINALS' => 'Preliminary Semifinals',
  'PRELIMINARY_FINAL'       => 'Preliminary Final',
  '1ST_QUALIFYING_ROUND'    => '1st Qualifying Round',
  '2ND_QUALIFYING_ROUND'    => '2nd Qualifying Round',
  '3RD_QUALIFYING_ROUND'    => '3rd Qualifying Round',
  'QUALIFICATION_ROUND_1'   => 'Qualification Round 1',
  'QUALIFICATION_ROUND_2'   => 'Qualification Round 2',
  'QUALIFICATION_ROUND_3'   => 'Qualification Round 3',
  'ROUND_1'                 => 'Round 1',
  'ROUND_2'                 => 'Round 2',
  'ROUND_3'                 => 'Round 3',
  'PLAY_OFF_ROUND'          => 'Playoff Round',
  'PLAYOFF_ROUND_1'         => 'Playoff Round 1',

  'LEAGUE_STAGE'            => 'League',      ## add Stage - why? why not?
  'GROUP_STAGE'             => 'Group',
  'PLAYOFFS'                => 'Playoffs',     ## -- used in champs
  'PLAY_OFFS'               => 'Playoffs',     ## -- used in copa liber.

  'LAST_32'                 => 'Round of 32',
  'ROUND_OF_16'             => 'Round of 16',
  'LAST_16'                 => 'Round of 16',  ## use Last 16 - why? why not?
  'QUARTER_FINALS'          => 'Quarterfinals',
  'SEMI_FINALS'             => 'Semifinals',
  'THIRD_PLACE'             => 'Third place',
  'FINAL'                   => 'Final',
}



def self.convert_csv( league:, season: )

  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  ### note - find_league returns the metal_league_code
  ##            e.g.  eng.1 =>  PL
  league_code = find_league!( league )

  matches_url = Metal.competition_matches_url( league_code, season.start_year )
  teams_url   = Metal.competition_teams_url(   league_code, season.start_year )

  data           = Webcache.read_json( matches_url )
  data_teams     = Webcache.read_json( teams_url )


  ## build a team lookup by name (& short_name)

  teams = Teams.new
  teams.add( data_teams['teams'] )
  puts "#{teams.size} team(s)"

  ## add/update match counts
  teams.add_matches( data['matches'] )



  ###
  ## todo/fix - use find_by!  - add upstream!!!
  league_info = LeagueCodes.find_by( code: league, season: season )
  ## check for time zone
  tz  = league_info['tz']
  pp tz

  ## note - for international club tournaments
  ##         auto-add (fifa) country code e.g.
  ##      Liverpool FC  => Liverpool FC (ENG)
  ##
  ##  todo/fix -  move flag to league_info via .csv config - why? why not?
  clubs_intl  =  ['uefa.cl',
                  'copa.l'].include?(league.downcase) ? true : false


  mods = MODS[ league.downcase ] || {}



  recs = []

  # stat  =  Stat.new
  ## track stage, match status et
  stats = { 'status'    => Hash.new(0),
            'stage'     => Hash.new(0),
           }


matches = data[ 'matches']
matches.each do |m|
  # stat.update( m )

  # use ? or N.N. or ? for nil  - why? why not?
  team1_name = m['homeTeam']['name']
  team2_name = m['awayTeam']['name']

  team1 = team1_name ? teams.find_by!(name: team1_name ) : { name: 'N.N.' }
  team2 = team2_name ? teams.find_by!(name: team2_name ) : { name: 'N.N.' }


  ## use "normed" team names
  team1_name = team1[:name]
  team2_name = team2[:name]

  ### mods - rename club names
  unless mods.nil? || mods.empty?
      team1_name = mods[ team1_name ]      if mods[ team1_name ]
      team2_name = mods[ team2_name ]      if mods[ team2_name ]
  end

  ####
  #   auto-add (fifa) country code if int'l club tournament
  if clubs_intl
    if team1_name != 'N.N.'  ## note - ignore no team/placeholder (e.g. N.N)
      team1_name = "#{team1_name} (#{team1[:country][:code]})"
    end
    if team2_name != 'N.N.'  ## note - ignore no team/placeholder (e.g. N.N)
      team2_name = "#{team2_name} (#{team2[:country][:code]})"
    end
  end





  group     = m['group']
  stage_key = m['stage']
  stats['stage'][ stage_key ] += 1   ## track stage counts
  ## add group stats?


  ## GROUP_A
  ##  shorten group to A|B|C etc.
  if group
    ## assert group only used with GROUP_STAGE
   if stage_key != 'GROUP_STAGE'
      raise ArgumentError,
      "group defined BUT stage set to >#{stage_key}< (expected GROUP_STAGE)" +
      "and matchday to >#{m['matchday']}<"
    end

    if group =~ /^(GROUP_|Group )/
         group =  group.sub( /^(GROUP_|Group )/, '' )
     else
          raise ArgumentError,
             "group defined with NON GROUP!? >#{group}< reset to empty"+
             "            and matchday to >#{m['matchday']}<"
     end
  else  ## assume group.nil?
      group = ''
  end



  ## map stage to stage + round
  ##   note - if no mapping defined; use (fallback to) upcase version
  stage = STAGES[ stage_key ]

  if stage.nil?
      puts "!! WARN - no stage mapping found for stage >#{stage_key}<"
      stage = stage_key
  end



  matchday = m['matchday']
  matchday = nil     if matchday == 0   ## change 0 to nil (empty) too



    score = m['score']


    comments = ''
    ft       = ''
    ht       = ''
    et       = ''
    pen      = ''

    stats['status'][m['status']]  += 1  ## track status counts

    case m['status']
    when 'SCHEDULED', 'TIMED',
         'PAUSED', 'IN_PLAY'   ## IN_PLAY, PAUSED
      ft = ''
      ht = ''
    when 'FINISHED'
      ft, ht, et, pen = convert_score( score )
    when 'AWARDED'   # AWARDED
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
      raise ArgumentError,
        "unsupported match status >#{m['status']}< - sorry:"
    end



    utc = UTC.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
    assert( utc.strftime( '%Y-%m-%dT%H:%M:%SZ' ) == m['utcDate'], 'utc time mismatch' )


    ## do NOT add time if status is SCHEDULED
    ##                        or POSTPONED for now
    ##   otherwise assume time always present - why? why not?
    ##
    ## assume NOT valid utc time if 00:00
    if utc.hour == 0 && utc.min == 0 &&
       ['SCHEDULED','POSTPONED'].include?( m['status'] )
       date     = utc.strftime( '%Y-%m-%d' )
       time     = ''
       timezone = ''
    else
      local    = tz.to_local( utc )
      date     = local.strftime( '%Y-%m-%d' )
      time     = local.strftime( '%H:%M' )

      ## pretty print timezone
      ###   todo/fix - bundle into fmt_timezone method or such for reuse
      tz_abbr   =  local.strftime( '%Z' )   ## e.g. EEST or if not available +03 or such
      tz_offset =  local.strftime( '%z' )   ##  e.g. +0300

      timezone =  if tz_abbr =~ /^[+-][0-9]+$/   ## only digits (no abbrev.)
                     tz_offset
                  else
                      "#{tz_abbr}/#{tz_offset}"
                  end
    end


    recs << [stage,
             group,
             matchday.to_s,  ## not convert nil or Integer to str e.g. "", "1"
             date,
             time,
             timezone,
             team1_name,
             ft,
             ht,
             team2_name,
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
buf << "#{teams.size} teams, "
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


teams.each do |rec|
  print "  #{rec[:count]}x  "
  print rec[:name]
  print " | #{rec[:short_name]} "   if rec[:name] != rec[:short_name]
  print " › #{rec[:country][:name]} (#{rec[:country][:code]})"
  print "  - #{rec[:address]}"
  print "\n"
end

## pp stat
end   # method convert_csv



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



###
###  move upstream to cocos!! (re)use vacuum_csv !!!!

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
