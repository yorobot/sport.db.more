

class Match


##
##  use Match.build( h ) - why? why not?

attr_reader :team1,    :team2,
            :score,
            :date_utc, :date_local,  :utc_offset,
            :stadium,
            :goals1, :goals2



def initialize( doc, data )
     ## expect a data as (json) hash for now
     @doc = doc
     @h   = data


     ## note - always lookup full team records (use match inline only as refs)
     @team1 = @doc.find_team_by!( name: @h['team1'] )
     @team2 = @doc.find_team_by!( name: @h['team2'] )


     @date_utc       = parse_date_utc(   @h['datetime_utc'] )
     @date_local     = parse_date_local( @h['datetime_local'] )

     assert( @date_utc.sec == 0 && @date_local.sec == 0,
                "sec 00 expected" )

    ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
    ## diff_in_hours = ((localDateTime - dateTime) * 24).to_f
    ## diff_in_days  =  localDateTime.jd - dateTime.jd

     # note - offset is in rational fraction of a day (e.g. 1/12 for 2hours)
     ##  was diff_in_hours
     @utc_offset = (@date_local.offset * 24).to_i

     ## pp [@date_utc, @date_local, @utc_offset]

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
alias_method :diff_in_hours, :utc_offset


def stage()      @h['stage']; end
def group()      @h['group']; end     # optional
def num()        @h['number']; end    # optional (match) number
def matchday()   @h['matchday']; end  # optional


def attendance() @h['attendance']; end


end  ## class Match