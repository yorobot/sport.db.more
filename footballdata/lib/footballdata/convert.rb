
module Footballdata

#######
##  map round-like to higher-level stages
##      fix - map by league codes
##              or * (all)
STAGES = {
  'REGULAR_SEASON'          => ['Regular'],

  'QUALIFICATION'           => ['Qualifying'],
  'PRELIMINARY_ROUND'       => ['Qualifying', 'Preliminary Round' ],
  'PRELIMINARY_SEMI_FINALS' => ['Qualifying', 'Preliminary Semifinals' ],
  'PRELIMINARY_FINAL'       => ['Qualifying', 'Preliminary Final' ],
  '1ST_QUALIFYING_ROUND'    => ['Qualifying', 'Round 1' ],
  '2ND_QUALIFYING_ROUND'    => ['Qualifying', 'Round 2' ],
  '3RD_QUALIFYING_ROUND'    => ['Qualifying', 'Round 3' ],
  'QUALIFICATION_ROUND_1'   => ['Qualifying', 'Round 1' ],
  'QUALIFICATION_ROUND_2'   => ['Qualifying', 'Round 2' ],
  'QUALIFICATION_ROUND_3'   => ['Qualifying', 'Round 3' ],
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
  'THIRD_PLACE'             => ['Finals',     'Third place play-off'],
  'FINAL'                   => ['Finals',     'Final'],
}





def self.find_team_country_code( name, teams: )
  ## add (fifa) country code e.g.
  ##      Liverpool FC => Liverpool FC (ENG)
  ##  or  Liverpool FC => Liverpool FC (URU)
  rec = teams[ name ]
  if rec.nil?
    puts "!! ERROR - no team record found in teams.json for #{name}"
    pp teams.keys
    exit 1
  end

  country_name = rec['area']['name']
  country  = Fifa.world.find_by_name( country_name )
  if country.nil?
    puts "!! ERROR - no country record found for #{country_name}"
    exit 1
  end

  country.code
end



def self.convert( league:, season: )

  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  ### note - find_league returns the metal_league_code 
  league_code = find_league!( league )

  matches_url = Metal.competition_matches_url( league_code, season.start_year )
  teams_url   = Metal.competition_teams_url(   league_code, season.start_year )

  data           = Webcache.read_json( matches_url )
  data_teams     = Webcache.read_json( teams_url )


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

   ## auto-fix copa.l 2024
   ##  !! ERROR: unsupported match status >IN_PLAY< - sorry:
   if m['status'] == 'IN_PLAY' &&
      team1 == 'Club Aurora' && team2 == 'FBC Melgar'
        m['status'] = 'FINISHED'
   end



  score = m['score']

  group = m['group']
  ## GROUP_A
  ##  shorten group to A|B|C etc.
  if group && group =~ /^(GROUP_|Group )/
        group =  group.sub( /^(GROUP_|Group )/, '' )
  else
      if group.nil?
          group = ''
      else
          puts "!! WARN - group defined with NON GROUP!? >#{group}< reset to empty"
          puts "            and matchday to >#{m['matchday']}<"
          ## reset group to empty
          group = ''
      end
  end


  stage_key = m['stage']
  stats['stage'][ stage_key ] += 1   ## track stage counts


  stage, stage_round =  if group.empty?
                          ## map stage to stage + round
                          STAGES[ stage_key ]
                        else
                          ## if group defined ignore stage
                          ##   hard-core always to group for now
                           if stage_key != 'GROUP_STAGE'
                              puts "!! WARN - group defined BUT stage set to >#{stage_key}<"
                              puts "            and matchday to >#{m['matchday']}<"
                           end
                          ['Group', nil]
                        end

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
    ## note - if matchday/round defined, use it
    ##        note - ignore possible leg in matchday for now
    matchday =  stage_round
  end


  teams[ team1 ] += 1
  teams[ team2 ] += 1


    ### mods - rename club names
    unless mods.nil? || mods.empty?
      team1 = mods[ team1 ]      if mods[ team1 ]
      team2 = mods[ team2 ]      if mods[ team2 ]
    end

  ####
  #   auto-add (fifa) country code if int'l club tournament
  if clubs_intl
    ## note - use "original" name (not moded) for lookup
    team1_org = m['homeTeam']['name']
    team2_org = m['awayTeam']['name']
    if team1_org   ## note - ignore no team/placeholder (e.g. N.N)
      country_code = find_team_country_code( team1_org, teams: teams_by_name )
      team1 = "#{team1} (#{country_code})"
    end
    if team2_org   ## note - ignore no team/placeholder (e.g. N.N)
      country_code = find_team_country_code( team2_org, teams: teams_by_name )
      team2 = "#{team2} (#{country_code})"
    end
  end



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
      puts "!! ERROR: unsupported match status >#{m['status']}< - sorry:"
      pp m
      exit 1
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
             matchday,
             date,
             time,
             timezone,
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


