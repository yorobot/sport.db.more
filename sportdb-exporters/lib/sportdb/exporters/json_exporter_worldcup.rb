module SportDb
class JsonExporter

## hack: for timezone (add timezone to city - fix/fix/fix)

CITY_TO_TIMEZONE = {
  ## brazil 2014
  'Rio de Janeiro'   => 'UTC-3',
  'Brasília'         => 'UTC-3',
  'São Paulo'        => 'UTC-3',
  'Fortaleza'        => 'UTC-3',
  'Belo Horizonte'   => 'UTC-3',
  'Salvador'         => 'UTC-3',
  'Natal'            => 'UTC-3',
  'Porto Alegre'     => 'UTC-3',
  'Recife'           => 'UTC-3',
  'Curitiba'         => 'UTC-3',
  'Cuiabá'           => 'UTC-4',
  'Manaus'           => 'UTC-4',
  ## russia 2018
  'Kaliningrad'      => 'UTC+2',
  'Nizhny Novgorod'  => 'UTC+3',
  'Volgograd'        => 'UTC+3',
  'Saransk'          => 'UTC+3',
  'Rostov-on-Don'    => 'UTC+3',
  'Kazan'            => 'UTC+3',
  'Sochi'            => 'UTC+3',
  'Saint Petersburg' => 'UTC+3',
  'Moscow'           => 'UTC+3',
  'Samara'           => 'UTC+4',
  'Ekaterinburg'     => 'UTC+5',
}

def self.city_to_timezone( city )
  CITY_TO_TIMEZONE[ city ] || '?'
end


def self.export_worldcup( league_key, out_root: )

  league = Model::League.find_by_key!( league_key )

  league.events.each do |event|
     puts "** event:"
     pp event.title
     pp event.season
     pp event.league
     puts "teams.count: #{event.teams.count}"
     puts "rounds.count: #{event.rounds.count}"
     puts "groups.count: #{event.groups.count}"
     puts "grounds.count: #{event.grounds.count}"


     grounds = []
     event.grounds.each do |ground|
        grounds << { key:      ground.key,
                     name:     ground.title,
                     capacity: ground.capacity,
                     city:     ground.city.name,
                     timezone: city_to_timezone( ground.city.name ) }
     end

     hash_grounds = {
      name:     event.title,
      stadiums: grounds
     }

     pp hash_grounds


     teams = []
     event.teams.each do |team|
       if team.country.assoc
         continental = {}
         team.country.assoc.parent_assocs.each do |parent|
           ## next if parent.key == 'fifa'  ## skip fifa
           ##  todo/fix: only include / use (single) continental (parent) org/assoc
           ##  find/use continental parent only for now
           if ['caf', 'afc', 'concacaf', 'uefa', 'conmebol', 'ofc'].include? parent.key
             continental = { name: parent.title,
                             code: parent.key.upcase }
           end
         end
         assoc = { key:          team.country.assoc.key,
                   name:         team.country.assoc.title,
                 }
         assoc[ :continental ] = continental   unless continental.empty?
       else
         assoc = {}
       end
       t = { name:      team.title,
             code:      team.code,
             continent: team.country.continent.name }
       t[ :assoc ] = assoc   unless assoc.empty?
       teams << t
     end

     hash_teams = {
      name: event.title,
      teams: teams
     }

     pp hash_teams


     standings = []
     event.groups.each do |group|
       entries = []
       group_standing = Model::GroupStanding.find_by( group_id: group.id )
       if group_standing
         group_standing.entries.each do |entry|
            entries << { team: { name: entry.team.name, code: entry.team.code },
                         pos:           entry.pos,
                         played:        entry.played,
                         won:           entry.won,
                         drawn:         entry.drawn,
                         lost:          entry.lost,
                         goals_for:     entry.goals_for,
                         goals_against: entry.goals_against,
                         pts:           entry.pts
                       }
          end
        end
        standings << { name: group.title, standings: entries }
     end

     hash_standings = {
      name:   event.title,
      groups: standings
     }

     pp hash_standings


     groups = []
     event.groups.each do |group|
       teams  = []
       group.teams.each do |team|
         teams << { name: team.title,
                    code: team.code
                  }
       end
       groups << { name: group.title, teams: teams }
     end

     hash_groups = {
      name: event.title,
      groups: groups
     }

     pp hash_groups


     rounds = []
     event.rounds.each do |round|
       matches = []
       round.games.each do |game|
         m = {        num:  game.pos,    ## use id - why? why not?
                      date: game.play_at.strftime( '%Y-%m-%d'),
                      time: game.play_at.strftime( '%H:%M'),
                      team1: {
                        name: game.team1.title,
                        code: game.team1.code
                      },
                      team2: {
                        name: game.team2.title,
                        code: game.team2.code
                      },
                      score1:    game.score1,
                      score2:    game.score2,
                      score1i:   game.score1i,   # half time / first third (opt)
                      score2i:   game.score2i,   # half time - team 2
                }

                if game.knockout
                  m[ :score1et ] = game.score1et  # extratime - team 1 (opt)
                  m[ :score2et ] = game.score2et  # extratime - team 2 (opt)
                  m[ :score1p  ] = game.score1p   # penalty  - team 1 (opt)
                  m[ :score2p  ] = game.score2p   # penalty  - team 2 (opt) elfmeter (opt)
                  m[ :knockout ] = game.knockout
                end

                unless game.goals.empty?
                  goals1, goals2 = build_goals( game )
                  m[ :goals1 ] = goals1
                  m[ :goals2 ] = goals2
                end

                if game.group
                  m[ :group ]    =  game.group.title
                end

                if game.ground
                  m[ :stadium  ] = { key: game.ground.key, name: game.ground.title }
                  m[ :city     ] = game.ground.city.name
                  m[ :timezone ] = city_to_timezone( game.ground.city.name )
                end

          matches << m
       end

       rounds << { name: round.title, matches: matches }
     end

     hash_matches =  {
       name: event.title,
       rounds: rounds
     }

     pp hash_matches


     ## build path e.g.
     ##  2014-15/at.1.clubs.json
     ##  2018/worldcup.teams.json

     ##  -- check for remapping (e.g. add .1); if not found use league key as is
     league_basename = LEAGUE_TO_BASENAME[ event.league.key ] || event.league.key

     season_basename = event.season.title.sub('/', '-')  ## e.g. change 2014/15 to 2014-15


     out_dir   = "#{out_root}/#{season_basename}"
     ## make sure folders exist
     FileUtils.mkdir_p( out_dir ) unless Dir.exist?( out_dir )

     File.open( "#{out_dir}/#{league_basename}.stadiums.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_grounds )
     end

     File.open( "#{out_dir}/#{league_basename}.teams.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_teams )
     end

     File.open( "#{out_dir}/#{league_basename}.groups.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_groups )
     end

     File.open( "#{out_dir}/#{league_basename}.standings.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_standings )
     end

     File.open( "#{out_dir}/#{league_basename}.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_matches )
     end
  end
end

end # class Json Exporter
end # module SportDb
