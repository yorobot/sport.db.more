

def build_team( h )
   name = desc( h['TeamName'] )
   name = norm_team( name )
   
   rec = { id:      h['IdTeam'],
           name:    name,
           abbrev:  h['Abbreviation'],
           country: h['IdCountry'],
        }

  rec
end




class Teams
   def initialize
      @recs = {}
   end

   def add( matches )  ## use/rename to add_matches - why? why not?
      matches.each do |m|
        team1 = build_team( m['Home'] )
        team2 = build_team( m['Away'] )

        _add( team1 )
        _add( team2 )
      end
   end


   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec
      else
          rec[:count] += 1

          ## assert attributes equal - why? why not?
          assert( new_rec[:name]    == rec[:name] &&
                  new_rec[:abbrev]  == rec[:abbrev] &&
                  new_rec[:country] == rec[:country],
                  "team records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def recs( sort: true  )
      recs = @recs.values
      if sort
        recs = recs.sort do |l,r|
                res = r[:count] <=> l[:count]
                res = l[:name] <=> r[:name]  if res == 0
                res
             end
      end  
      recs
   end
   def each( sort: true, &blk ) recs( sort: sort ).each( &blk ); end
 
 
   def dump
      recs = recs( sort: true )
      pp recs
      puts "  #{recs.size} team(s)"
   end

   def size() @recs.size; end

end  # class Teams




