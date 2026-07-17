

     ## check for goal type (og) or (p)
      ##  1 -  "penalty"
      ##  2 -  "regular"
      ##  3 -  "own goal"



def build_goal( h, players: )

    ## split into minute
    ##  and offset (stoppage/injury time)
    ##  e.g. 90'+11'


     minute_str = h['Minute']

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
