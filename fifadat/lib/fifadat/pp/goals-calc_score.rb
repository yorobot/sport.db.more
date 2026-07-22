

def _build_score_from_goals( m )
   ##
   ## 5 periods - 3 (1ST_HALF), 5 (2ND_HALF),
   ##             7 (EXTRA_TIME_1ST_HALF), 9 (EXTRA_TIME_2ND_HALF),
   ##             11 (PENALTY_SHOOTOUT) possibly
   ##
   goals = {
      count: 0,
      score: [0,0],
      ht:   { score: [0,0], minutes: [] },
      ft:   { score: [0,0], minutes: [] },
      et:   { score: [0,0], minutes: [] },
      p:    { score: [0,0], minutes: [] },
   }

   ## note - quick fix
   ##            add  period 2  for USA v Belgium (PKO) - worldcup

   ## note - i is 0|1  -  array index for team
   [m['HomeTeam']['Goals'],
    m['AwayTeam']['Goals']].each_with_index do |recs,i|
      recs.each do |h|

        h = errata_autofix_goal( h )

        period = h['Period']
        ## include penalty shootout (11) - why? why not?
        assert(  [3,5,7,9,11].include?(period),
                  "goal in period 3/5/7/9/11 expected; got #{h.pretty_inspect} in match #{m.pretty_inspect}" )

        minute = h['Minute']
        key =  case period
               when 3    then  :ht
               when 5    then  :ft
               when 7, 9 then  :et
               when 11   then  :p
               else
                raise ArgumentError,
                  "goal in period 3/5/7/9/11 expected; got #{h.pretty_inspect}"
               end

        goals[:count] += 1
        goals[:score][i] += 1   unless key == :p
        goals[key][:score][i] += 1
      end
   end

   ## use/calc cummulative score  (BUT not for penalties)
   goals[:ft][:score][0] += goals[:ht][:score][0]
   goals[:ft][:score][1] += goals[:ht][:score][1]

   goals[:et][:score][0] += goals[:ft][:score][0]
   goals[:et][:score][1] += goals[:ft][:score][1]

   goals
end
