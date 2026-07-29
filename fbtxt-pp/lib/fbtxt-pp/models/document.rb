
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


   ## read in stages for sorting
   ##   incl.  SequenceOrder, StageLevel (optional)
   ## stages = Stages.new
   ## stages.add( read_json( "./#{slug}/misc/#{season}_stages.json" )['Results'] )

    ## automagically sort (by groups) - why? why not?
    @data['matches'] = _sort_matches( @data['matches'] )
end


def find_team!( q ) @teams.find!( q );  end

def find_stadium!( h ) @stadiums.find!( h );  end


## quick ("unsafe/low-level") access for size - keep? why? why not?
##   use team_count, stadium_count, match_count  - why? why not?
def teams()     @teams; end
def stadiums()  @stadiums; end
def matches()   @data['matches']; end


def each_match( &blk )
   @data['matches'].each do |_m|
      ## use ("typed" struct) wrapper
      m = Match.new( self, _m )
      blk.call( m )
   end
end
alias_method  :each, :each_match


## (was: collect_dates)
##   find a better name e.g. min_max_dates / duration / collect/find_start_end_dates?
def calc_start_end_dates
  start_date = nil
  end_date   = nil

  @data['matches'].each do |_m|

     ## date_utc       = parse_date_utc(   _m['datetime_utc'] )
     date_local     = parse_date_local( _m['datetime_local'] )

     ## note - alway use local datetime for now

     if start_date.nil? || date_local  < start_date
        start_date = date_local
      end

     if end_date.nil? || date_local > end_date
        end_date = date_local
     end
  end

  [start_date, end_date]
end



###
##  (private) helpers

def _sort_matches( matches )
  ###
  ##   sort results by group if present

  ## add "old" sort index
  matches = matches.each_with_index.map {|m,i| m['sort']=i+1; m }


  matches =  matches.sort do |l,r|

   lhs_stage =  l['stage']
   rhs_stage =  r['stage']

   ## lhs_stage = stages.find!( lhs_stageName )
   ## rhs_stage = stages.find!( rhs_stageName )

   lhs_group  = l['group']   # optional
   rhs_group  = r['group']   # optional

   lhs_matchday  = l['matchday']   # optional
   rhs_matchday  = r['matchday']   # optional

   if (lhs_group && rhs_group) && (lhs_stage == rhs_stage)
       res = lhs_group <=> rhs_group
       res = (lhs_matchday && rhs_matchday ?
              lhs_matchday <=> rhs_matchday :  0 )  if res == 0
       ## same group; sort by old index (or) date??
       res = l['sort'] <=> r['sort']   if res == 0
       res
   else
       ### sort first by stage (seq) and than keep as is
       ### res = lhs_stage[:seq] <=> rhs_stage[:seq]
       ## res = l['sort'] <=> r['sort']    if res == 0
       ## res
       l['sort'] <=> r['sort']
   end
  end

   matches
end



end # class Document