##########
##  todo/fix:
##    use a more generic name?
##      might also works for euro or worldcup - check?


module Footballdata


STAGE_TO_STAGE = {
  'PRELIMINARY_SEMI_FINALS' => 'Qualifying',
  'PRELIMINARY_FINAL'       => 'Qualifying',
  '1ST_QUALIFYING_ROUND'    => 'Qualifying',
  '2ND_QUALIFYING_ROUND'    => 'Qualifying',
  '3RD_QUALIFYING_ROUND'    => 'Qualifying',
  'PLAY_OFF_ROUND'          => 'Qualifying',
  'ROUND_OF_16'             => 'Knockout',
  'QUARTER_FINALS'          => 'Knockout',
  'SEMI_FINALS'             => 'Knockout',
  'FINAL'                   => 'Knockout',
}

STAGE_TO_ROUND = {
  'PRELIMINARY_SEMI_FINALS' => 'Preliminary Semifinals',
  'PRELIMINARY_FINAL'       => 'Preliminary Final',
  '1ST_QUALIFYING_ROUND'    => 'Qual. Round 1',
  '2ND_QUALIFYING_ROUND'    => 'Qual. Round 2',
  '3RD_QUALIFYING_ROUND'    => 'Qual. Round 3',
  'PLAY_OFF_ROUND'          => 'Playoff Round',
  'ROUND_OF_16'             => 'Round of 16',
  'QUARTER_FINALS'          => 'Quarterfinals',
  'SEMI_FINALS'             => 'Semifinals',
  'FINAL'                   => 'Final',
}




def self.convert_cl( league:, season: )
  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  data           = Webcache.read_json( Metal.competition_matches_url( LEAGUES[league.downcase], season.start_year ))
  data_teams     = Webcache.read_json( Metal.competition_teams_url(   LEAGUES[league.downcase], season.start_year ))


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
stat = Stat.new

matches = data[ 'matches' ]
matches.each do |m|
  stat.update( m )

  team1 = m['homeTeam']['name']
  team2 = m['awayTeam']['name']


  score = m['score']



  if m['stage'] == 'GROUP_STAGE'
    stage = 'Group'
    round = "Matchday #{m['matchday']}"
    if m['group'] =~ /Group ([A-Z])/
      group = $1
    else
      puts "!! ERROR - no group name found for group >#{m['group']}<"
      exit 1
    end
  else
    stage = STAGE_TO_STAGE[ m['stage'] ]
    if stage.nil?
      puts "!! ERROR - no stage mapping found for stage >#{m['stage']}<"
      exit 1
    end
    round = STAGE_TO_ROUND[ m['stage'] ]
    if round.nil?
      puts "!! ERROR - no round mapping found for stage >#{m['stage']}<"
      exit 1
    end
    group = ''
  end


    teams[ team1 ] += 1
    teams[ team2 ] += 1

    ### mods - rename club names
    unless mods.nil? || mods.empty?
      team1 = mods[ team1 ]      if mods[ team1 ]
      team2 = mods[ team2 ]      if mods[ team2 ]
    end


    ## e.g. "utcDate": "2020-05-09T00:00:00Z",
    date_str = m['utcDate']
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%SZ' )


    comments = ''
    ft       = ''
    ht       = ''
    et       = ''
    pen      = ''

    case m['status']
    when 'SCHEDULED', 'IN_PLAY'
      ft  = ''
      ht  = ''
      et  = ''
      pen = ''
    when 'AWARDED'
      ## todo/fix: assert duration == "REGULAR"
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'FINISHED'
      ## note: if extraTime present
      ## than fullTime is extraTime score!!
      ##   AND   fullTime - extraTime is fullTime score!!
      ## double check in other season too??
      ##   - checked in cl 2018/19

      if score['extraTime']['homeTeam'] && score['extraTime']['awayTeam']
        et = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
        ft = "#{score['fullTime']['homeTeam']-score['extraTime']['homeTeam']}-#{score['fullTime']['awayTeam']-score['extraTime']['awayTeam']}"
      else
        ft  = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      end

      ht  = "#{score['halfTime']['homeTeam']}-#{score['halfTime']['awayTeam']}"

      pen = if score['penalties']['homeTeam'] && score['penalties']['awayTeam']
              "#{score['penalties']['homeTeam']}-#{score['penalties']['awayTeam']}"
            else
              ''
            end
    else
      puts "!! ERROR: unsupported match status >#{m['status']}< - sorry:"
      pp m
      exit 1
    end


    recs << [stage,
             round,
             group,
             date.to_date.strftime( '%Y-%m-%d' ),
             team1,
             ft,
             ht,
             team2,
             et,
             pen,
             comments
            ]


    print '%2s' % m['matchday']
    print ' - '
    print '%-24s' % team1
    print '  '
    print ft
    print ' '
    print "(#{ht})"    unless ht.empty?
    print '  '
    print '%-24s' % team2
    print '  '
    print comments
    print ' | '
    ## print date.to_date  ## strip time
    print date.to_date.strftime( '%a %b %-d %Y' )
    print ' -- '
    print date
    print "\n"

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
buf << "#{stat[:all][:matches]} matches, "
buf << "#{stat[:all][:goals]} goals"
buf << "\n"

puts buf



# recs = recs.sort { |l,r| l[1] <=> r[1] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[3] = Date.strptime( rec[3], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

headers = [
  'Stage',
  'Round',
  'Group',
  'Date',
  'Team 1',
  'FT',
  'HT',
  'Team 2',
  'ET',
  'P',
  'Comments'
]

## note: change season_key from 2019/20 to 2019-20  (for path/directory!!!!)
Cache::CsvMatchWriter.write( "#{config.convert.out_dir}/#{season.to_path}/#{league.downcase}.csv",
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
    print "!! ERROR - no team record found in teams.json for #{name}"
    exit 1
  end
  print "\n"
end

pp stat
end   # method convert_cl
end #  module Footballdata


