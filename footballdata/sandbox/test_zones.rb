require 'cocos'
require 'tzinfo'



recs = read_csv( "./config/timezones.csv")
pp recs


def dump( tz )
    puts
    pp tz
    pp tz.canonical_zone
    pp tz.abbreviation
    pp tz.base_utc_offset
    pp tz.current_period
end


recs.each do |rec|
    tz = TZInfo::Timezone.get( rec['zone'] )
    if tz.nil?
        puts "!! ERROR - no zone found for:"
        pp rec
        exit 1
    end
    dump( tz )
end

puts "bye"