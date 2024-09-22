###
##  to run use:
##    $ ruby sandbox/test_uefa.rb


#
# todo/fix:
#   check timezones e.g
#   !! ERROR: no timezone found for kz.1 2023
#    ...


require_relative 'helper'


require 'fifa'


uefa = Uefa.countries


uefa.each do |country|
   key = country.key
   ## use cup for liechtenstein (li)
   league_code =  key == 'li' ? "#{key}.cup" : "#{key}.1"

   league =  Worldfootball::LEAGUES[ league_code ]
   if league.nil?
      puts "!! no league found for #{country.key} #{country.name}"
   else
      puts "  OK #{country.key} #{country.name}"
   end
end


## leagues with calendar (not academic) year
calendar = %w[
   by
   ee lt lv
   fo fi no se is
   ge kz
   ie
]


buf = String.new
buf << "league, seasons\n"

uefa.each do |country|
    key = country.key
    ## use cup for liechtenstein (li)
    league =  key == 'li' ? "#{key}.cup" : "#{key}.1"

    season = calendar.include?( key ) ? '2023' : '2023/24'
    buf << "#{league}, #{season}          ## #{country.name}\n"
end

write_text( "./tmp/uefa_2023.csv", buf)


puts "bye"

