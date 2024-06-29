require_relative 'helper'

## for now use cache if no args
cache  = ARGV[0].nil? ? true : false 

date =  if ['y', 'yesterday'].include?( ARGV[0] )
            Date.today-1       
        elsif ['t', 'tomorrow'].include?( ARGV[0] )
            Date.today+1        
        else
            Date.today
        end

data = if cache  
         Webcache.read_json( Footballdata::Metal.todays_matches_url( date ) )
       else
         Footballdata::Metal.todays_matches( date )
       end

pp data


data['matches'].each do |rec|
  puts Footballdata.fmt_competition( rec )
  puts Footballdata.fmt_match( rec )
end

puts "bye"
