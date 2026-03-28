

def norm_team( name )

    ## \u00A0 - non-breaking space
   name = name.gsub( /[\u00A0]/, ' ' )

    ##
    ## simple mapping - make for generic!
    name = 'West Germany'   if name == 'Germany FR'
    name = 'East Germany'   if name == 'German DR'
    
    name = 'South Korea'   if name == 'Korea Republic'
    name = 'North Korea'   if name == 'Korea DPR'
    
    name = 'China'     if name == 'China PR'
    name = 'Ireland'   if name == 'Republic of Ireland'
  
    name = 'Iran'      if name == 'IR Iran' 
 ## !! ASSERT FAILED - team records NOT matching - 
 ##    {:id=>"43817", :name=>"Iran", :abbrev=>"IRN", :count=>7}
 ## != {:id=>"43817", :name=>"IR Iran", :abbrev=>"IRN"}   

    name = 'USA'     if name == 'United States'
  
    name
end



def build_team_rec( h )
   name = desc( h['TeamName'] )

   name = norm_team( name )


   rec = { id:      h['IdTeam'],
           name:    name,
           abbrev:  h['Abbreviation']
        }

  rec
end



class Teams
   def initialize
      @recs = {}
   end

   def add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec

      else
          rec[:count] += 1
          ## assert attributes equal - why? why not?

          assert( new_rec[:name] == rec[:name] &&
                  new_rec[:abbrev] == rec[:abbrev],
                  "team records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def recs( sort: true, stringify: false )
      recs = @recs.values
      if sort
        recs = recs.sort do |l,r|
                res = r[:count] <=> l[:count]
                res = l[:name] <=> r[:name]  if res == 0
                res
             end
      end
      ## fix/fix/fix - stringify keys!!!
      recs
   end
   
 
   def dump
      recs = recs( sort: true, stringify: false )
      pp recs
      puts "  #{recs.size} team(s)"
   end

   def size() @recs.size; end

end  # class Teams



def collect_teams( cup, teams )
  cup['Results'].each_with_index do |m, i|

    team1 = build_team_rec( m['Home'] )
    team2 = build_team_rec( m['Away'] )

    teams.add( team1 )
    teams.add( team2 )
  end
end


