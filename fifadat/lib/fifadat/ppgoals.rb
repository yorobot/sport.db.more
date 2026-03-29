


def _pp_goals( recs )
   players = {}

   ## "fold" multiple goals of player
   recs.each do |rec|
      player_name = rec[:player][:name]

      goal = String.new
      goal << _fmt_minute( rec[:minute], rec[:offset] )

      ## check for goal type (og) or (p)
      ##  1 -  "penalty"
      ##  2 -  "regular"
      ##  3 -  "own goal"
  
      goal << "(p)"   if rec[:type] == 1
      goal << "(og)"  if rec[:type] == 3

      player_rec = players[ player_name ] ||= { name: player_name, goals: [] }
      player_rec[:goals] << goal
   end


   buf =  players.map do |_,player| 
                    "#{player[:name]} #{player[:goals].join(', ')}" 
                end.join( ', ' )
   buf
end



def pp_goals( live, players:, 
                    indent: 4  )
    
   goals1 = build_goals( live['HomeTeam']['Goals'], players: players )
   goals2 = build_goals( live['AwayTeam']['Goals'], players: players )
  
   ## puts
   ## puts "  #{goals1.size}-#{goals2.size}  "
   ## pp goals1
   ## pp goals2


    buf_goals1 = _pp_goals( goals1 )
    puts buf_goals1
    buf_goals2 = _pp_goals( goals2 )
    puts buf_goals2

 
    buf = String.new
 
    goal_indent = ' ' * indent
  
    if goals1.size == 0 && goals2.size == 0
        ## do nothing
    elsif goals1.size > 0 && goals2.size == 0
        buf << "#{goal_indent} (#{buf_goals1})\n"
    elsif goals1.size == 0 && goals2.size > 0
        buf << "#{goal_indent} (#{buf_goals2})\n"
    elsif (goals1.size == 1 && goals2.size == 1)  
        buf << "#{goal_indent} (#{buf_goals1}; #{buf_goals2})\n"
    else  ## both sides with goals
        buf << "#{goal_indent} (#{buf_goals1};\n"
        buf << "#{goal_indent}  #{buf_goals2})\n"
    end
  
    buf
end

