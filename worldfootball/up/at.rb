##################
# to run use:
#    ruby up\at.rb


require_relative 'helper'

DATASETS = [
    ['at.1',    %w[2024/25 2023/24 2022/23 2021/22 2020/21]],   
    ['at.2',    %w[2024/25 2023/24 2022/23 2021/22 2020/21]], 
    ['at.3.o',  %w[2023/24 2022/23 2021/22 2020/21]],   #  %w[2024/25]], 
 
     #   %w[2023/24]],    fix!!! - score error
     ['at.cup',  %w[2024/25 2022/23 2021/22 2020/21]],  
]


## use args for query (e.g. at, etc.)
datasets = filter_datasets( DATASETS, ARGV )

Worldfootball.process( datasets, 
                          download: OPTS[:download],
                          push:     OPTS[:push] )

puts "bye"
