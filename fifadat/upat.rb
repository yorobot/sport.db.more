require_relative './lib/fifadat'


cache_dir    = '/sports/cache.fifadat'
convert_dir  = '/sports/cache.api.fifa'


name = 'at'
season = '2025/26'

Fifa._idSeason_by!( name: name, season: season )


convert( slug: name,
              season: season,
              indir: cache_dir,
               outdir: convert_dir )



puts "bye"