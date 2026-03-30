
require_relative '../helper'

str = "Ismail JAKOBS  Ismail JAKOBS"
pp is_alpha?( str  )

str.each_char do |ch|
  puts "%s => U+%04X" % [ch, ch.ord]
end


puts "bye"