

def assert( test, msg )
    if test
    else
        puts "!! ASSERT FAILED - #{msg}"
        exit 1
    end
end


def parse_date_utc( date_str )
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M%z' )

    assert( date_str == date.strftime('%Y-%m-%dT%H:%MZ'),
              "date parse expected #{date_str} - got #{date.inspect}" )
    date
end

def parse_date_local( date_str )
    ## fix - parse UTC+-offset !!!!
    ##  e.g. 2025-08-01 20:30 UTC+2
    date = DateTime.strptime( date_str, '%Y-%m-%d %H:%M UTC%z' )

    ## assert( date_str == date.strftime('%Y-%m-%dT%H:%MZ'),
    ##          "date parse expected #{date_str} - got #{date.inspect}" )
    date
end



 MINUTE_RE = %r{  \A
                       (?<minute>\d{1,3}) '
                        (  \+
                          (?<offset>\d{1,2}) '
                        )?
                   \z
                 }x


def _parse_minute( str )

    ## support weirdo  120'+-30'  -- remove minuts
    str = str.gsub( '-', '' )

    m = MINUTE_RE.match( str )
    raise ArgumentError, "unknown goal minute format in #{str.inspect}"  if m.nil?

    minute = m[:minute].to_i(10)
    offset = m[:offset] ? m[:offset].to_i(10) : nil

    [minute,offset]
end

def _fmt_minute( minute, offset )
     ## pp [minute,offset]

     buf = String.new
     buf << "#{minute}"
     buf << "+#{offset}"   if offset
     buf << "'"
     buf
end




###
## helper matches

def collect_dates( matches, dates )
  ## collect min/max dates (duration - start/end)
  ##   e.g.
  ##   {  start: <date>,
  ##      end:   <date>
  ##   }


  matches.each_with_index do |m, i|

    puts "[#{i+1}] " + m['datetime_utc'] + "  /  " + m['datetime_local']

    dateTime       = parse_date_utc( m['datetime_utc'] )    ## utc
    localDateTime  = parse_date_local( m['datetime_local'] )

    ## note - alway use local datetime for now

   if dates[:start].nil? || localDateTime < dates[:start]
        dates[:start] = localDateTime
   end

   if dates[:end].nil? || localDateTime > dates[:end]
        dates[:end] = localDateTime
   end
  end
end



def sort_matches( data  )
  ###
  ##   sort results by group if present

  ## add "old" sort index
  data = data.each_with_index.map {|m,i| m['sort']=i+1; m }


  data =  data.sort do |l,r|

   lhs_stage =  l['stage']
   rhs_stage =  r['stage']

   ## lhs_stage = stages.find!( lhs_stageName )
   ## rhs_stage = stages.find!( rhs_stageName )

   lhs_group  = l['group']   # optional
   rhs_group  = r['group']   # optional

   lhs_matchday  = l['matchday']   # optional
   rhs_matchday  = r['matchday']   # optional

   if (lhs_group && rhs_group) && (lhs_stage == rhs_stage)
       res =    if lhs_matchday && rhs_matchday
                     lhs_matchday <=> rhs_matchday
                else
                     0
                end
       res = lhs_group <=> rhs_group   if res == 0
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

   data
end
