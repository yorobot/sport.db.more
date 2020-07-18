module SportDb
class JsonExporter


LEAGUE_TO_BASENAME = {
  'eng.1' => 'en.1',
  'eng.2' => 'en.2',
  'eng.3' => 'en.3',
  'eng.4' => 'en.4',

  'world' => 'worldcup',
  ## 'cl'    => 'cl',    ## keep cl as is :-)
  'uefa.cl'       => 'cl',
  'uefa.cl.quali' => 'cl.quali'
}


def self.export( league_key, out_root: )

  puts "find league >#{league_key}<"
  league = Model::League.find_by!( key: league_key )

  league.events.each do |event|
     puts "** event:"
     pp event.name
     pp event.season
     pp event.league
     puts "teams.count: #{event.teams.count}"
     puts "rounds.count: #{event.rounds.count}"
     puts "groups.count: #{event.groups.count}"
     puts "matches.count: #{event.matches.count}"


     ## build path e.g.
     ##  2014-15/at.1.clubs.json

     ##  -- check for remapping (e.g. add .1); if not found use league key as is
     league_basename = LEAGUE_TO_BASENAME[ event.league.key ] || event.league.key

     season_basename = event.season.name.sub('/', '-')  ## e.g. change 2014/15 to 2014-15


     out_dir   = "#{out_root}/#{season_basename}"
     ## make sure folders exist
     FileUtils.mkdir_p( out_dir ) unless Dir.exists?( out_dir )

     data_clubs = build_clubs( event )
     ## pp data_clubs
     File.open( "#{out_dir}/#{league_basename}.clubs.json", 'w:utf-8' ) do |f|
       f.write JSON.pretty_generate( data_clubs )
     end

     # note: make groups export optional for now - why? why not?
     unless event.groups.empty?
       data_groups = build_groups( event )
       ## pp data_groups
       File.open( "#{out_dir}/#{league_basename}.groups.json", 'w' ) do |f|
         f.write JSON.pretty_generate( data_groups )
       end
     end

     data_matches = build_matches( event )
     ## pp data_matches
     File.open( "#{out_dir}/#{league_basename}.json", 'w:utf-8' ) do |f|
       f.write JSON.pretty_generate( data_matches )
     end
  end
end


###############
## helpers

def self.build_clubs( event )
  clubs = []
  event.teams.each do |team|
    clubs << { name:    team.name,
               code:    team.code,
               country: team.country.name, }
  end

  data = {
   name:  event.name,
   clubs: clubs
  }

  data
end


def self.build_groups( event )
  groups = []
  event.groups.each do |group|
    teams  = []

    if group.teams.empty?
      puts "!! WARN - group #{group.name} has no teams/is empty"
    end

    group.teams.each do |team|
      teams << team.name
    end
    groups << { name: group.name, teams: teams }
  end

  data = {
   name:   event.name,
   groups: groups
  }

  data
end


def self.build_matches( event )
  rounds = []
  event.rounds.each do |round|
    matches = []
    round.matches.each do |match|
      h = { date:  match.date.strftime( '%Y-%m-%d'),
            team1: match.team1.name,
            team2: match.team2.name }

      score = {}
      if match.score1 && match.score2
        score[:ft] = [match.score1, match.score2]
      end

      if match.score1et && match.score2et
        score[:et] = [match.score1et, match.score2et]
      end

      if match.score1p && match.score2p
        score[:p]  = [match.score1p, match.score2p]
      end

      h[ :score ] = score   unless score.empty?  ## note: only add if has some data


      unless match.goals.empty?
        goals1, goals2 = build_goals( match )
        h[ :goals1 ] = goals1
        h[ :goals2 ] = goals2
      end

      h[ :group ] = match.group.name    if match.group
      h[ :stage ] = match.stage.name    if match.stage

      matches << h
    end

    rounds << { name:    round.name,
                matches: matches }
  end

  data = {
    name:   event.name,
    rounds: rounds
  }

  data
end


def self.build_goals( match )
  goals1 = []
  goals2 = []

  match.goals.each do |goal|
    if goal.team_id == match.team1_id
      goals = goals1
    elsif goal.team_id == match.team2_id
      goals = goals2
    else
      puts "*** team id NOT matching for goal; must be team1 or team2 id"
      exit 1   ## exit - why? why not?
    end

    g = { name:   goal.person.name,
          minute: goal.minute,
        }
    g[:offset]  = goal.offset     if goal.offset != 0
    g[:score1]  = goal.score1
    g[:score2]  = goal.score2
    g[:penalty] = goal.penalty    if goal.penalty
    g[:owngoal] = goal.owngoal    if goal.owngoal
    goals << g
  end
  [goals1, goals2]
end


end # class Json Exporter
end # module SportDb