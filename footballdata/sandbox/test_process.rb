##########
#  to run use:
#    $ ruby sandbox/test_process.rb

require_relative 'helper'


datasets = [
   # ['eng.1',   %w[2024/25]],  
    ['de.1',    %w[2023/24]],
]

# defaults for
#   convert.out_dir  -> './o'
#   writer.out_dir   -> './tmp'

Footballdata.config.convert.out_dir = './tmp3/stage'
Writer.config.out_dir               = './tmp3'
puts "Writer.config.out_dir:"                                
puts Writer.config.out_dir


##
## todo/check - check if writer is using config.out_dir??
##                gets written to ./tmp (not ./tmp3) - why?

##
## yes, note - for now "./tmp" hardcoded in process
##            change - why? why not?

Footballdata.process( datasets, download: false, # true,
                                push: false )

puts "Writer.config.out_dir:"                                
puts Writer.config.out_dir

puts "bye"