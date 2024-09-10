
class UTC
  def self.now()  Time.now.utc; end
  def self.today() now.to_date; end

  ## -- todo - make sure / assert it's always utc - how???
  ## utc   = ## tz_utc.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
  ##  note:  DateTime.strptime  is supposed to be unaware of timezones!!!
  ##            use to parse utc
  ## quick hack -
  ##     use to_time.getutc instead of utc ???
  def self.strptime( str, format )
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

  def self.find_zone( name )
     zone = TZInfo::Timezone.get( name )
     ## wrap tzinfo timezone in our own - for adding more (auto)checks etc.
     zone ? Timezone.new( zone ) : nil
  end

class Timezone   ## nested inside UTC
   ## todo/fix
   ##  cache timezone - why? why not?
   def initialize( zone )
     @zone = zone
   end

   def to_local( time )
      ## assert time is Time (not Date or DateTIme)
      ##  and assert utc!!!
      assert( time.is_a?( Time ),  "time #{time} is NOT of class Time; got #{time.class.name}" )
      assert( time.utc?,           "time #{time} is NOT utc; utc? returns #{time.utc?}" )
      local = @zone.to_local( time )
      local
   end

   def assert( cond, msg )
    if cond
      # do nothing
    else
      puts "!!! assert failed - #{msg}"
      exit 1
    end
  end
end  # class Timezone
end   # class UTC



module Footballdata
def self.find_zone!( league:, season: )
   @zones ||= begin
                recs = read_csv( "#{FootballdataApi.root}/config/timezones.csv" )
                zones = {}
                recs.each do |rec|
                    zone = UTC.find_zone( rec['zone'] )
                    if zone.nil?
                      ## raise ArgumentError - invalid zone
                      puts "!! ERROR - cannot find timezone in timezone db:"
                      pp rec
                      exit 1
                    end
                    zones[ rec['key']] = zone
                end
                zones
              end


   ## lookup first try by league+season
   league_code = league.downcase
   season      = Season( season )

   ##  e.g. world+2022, etc.
   key = "#{league_code}+#{season}"
   zone = @zones[key]

   ## try league e.g. eng.1 etc.
   zone = @zones[league_code]  if zone.nil?

   ## try first code only (country code )
   if zone.nil?
     code, _  = league_code.split( '.', 2 )
     zone = @zones[code]
   end

   if zone.nil?  ## still not found; report error
      puts "!! ERROR: no timezone found for #{league} #{season}"
      exit 1
   end

   zone
end
end # module Footballdata



