require_relative '../helper'

##
## check parsing of utc dates
##   with or without time (and seconds) and timezone (Z=zulu) etc.


h = {
   "StartDate" => "2025-08-08T00:00:00Z",
    "EndDate" => "2026-05-16T00:00:00Z",
}


pp h

date = Date.strptime( h['StartDate'], '%Y-%m-%d' )
pp date
date = Date.strptime( h['EndDate'], '%Y-%m-%d' )
pp date


##
## q: how to check for utc
##    how to print timezone

puts "---"
date = parse_date( h['StartDate'] )
pp date
pp "offset:", date.offset
pp date.strftime( "%z" )
pp date.hour, date.min, date.sec


pp parse_date_utc( h['StartDate'] )  ## expects :00Z
pp parse_date_utc( h['EndDate'] )  ## expects :00Z


puts "bye"