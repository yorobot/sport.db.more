require 'webget/football'


# require 'sportdb/formats'   ## for Season etc.
require 'sportdb/catalogs'    ## note: incl. deps csvreader etc.



#############
## todo/fix:  reuse  a "original" CsvMatchWriter
##                  how? why? why not?
###############
module Cache
class CsvMatchWriter

    def self.write( path, recs, headers: )

      ## for convenience - make sure parent folders/directories exist
      FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

        File.open( path, 'w:utf-8' ) do |f|
          f.write headers.join(',')   ## e.g. Date,Team 1,FT,HT,Team 2
          f.write "\n"
          recs.each do |rec|
              f.write rec.join(',')
              f.write "\n"
          end
        end
    end

end # class CsvMatchWriter
end # module Cache




###
# our own code
require 'football-sources/version' # let version always go first

require 'football-sources/apis'
require 'football-sources/worldfootball'



puts FootballSources.banner   # say hello
