

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


def desc( data )   ## get description
    return nil if data.nil? || (data.is_a?(Array) && data.empty?)

    row = data[0]   ## assume first entry is en-GB
    locale = row['Locale']
    assert( locale == 'en-GB' || locale == 'en-gb',
              "locale en-GB expected in data[0] - got #{data}")

    row['Description']
end


