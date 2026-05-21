

##
## todo - add "xx" to names - why? why not?
##   todo/check - allow/support "Didi" or such for name - why?
SCORER_FIX = {
  %q{Eduardo "Volkswagen" Hernández}     => "Eduardo Hernández", ## fix!!!
  %q{Delio "Maravilla" Gamboa}           => "Delio Gamboa",      ## fix!!!
  %q{Alex "Didí" Valverde}               => "Alex Valverde",     ## fix!!!

  "Carlos Castillo, honduran footballer" => "Carlos Castillo",
  "John Kerr, Jr."                       => "John Kerr Jr.",
  "it:Lee Ki-Bum"                        => "Lee Ki-Bum",
}




def _pp_goals( recs )
   players = {}

   ## "fold" multiple goals of player
   recs.each do |rec|

      scorer = rec['scorer']

      if scorer.nil? || scorer.empty?
         puts "!! WARN - (goals) scorer empty:"
         pp rec
         scorer = 'N.N.'    ## note - use N.N. NOT ?? for n/a
         ## raise ArgumentError, "scorer empty"
      end

      ###
      ## auto-fix scorer
      scorer = SCORER_FIX[scorer] || scorer


      if  rec['minute'].nil? || rec['minute'].empty?
        puts "!! WARN - (goals) minute empty:"
        pp rec
        ## use '??'
        rec['minute'] = '??'
        ## raise ArgumentError, "minute empty"
      end

      goal = String.new
      goal << "#{rec['minute']}'"
      goal << '(og)'   if rec['own_goal'] == 'TRUE'
      goal << '(p)'    if rec['penalty']  == 'TRUE'

      player_rec = players[ scorer ] ||= { name: scorer, goals: [] }
      player_rec[:goals] << goal
   end


   buf =  players.map do |_,player|
                    "#{player[:name]} #{player[:goals].join(',')}"
                end.join( ' ' )
   buf
end



def build_goals( recs )
  ## split into goals1 and goals2
    #  date,home_team,away_team,team,scorer,minute,own_goal,penalty

    goals1 = []
    goals2 = []
    recs.each do |rec|
        if rec['home_team'] == rec['team']
            goals1 << rec
        elsif rec['away_team'] == rec['team']
            goals2 << rec
        else
            pp rec
            raise ArgumentError, "unknown team for match"
        end
    end


    buf = String.new

    if goals1.size == 0
        buf << "     ("
        buf << _pp_goals( goals2 )
        buf << ")\n"
    else    ## split over two lines - why? why not?
        buf << "     ("
        buf << _pp_goals( goals1 )
        if goals2.size == 0
          buf << ")\n"
        else
          buf << ";\n"
          buf << "      "
          buf << _pp_goals( goals2 )
          buf << ")\n"
        end
    end

    buf
end
