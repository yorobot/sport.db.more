require_relative './lib/fifadat'


cache_dir    = '/sports/cache.fifadat'
convert_dir  = '/sports/cache.api.fifa'


name   = 'worldcup'
season = '2026'

Fifa._idSeason_by!( name: name, season: season )

prepare_reports( name: name,
                 season: season,
                 outdir: cache_dir,
               )




convert( slug: name,
              season: season,
              indir: cache_dir,
               outdir: convert_dir )

convert_reports( slug: name,
              season: season,
              indir: cache_dir,
               outdir: convert_dir )


puts "bye"