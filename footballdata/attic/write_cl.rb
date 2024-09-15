



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



