

def assert( test, msg )
    if test
    else
        puts "!! ASSERT FAILED - #{msg}"
        exit 1
    end
end

### fix - change/rename to datetime!!!
def parse_date( date_str )
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%S%z' )

    assert( date_str == date.strftime('%Y-%m-%dT%H:%M:%SZ'),
              "date parse expected #{date_str} - got #{date.inspect}" )
    date
end


def parse_date_utc( str )
    date = DateTime.strptime( str, '%Y-%m-%dT%H:%M:%S%z' )

    ## note: check for seconds is 00
    ##    AND   timezone  is Z (zulu)  (shortkey for utc!)
    ##  e.g. hard code   ":00Z" in strftime!!!

    str_exp = date.strftime('%Y-%m-%dT%H:%M:00Z')
    assert( str == str_exp,
              "date parse expected #{str_exp} - got #{str} #{date.inspect}" )
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
