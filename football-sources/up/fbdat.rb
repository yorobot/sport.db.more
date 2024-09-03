##################
# to run use:
#    ruby up\fbdat.rb  top|more  or such


require_relative 'helper'


dataset_key  = ARGV.shift   ## e.g. top|more

require_relative "fbdat/#{dataset_key}.rb"

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
# todo: add normalize option !!!!
#
# normproc = method(:normalize).to_proc
# pp normproc
# normproc.call( [], league: 'eng.1' )

## max. 10 requests/minute
##          about ~6 request/minute (if delay is 10 secs)
Webget.config.sleep  = 10

Fbup.process( datasets,
                  source: Footballdata,
                  download: OPTS[:download],
                  push:     OPTS[:push] )
end

puts "bye"

