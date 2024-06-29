require_relative '../boot'



########
# helpers
#   normalize team names

NORM_MODS  = SportDb::Import.catalog.clubs.build_mods(
  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
    'Barcelona'                => 'FC Barcelona, ESP',
    'Valencia'                 => 'Valencia CF, ESP'  })

def normalize( matches )

  ## todo/fix: cache name lookups - why? why not?
  matches.each do |match|
     team1 = NORM_MODS[ match.team1 ] || SportDb::Import.catalog.clubs.find!( match.team1 )
     team2 = NORM_MODS[ match.team2 ] || SportDb::Import.catalog.clubs.find!( match.team2 )

     puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
     puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

     match.update( team1: team1.name )
     match.update( team2: team2.name )
  end
  matches
end






def format_score( match )
  buf = String.new('')

  if match.score1 && match.score2

    if match.score1p && match.score2p
      buf << "#{match.score1p}-#{match.score2p} pen. "
    end

    if match.score1et && match.score2et
      buf << "#{match.score1et}-#{match.score2et} a.e.t. "
    end

    if buf.empty?
      buf << "#{match.score1}-#{match.score2}"
    else  ## assume pen. and/or a.e.t.
      buf << "(#{match.score1}-#{match.score2})"
    end
  else # assume empty / unknown score
    buf << ' - '
  end

  buf
end


def build_stage( matches )
  ## sort matches by
  ##  1) date

  matches = matches.sort do |l,r|
    result = l.date  <=> r.date
    result
  end

  buf = String.new('')

  last_round = nil
  last_date  = nil

  matches.each do |match|
    if match.round != last_round
      buf << "\n"
      buf << match.round
      buf << "\n"
      last_date = nil
    end

    if match.date != last_date
      date = Date.strptime( match.date, '%Y-%m-%d' )
      buf << "[#{date.strftime('%a %b/%-d')}]"
      buf << "\n"
    end

    buf << "  "
    buf << '%-20s' % match.team1
    buf << "  #{format_score( match )}  "
    buf << match.team2
    buf << "\n"

    last_round = match.round
    last_date  = match.date
  end

  buf
end

def build_stage_by_group( matches )
  ## find all groups (and teams)
  ## find all matchdays (and start and end dates)
  groups    = {}
  matchdays = {}
  matches.each do |match|
    group = groups[ match.group ] ||= []
    group << match.team1    unless group.include?( match.team1 )
    group << match.team2    unless group.include?( match.team2 )

    matchday = matchdays[ match.round ] ||= { start_date: nil, end_date: nil }
    matchday[:start_date] = match.date    if matchday[:start_date].nil? || matchday[:start_date] > match.date
    matchday[:end_date]   = match.date    if matchday[:end_date].nil?   || matchday[:end_date]   < match.date
  end


  buf = String.new('')

  ## sort by name (A, B, C, etc.)
  groups = groups.sort {|l,r| l <=> r }
  pp groups

  groups.each do |rec|
    group_name = rec[0]
    team_names = rec[1].map {|name| '%-20s' % name }  ## add some min. padding

    buf << "Group #{group_name} |  "
    buf << team_names.join( '  ' ).strip
    buf << "\n"
  end
  buf << "\n\n"


  ## sort by name (Matchday 1, Matchday 2, etc.)
  matchdays = matchdays.sort {|l,r| l <=> r }
  pp matchdays

  matchdays.each do |rec|
    matchday_name = rec[0]
    start_date = Date.strptime( rec[1][:start_date], '%Y-%m-%d' )
    end_date   = Date.strptime( rec[1][:end_date],   '%Y-%m-%d' )

    buf << "#{matchday_name} |  "
    buf << "#{start_date.strftime('%b/%-d')} - #{end_date.strftime('%b/%-d')}"
    buf << "\n"
  end
  buf << "\n\n"

  ## sort matches by
  ##  1) group
  ##  2) date
  matches = matches.sort do |l,r|
    result = l.group <=> r.group
    result = l.date  <=> r.date    if result == 0
    result
 end

  last_group = nil
  last_date  = nil

  matches.each do |match|
    if match.group != last_group
      buf << "\n"
      buf << "Group #{match.group}:"
      buf << "\n"
      last_date = nil
    end

    if match.date != last_date
      date = Date.strptime( match.date, '%Y-%m-%d' )
      buf << "\n"
      buf << "[#{date.strftime('%a %b/%-d')}]"
      buf << "\n"
    end

    buf << "  "
    buf << '%-20s' % match.team1
    buf << "  #{format_score( match )}  "
    buf << match.team2
    buf << "\n"

    last_group = match.group
    last_date  = match.date
  end

  buf
end


def write_buf( path, buf )  ## write buffer helper
  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end


def write_cl( season )
  season = SportDb::Import::Season.new( season )  ## normalize season

  in_path = "./o/cl/#{season.path}/cl.csv"
  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"

  matches = normalize( matches )


  ## split into three stages / files
  ## - Qualifiying
  ## - Group
  ## - Knockout

  stages = matches.group_by { |match| match.stage }
  pp stages.keys

  # out_dir = './tmp'
  out_dir = '../../../openfootball/europe-champions-league'


  league_name = 'UEFA Champions League'

  ## note: use separate "Quali" league for now for Qualifiying stage
  buf = String.new( '' )
  buf << "= #{league_name} - Qualification #{season.key}\n\n"
  buf <<  build_stage( stages['Qualifying'] )

  puts buf
  write_buf( "#{out_dir}/#{season.path}/cl_quali.txt", buf )
  puts "-----------"

  buf = String.new( '' )
  buf << "= #{league_name} #{season.key}\n\n"
  buf << build_stage_by_group( stages['Group'] )

  puts buf
  write_buf( "#{out_dir}/#{season.path}/cl.txt", buf )
  puts "-----------"

  buf = String.new( '' )
  buf << "= #{league_name} #{season.key}\n\n"
  buf << build_stage( stages['Knockout'] )

  puts buf
  write_buf( "#{out_dir}/#{season.path}/cl_finals.txt", buf )
end



write_cl( '2018/19' )
write_cl( '2019/20' )

puts "bye"


