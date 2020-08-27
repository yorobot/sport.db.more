## note: use the local version of sportdb gems

### todo/fix:
## (re)use starter.rb script in config/ folder - why? why not?
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/linters'

