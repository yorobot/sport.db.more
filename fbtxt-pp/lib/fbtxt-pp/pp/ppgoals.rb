


def _pp_goals( recs )
   players = {}

   ## "fold" multiple goals of player
   recs.each do |rec|
      player_name = rec.name

      goal = String.new
      ## goal << _fmt_minute( rec[:minute], rec[:offset] )
      goal <<  rec.minute
      goal << "'"  unless ['?','??'].include?(rec.minute)   ## add minute marker

      ## check for goal type (og) or (p)
      goal << "(p)"   if rec.pen?
      goal << "(og)"  if rec.og?

      player_rec = players[ player_name ] ||= []
      player_rec << goal
   end


   buf =  players.map do |name,goals|
                    "#{name} #{goals.join(', ')}"
                end.join( ', ' )
   buf
end



def pp_goals( m,  indent: 4  )

   return ''  if m.goals1.nil? && m.goals2.nil?


   goals1 = m.goals1
   goals2 = m.goals2

    puts
    puts "  #{goals1.size}-#{goals2.size}  "
    pp goals1
    pp goals2


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
