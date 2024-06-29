## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.


require 'cocos'   ## check if webget incl. cocos ??


require 'tzinfo'


module Footballdata
  class Configuration
    #########
    ## nested configuration classes - use - why? why not?
    class Convert
        def out_dir()       @out_dir || './o'; end
        def out_dir=(value) @out_dir = value; end
     end
 
    def convert()  @convert ||= Convert.new; end
  end # class Configuration

  ## lets you use
  ##   Footballdata.configure do |config|
  ##      config.convert.out_dir = './o'
  ##   end
  def self.configure()  yield( config ); end
  def self.config()  @config ||= Configuration.new;  end
end   # module Footballdata




###
# our own code
require_relative 'footballdata/leagues'
require_relative 'footballdata/download'
require_relative 'footballdata/prettyprint'

require_relative 'footballdata/convert'
require_relative 'footballdata/mods'


#############
## todo/fix:  reuse  a "original" CsvMatchWriter
##                  how? why? why not?
###############
module Cache
class CsvMatchWriter

  def self.csv_encode( values )
    ## quote values that incl. a comma
    values.map do |value|
      if value.index(',')
        puts "** rec with field with comma >#{value}< in:"
        pp values
        %Q{"#{value}"}
      else
        value
      end
    end.join( ',' )
  end

  def self.write( path, recs, headers: )
    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

    File.open( path, 'w:utf-8' ) do |f|
      f.write( headers.join(','))   ## e.g. Date,Team 1,FT,HT,Team 2
      f.write( "\n" )
      recs.each do |values|
        f.write( csv_encode( values ))
        f.write( "\n" )
      end
    end
  end
end # class CsvMatchWriter
end # module Cache




