

def build_team( h )

   if h
      name = desc( h['TeamName'] )

      ##  name = norm_team( name )

      rec = { id:      h['IdTeam'],
           name:    name,
           code:   h['Abbreviation'],
           country: h['IdCountry'],     ## change to cc (country code) - why? why not?
        }

     rec
   else    ## assume nil - dummy record
     rec =  {
         name:    '?',
         code:    '?',   ## use nil - why? why not?
         country: '?' ## use nil - why? why not?
            }
      rec
   end
end




class Teams
   def initialize
      @recs = {}
   end

   def add_matches( matches )  ## use/rename to add_matches - why? why not?
      matches.each do |m|
        ## note - skip if teams not yet know
        next if m['Home'].nil? && m['Away'].nil?

        team1 = build_team( m['Home'] )
        team2 = build_team( m['Away'] )

        _add( team1 )
        _add( team2 )
      end
   end


=begin
!! ASSERT FAILED - team records NOT matching -
{:id=>"44129",
 :name=>"Vasco da Gama",
 :code=>"VDG",
 :country=>"BRA",
 :count=>7}
 !=
 {:id=>"44129",
  :name=>"Vasco da Gama",
  :code=>"VAS",
  :country=>"BRA"}
=end


   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec
      else
          rec[:count] += 1

          ## assert attributes equal - why? why not?
          ## note - ignore code for now
          ##     new_rec[:code]  == rec[:code] &&
          assert( new_rec[:name]    == rec[:name] &&
                  new_rec[:country] == rec[:country],
                  "team records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def as_json( id: false )
      if id
        @recs.values
      else
        @recs.values.map { |rec| rec.except(:id ) }
      end
   end

   def size() @recs.size; end

end  # class Teams
