require_relative 'helper'



# Footballdata::Metal.competitions( auth: false )   ## get all
  
data = Footballdata::Metal.competitions( auth: true )   ## get free tier (TIER_ONE) with auth (token)
pp data

puts "bye"
