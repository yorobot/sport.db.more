####
# to run use:
#   ruby ./up.rb


$LOAD_PATH.unshift( '../sportdb-writers/lib' )
require 'sportdb/writers'


## same as
## $ fbgen -f ./leagues.csv


args = ['-f', './leagues.csv' ]
# args <<  '--push'

## args = ['at.1']
Fbgen.main( args )


puts "bye"