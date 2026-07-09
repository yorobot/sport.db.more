

     ## check for goal type (og) or (p)
      ##  1 -  "penalty"
      ##  2 -  "regular"
      ##  3 -  "own goal"

# TYPE_GOAL = {
#    1 => 'PENALTY',
#    2 =  'REGULAR',
#    3 =  'OWN_GOAL',
# }


def build_goal( h, players: )

    ## split into minute
    ##  and offset (stoppage/injury time)
    ##  e.g. 90'+11'

     minute_str = h['Minute']

     if minute_str.nil? || minute_str.empty?



      ## todo/fix - find minute
      ##   in interconti cup 2024-12-1
        if h['Period'] == 11    ## realy penalty shoot out!!!
                                   ## skip - why? why not?
            minute_str =  "121'"
        else
           puts "!! minute in goal is nil or empty:"
           pp h
           exit 1
        end
      end


    minute, offset = _parse_minute( minute_str )

    ## check for weird minute 0 e.g.
    ##   Germany-Austria 1934
    minute = 1  if h['Minute'] == "0'"


    ##
    ##  merge minute and offset via string e.g. use
    ##     "45+4" or such - why? why not?

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
     rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)

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
       recs = recs.select { |rec| rec[:minute] <= 120 }
    end

    ## sort by minutes
    ##  may not be sorted

    recs = recs.sort do |l,r|
                 res = l[:minute] <=> r[:minute]
                 res = (l[:offset]||0) <=> (r[:offset]||0)  if res == 0 &&
                                                              (l[:minute] == 45 ||
                                                               l[:minute] == 90 ||
                                                               l[:minute] == 105 ||  ## check - if possible stoppage in 1st half extra-time??
                                                               l[:minute] == 120)
                 res
           end
    recs
end
