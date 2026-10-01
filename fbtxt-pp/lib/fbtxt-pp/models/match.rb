

class Match


##
##  use Match.build( h ) - why? why not?

attr_reader :team1,    :team2,
            :score,
            :datetime_utc,
            :date_local,
            :time_local, :utc_offset,
            :stadium,
            :goals1, :goals2



def initialize( doc, data )
     ## expect a data as (json) hash for now
     @doc = doc
     @h   = data


     ## note - always lookup full team records (use match inline only as refs)
     @team1 = @doc.find_team!( @h['team1'] )
     @team2 = @doc.find_team!( @h['team2'] )



     ####
     #  note -  match might NOT be timed only scheduled (e.g. only date no time)

     ##
     ## todo/fix
     ##   support different date style formats - why? why not?
     ##  for now use/prefer:
     ##        "datetime_utc": "2026-08-08T16:15Z",
     ##        "date_local": "2026-08-08",
     ##        "time_local": "18:15 UTC+2",


     if @h['date_local'] && @h['time_local'].nil?
       @date_local =  Date.strptime( @h['date_local'], '%Y-%m-%d' )
     else
       @datetime_utc   = parse_date_utc( @h['datetime_utc'] )
       assert( @datetime_utc.sec == 0,  "sec 00 expected" )

       @date_local     = Date.strptime( @h['date_local'], '%Y-%m-%d' )
       ## 18:15 UTC+2
       ##  split into  18:15 and UTC+2
       @time_local, @utc_offset  = @h['time_local'].split( /[ ]+/, 2)

       ## pp [@datetime_utc, @date_local, @time_local, @utc_offset]
     end


     ## note - always lookup full stadium record (use match inline only as ref)
     @stadium  =  @doc.find_stadium!( @h['stadium'] )


     @score   =   @h['score'] ? Score.build( @h['score'] ) :  nil


     @goals1 =   @h['goals1'] ? @h['goals1'].map { |h| Goal.build( h ) } : nil
     @goals2 =   @h['goals2'] ? @h['goals2'].map { |h| Goal.build( h ) } : nil
end



## use _data  to mark as "private" and do NOT use - why? why not?
def data() @h; end



##  todo - find a better name for timezone offset
##   use utc_offset - why? why not?
##  alias_method :diff_in_hours, :utc_offset


def stage()      @h['stage']; end
def group()      @h['group']; end     # optional
def num()        @h['number']; end    # optional (match) number
def matchday()   @h['matchday']; end  # optional


def attendance() @h['attendance']; end


end  ## class Match