require 'cocos'
require 'tzinfo'


recs = []
['timezones_america',
 'timezones_asia',
 'timezones_europe',
 'timezones_world',].each do |name|
    recs += read_csv( "./config/#{name}.csv" )
end
pp recs


def dump( tz )
    puts
    pp tz
    pp tz.canonical_zone
    pp tz.abbreviation
    pp tz.base_utc_offset
    # pp tz.current_period
end


warns = []

recs.each do |rec|
    tz = TZInfo::Timezone.get( rec['zone'] )
    if tz.nil?
        puts "!! ERROR - no zone found for:"
        pp rec
        exit 1
    end
    dump( tz )

    unless tz.is_a?( TZInfo::DataTimezone )
        puts "!! WARN - not canonicial? (linked?)"

        ## try to use canonical only for now
        warns << "#{tz}  NOT canonicial - linked to #{tz.canonical_zone}"
    end
end


pp warns

puts "bye"