
##
### check - change Generator to Writer 
##                   and write( league:, season: ) - why? why not?

module Worldfootball
class Generator



###########    
## always download for now - why? why not?
##      support cache - why? why not?
def generate( league:, season: )

  ## for testing use cached version always - why? why not?    
  ## step 1 - download
  Worldfootball.schedule( league: league, season: season )

  ## step 2 - convert (to .csv)

  ## todo/fix - convert in-memory and return matches
  Worldfootball.convert( league: league, season: season )

  source_dir = Worldfootball.config.convert.out_dir

  Writer.write( league: league, 
                season: season,
                source: source_dir )
end  # def generate

end # class Generator
end # module Worldfootball
