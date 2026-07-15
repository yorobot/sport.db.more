require_relative './lib/fifadat'


cache_dir    = '/sports/cache.fifadat'
convert_dir  = '/sports/cache.api.fifa'


Fifa::CODES.values.each do |rec|
   next if !rec[:club]   ## skip if NOT club

   code          = rec[:code]   ## note - using code (NOT name here)
   idCompetition = rec[:idCompetition]


   ## get latest season rec
   seasons = Fifa::COMPETITIONS[ idCompetition ].keys
   puts "#{code}   (#{seasons.size}) - #{seasons.inspect}"

   season = seasons[0]  ## get first
   pp  Fifa._idSeason_by!( name: code, season: season )

   prepare( name:    code,
            season:  season,
            outdir:  cache_dir )    ## note - autoadd slug (name) e..g ./eng !!


     convert( slug: code,
              season: season,
              indir: cache_dir,
               outdir: convert_dir )

end

puts "bye"