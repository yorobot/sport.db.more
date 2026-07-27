

def assert( test, msg )
    if test
    else
        puts "!! ASSERT FAILED - #{msg}"
        exit 1
    end
end


def parse_date_utc( date_str )
    ## note - DateTime has NOT daylight saving time (e.g. dst?)
    ##    or named timezones!!
    ##        only works with offsets
    ##
    ##  use Time for built-in timezones (and check on daylight saving time etc.)

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
