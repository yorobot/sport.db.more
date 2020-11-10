

module Footballdata


def self.convert( league:, season: )

  ### note/fix: cl (champions league for now is a "special" case)
  if league.downcase == 'cl'
    convert_cl( league: league,
                season: season )
    return
  end



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

stat  =  Stat.new

matches = data[ 'matches']
matches.each do |m|
  stat.update( m )

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


    ## e.g. "utcDate": "2020-05-09T00:00:00Z",
    date_str = m['utcDate']
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%SZ' )


    comments = ''
    ft       = ''
    ht       = ''

    case m['status']
    when 'SCHEDULED', 'IN_PLAY'
      ft = ''
      ht = ''
    when 'FINISHED'
      ## todo/fix: assert duration == "REGULAR"
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ht = "#{score['halfTime']['homeTeam']}-#{score['halfTime']['awayTeam']}"
    when 'AWARDED'
      ## todo/fix: assert duration == "REGULAR"
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'CANCELLED'
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


    ## todo/fix: assert matchday is a number e.g. 1,2,3, etc.!!!
    recs << [m['matchday'],
             date.to_date.strftime( '%Y-%m-%d' ),
             team1,
             ft,
             ht,
             team2,
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
  else
    puts "-- skipping #{m['stage']}"
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
buf << "#{stat[:regular_season][:matches]} matches, "
buf << "#{stat[:regular_season][:goals]} goals"
buf << "\n"

puts buf



   ## note: warn if stage is greater one and not regular season!!
   File.open( './errors.txt' , 'a:utf-8' ) do |f|
     if stat[:all][:stage].keys != ['REGULAR_SEASON']
      f.write "!! WARN - league: #{league}, season: #{season.key} includes non-regular stage(s):\n"
      f.write "   #{stat[:all][:stage].keys.inspect}\n"
     end
   end


   File.open( './logs.txt', 'a:utf-8' ) do |f|
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




# recs = recs.sort { |l,r| l[1] <=> r[1] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[1] = Date.strptime( rec[1], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

headers = [
  'Matchday',
  'Date',
  'Team 1',
  'FT',
  'HT',
  'Team 2',
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
    puts "!! ERROR  - no team record found in teams.json for #{name}"
    exit 1
  end
  print "\n"
end

pp stat
end   # method convert
end #  module Footballdata


