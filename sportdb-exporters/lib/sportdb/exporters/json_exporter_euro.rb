module SportDb
class JsonExporter



def self.export_euro( league_key, out_root: )

  league = Model::League.find_by_key!( league_key )

  league.events.each do |event|
     puts "** event:"
     pp event.name
     pp event.season
     pp event.league
     puts "teams.count: #{event.teams.count}"
     puts "rounds.count: #{event.rounds.count}"
     puts "groups.count: #{event.groups.count}"
     puts "grounds.count: #{event.grounds.count}"


     grounds = []
     event.grounds.each do |ground|
        grounds << { key:      ground.key,
                     name:     ground.name,
                     capacity: ground.capacity,
                     city:     ground.city.name,
                     timezone: 'UTC+1'   ## use summertime (CEST+2) why? why not? 
                     }
     end

     hash_grounds = {
      name:     event.name,
      stadiums: grounds
     }

     pp hash_grounds


     teams = []
     event.teams.each do |team|
       t = { name:      team.name,
             code:      team.code }
       teams << t
     end

     hash_teams = {
      name: event.name,
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
        standings << { name: group.name, standings: entries }
     end

     hash_standings = {
      name:   event.name,
      groups: standings
     }

     pp hash_standings


     groups = []
     event.groups.each do |group|
       teams  = []
       group.teams.each do |team|
         teams << { name: team.name,
                    code: team.code
                  }
       end
       groups << { name: group.name, teams: teams }
     end

     hash_groups = {
      name: event.name,
      groups: groups
     }

     pp hash_groups


     rounds = []
     event.rounds.each do |round|
       matches = []
       round.matches.each do |game|
         m = {        num:  game.pos,    ## use id - why? why not?
                      date: game.date.strftime( '%Y-%m-%d'),
                      time: game.time,  ## note: time is stored as string!!!
                      team1: {
                        name: game.team1.name,
                        code: game.team1.code
                      },
                      team2: {
                        name: game.team2.name,
                        code: game.team2.code
                      },
                }

               score = {}

                if game.score1
                  score[:ft] = [game.score1,
                                game.score2]
                   if game.score1i
                      # half time / first third (opt)
                      # half time - team 2
                      score[:ht] = [game.score1i,
                                    game.score2i]
                  end
                end

                ## note: change do NOT check for knockout flag
                ##         check for scores for now 
                if game.score1et
                    # extratime - team 1 (opt)
                    # extratime - team 2 (opt)
                    score[:et] = [game.score1et,
                                  game.score2et] 
                  if game.score1p
                     # penalty  - team 1 (opt)
                     # penalty  - team 2 (opt) elfmeter (opt)
                     score[:p] = [game.score1p,
                                 game.score2p  
                                ]
                  end
                end  

                m[:score] = score

                #  m[ :knockout ] = game.knockout
                

                unless game.goals.empty?
                  goals1, goals2 = build_goals( game )
                  m[ :goals1 ] = goals1
                  m[ :goals2 ] = goals2
                end

                if game.group
                  m[ :group ]    =  game.group.name
                end

                if game.ground
                  m[ :stadium  ] = { key: game.ground.key, name: game.ground.name }
                  m[ :city     ] = game.ground.city.name
                  m[ :timezone ] = 'UTC+1'   ## use summertime (CEST+2) why? why not?
                end

          matches << m
       end

       rounds << { name: round.name, matches: matches }
     end

     hash_matches =  {
       name: event.name,
       rounds: rounds
     }

     pp hash_matches


     ## build path e.g.
     ##  2014-15/at.1.clubs.json
     ##  2018/worldcup.teams.json

     ##  -- check for remapping (e.g. add .1); if not found use league key as is
     league_basename =  event.league.key

     season_basename = event.season.name.sub('/', '-')  ## e.g. change 2014/15 to 2014-15


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
