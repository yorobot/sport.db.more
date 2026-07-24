
##
## note:
##  document is container for LeagueSeason holding teams, matches, etc.

class Document

def self.read( path )
     data = read_json( path )
     new( data )
end

def initialize( data )
    @data = data

    @teams = Teams.new
    @teams.add( data['teams'] )
    ## puts "  #{teams.size} team(s) in season #{season}"

    @stadiums = Stadiums.new
    @stadiums.add( data['stadiums'] )
    ## puts "  #{stadiums.size} stadium(s) in season #{season}"
end


def find_team_by!( name: ) @teams.find_by!( name: name );  end

def find_stadium!( h ) @stadiums.find!( h );  end



def each_match( &blk )
   @data['matches'].each do |_m|
      ## use ("typed" struct) wrapper
      m = Match.new( self, _m )
      blk.call( m )
   end
end
alias_method  :each, :each_match


end # class Document