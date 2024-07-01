##################
# to run use:
#    ruby up\more.rb


require_relative 'helper'


## more top-level countries / leagues

DATASETS = [
 # ['br.1',    %w[2023]],     

 # ['eng.1',   %w[2023/24]],  
 # ['eng.2',   %w[2023/24]],  
 ['eng.3',   %w[2023/24]],   
 ['eng.4',   %w[2023/24]],  
 ['eng.5',   %w[2023/24]],   
 ## todo/fix: add league cup and ...

 # ['de.1',    %w[2023/24]],  
 ['de.2',    %w[2023/24]],  
 ['de.3',    %w[2023/24]],  
 ['de.cup',  %w[2023/24]],

 # ['es.1',    %w[2023/24]],  
 ['es.2',    %w[2023/24]], 

 # ['it.1',    %w[2023/24]],  
 ['it.2',    %w[2023/24]],   

 # ['fr.1',    %w[2023/24]], 
 ['fr.2',    %w[2023/24]],  


 ['at.1',    %w[2023/24]],   
 ['at.2',    %w[2023/24]], 
 ['at.3.o',  %w[2023/24]], 
## ['at.cup',  %w[2023/24]],    fix - score error


 #  fix mx.1 config!! rerun
# ['mx.1',    %w[2020/21]],   # starts Fri Jul 24
]



pp DATASETS

## use args for query (e.g. at, etc.)
datasets = filter_datasets( DATASETS, ARGV )

puts "INCLUDES (QUERIES):"
pp ARGV
puts "DATASETS:"
pp datasets
# puts "REPOS:"
# pp repos



Worldfootball.process( datasets, 
                          download: OPTS[:download],
                          push:     OPTS[:push] )

puts "bye"
