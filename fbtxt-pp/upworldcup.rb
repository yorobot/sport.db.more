require_relative './lib/fbtxt-pp'


convert_dir  = '/sports/cache.api.fifa'

outdir = './tmp/worldcup'
# outdir = '/sports/openfootball/worldcup/more'

slug     = 'worldcup'
seasons =  ['2026']    ##['1930', '1934', '2026']

opts = {
                stadium: false,
                city:    true,
                show_stadiums: true
       }
opts_full = {
                show_stadiums: true
       }




seasons.each do |season|

  header = String.new
  header << "= World Cup #{season}\n"
  header <<  "\n"

    buf = pp_matches_full( slug: slug, season: season,
                                indir: convert_dir,
                                opts: FormatOpts.build_full( **opts_full ))

 outpath =   "#{outdir}/#{season}_full.txt"


 write_text( outpath, header+buf )
 puts " written to >#{outpath}<"


  buf = pp_matches( slug: slug, season: season,
                                indir: convert_dir,
                                opts: FormatOpts.build_full( **opts ))

  outpath =   "#{outdir}/#{season}.txt"

   write_text( outpath, header+buf )
   puts " written to >#{outpath}<"
end

puts "bye"
