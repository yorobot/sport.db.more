require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.
require 'season/formats' 

require 'fifa'


=begin
Webcache.root =  if File.exist?( '/sports/cache' )
                     puts "  setting web cache to >/sports/cache<"
                     '/sports/cache'
                 else
                     './cache'
                 end
=end


#############
##  add simple helper to parse datetime in utc


class Time
  ## -- todo - make sure / assert it's always utc - how???
  ## utc   = ## tz_utc.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%S%Z' )
  ##  note:  DateTime.strptime  is supposed to be unaware of timezones!!!
  ##            use to parse utc
  ## quick hack -
  ##     use to_time.getutc instead of utc ???
  ##
  ##  2023-11-04T20:00:00+00:00
  ##
  ##  check - use %Z instead of %z - why? why not?
  def self.parse_utc( str, format: '%Y-%m-%dT%H:%M:%S%z' )
      d = DateTime.strptime( str, format )
      ## remove assert check - why? why not?
      if d.zone != '+00:00'    ### use d.offset != Ration(0,1)  - why? why not?
         puts "!! ASSERT - UTC parse date; DateTime returns offset != +0:00"
         pp d.zone
         pp d
         exit 1
      end
      ## note - ignores offset if any !!!!
      ##    todo/check - report warn if offset different from 0:00 (0/1) - why? why not?
      Time.utc( d.year, d.month, d.day, d.hour, d.min, d.sec )
  end
end




### our own code
require_relative 'api-football/download'
require_relative 'api-football/build'


