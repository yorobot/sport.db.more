

def assert( test, msg )
    if test
    else
        puts "!! ASSERT FAILED - #{msg}"
        exit 1
    end
end


def parse_date( date_str )
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%S%z' )

    assert( date_str == date.strftime('%Y-%m-%dT%H:%M:%SZ'),
              "date parse expected #{date_str} - got #{date.inspect}" )
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



def desc( data )   ## get description
    return nil if data.nil? || (data.is_a?(Array) && data.empty?)

    row = data[0]   ## assume first entry is en-GB
    locale = row['Locale']
    assert( locale == 'en-GB' || locale == 'en-gb',
              "locale en-GB expected in data[0] - got #{data}")

    row['Description']
end
