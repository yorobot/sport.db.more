##################
# to run use:
#    ruby up\wfb.rb  at|world|top  or such


require_relative 'helper'


dataset_key  = ARGV.shift   ## e.g. at/world

require_relative "wfb/#{dataset_key}.rb"

pp DATASETS


## use args for query (e.g. at, etc.)
datasets = filter_datasets( DATASETS, ARGV )

puts "INCLUDES (QUERIES):"
pp ARGV
puts "DATASETS:"
pp datasets
# puts "REPOS:"
# pp repos


if OPTS[:dry]
    ## do nothing
else
  Fbup.process( datasets,
                    source: Worldfootball,
                    download: OPTS[:download],
                    push:     OPTS[:push] )
end

puts "bye"

