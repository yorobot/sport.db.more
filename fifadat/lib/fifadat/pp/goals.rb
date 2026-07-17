

     ## check for goal type (og) or (p)
      ##  1 -  "penalty"
      ##  2 -  "regular"
      ##  3 -  "own goal"


=begin
in USA v Belgium
"Type"=>2,
 "IdPlayer"=>"448362",
 "Minute"=>"1'",
 "IdAssistPlayer"=>nil,
 "Period"=>2,
 "IdGoal"=>nil,
 "IdTeam"=>"43935"}

{     "Type": 2,
      "IdPlayer": "448362",
      "Minute": "0'",
      "IdAssistPlayer": null,
      "Period": 2,
      "IdGoal": null,
      "IdTeam": "43935"},


=end

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
        period = h['Period']
        ## include penalty shootout (11) - why? why not?
        assert(  [2,3,5,7,9,11].include?(period),
                  "goal in period 3/5/7/9/11 expected; got #{h.pretty_inspect} in match #{m.pretty_inspect}" )

        minute = h['Minute']
        key =  case period
               when 2,3    then  :ht
               when 5    then  :ft
               when 7, 9 then  :et
               when 11   then  :p
               else
                raise ArgumentError,
                  "goal in period 3/5/7/9/11 expected; got #{h.pretty_inspect}"
               end

        goals[:count] += 1
        goals[:score][i] += 1
        goals[key][:score][i] += 1
      end
   end

   ## use cummulative score  (BUT not for penalties)
   goals[:ft][:score][0] += goals[:ht][:score][0]
   goals[:ft][:score][1] += goals[:ht][:score][1]

   goals[:et][:score][0] += goals[:ft][:score][0]
   goals[:et][:score][1] += goals[:ft][:score][1]

   goals
end




def build_goal( h, players: )

    ## split into minute
    ##  and offset (stoppage/injury time)
    ##  e.g. 90'+11'


     minute_str = h['Minute']

     period = h['Period']

     ## include penalty shootout (11) - why? why not?
     ## assert(  [3,5,7,9].include?(period),
     ##             "goal in period 3/5/7/9 expected; got #{h.pretty_inspect}" )


    ##  quick fix:
    ## check for weird minute 0 e.g.
    ##   Germany-Austria 1934
    if minute_str == "0'"
       h['Minute'] = "1'"
    elsif minute_str.nil? || minute_str.empty?
      ## todo/fix - find minute
      ##   in interconti cup 2024-12-1
        if h['Period'] == 11    ## really penalty shoot out!!!
                                   ## skip - why? why not?
            h['Minute'] =  "121'"
        else
           puts "!! minute in goal is nil or empty:"
           pp h
           exit 1
        end
    end

    minute = _build_minute( h )

    rec = {}

      idPlayer = h['IdPlayer']

      if idPlayer.nil?
         puts "!! no idPlayer for goal!"
         pp h
          ##exit 1
          ## use 'N.N.'

          rec[ :name ] = 'N.N.'

      else
        player = players.find!( idPlayer )
        rec[ :name ] = player[ :name ]
      end

     rec[ :minute] = minute

      type =  h['Type']
      rec[ :pen ] = true  if type == 1
      rec[ :og ]  = true  if type == 3

      rec
end




def build_goals( recs, players:,  penalties: false )
    recs = recs.map  { |h| build_goal( h, players: players ) }

    ## note - filter out penalties (from shoot-out)!!
    ##    min > 120  (e.g. 121, etc.)
    if penalties == false
       recs = recs.select { |rec| rec[:minute].m <= 120 }
    end

    ## note - sort by minutes; goals may not be sorted
    recs = recs.sort { |l,r| l[:minute] <=> r[:minute] }
    recs
end
