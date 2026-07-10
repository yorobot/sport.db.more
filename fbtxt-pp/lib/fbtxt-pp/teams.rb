

def build_team( h )
   name = h['name']
   ## name = norm_team( name )

   id = h['id']
   if id.nil?
      id = name.downcase.gsub( /[^a-z0-9]/, '' )
   end

   rec = { id:      id,
           name:    name,
           code:    h['code'],
           country: h['country'],
           count:   0,
        }

  rec
end




class Teams
   def initialize
      @recs = {}
   end

   def add( recs )
      recs.each do |rec|
        _add( build_team(  rec ) )
      end
   end



   def add_matches( matches )  ## use/rename to add_matches - why? why not?
      matches.each do |m|
        ## note - skip if teams not yet know
        next if m['team1'].nil? && m['team2'].nil?

        [m['team1'],m['team2']].each do |name|
            team = find!( name )
            team[:count] += 1
        end
      end
   end


   def find!( name )
      if name == '?'    ## return dummy
        rec = { name: '?',
                code: '?',
                country: '?', }
      else
        id = name.downcase.gsub( /[^a-z0-9]/, '' )
        rec =  @recs[ id ]
        raise ArgumentError, "no team found for name >#{name}< using id >#{id}<"  if rec.nil?
        rec
      end
   end



   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          @recs[ new_rec[:id]] = new_rec
      else
         raise ArgumentError,
            "duplicate team records  #{rec.pretty_inspect} == #{new_rec.pretty_inspect}"
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
