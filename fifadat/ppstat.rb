require_relative './lib/fifadat'


cache_dir = '/sports/cache.fifadat'


datafiles =  Dir.glob( "#{cache_dir}/**/**_matches.json" )
pp datafiles
puts "  #{datafiles.size} datafile(s)"


totals = mk_stats()

datafiles.each_with_index do |path,i|
  puts "==> reading #{i+1}/#{datafiles.size} #{path}..."
  data = read_json_v2( path )

   stats = mk_stats()
   collect_stats( data, stats: stats )
   collect_stats( data, stats: totals )


   ## print some stats
   pp stats.except(  'Leg', 'IsHomeMatch' )
   ## puts " MatchStatus: #{stats['MatchStatus'].pretty_inspect}, "+
   ##     "TimeDefined: #{stats['TimeDefined'].pretty_inspect}"
   ## puts " ResultType: #{stats['ResultType'].pretty_inspect}"

end


puts
pp totals

puts "bye"




__END__


if opts[:lint]
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|
        ###
        ## add debug


       data =  read_json( "#{indir}/#{slug}/#{season.to_path}_matches.json" )


        page = String.new
        page << "= #{slug} #{season}\n"
        page << "#  generated on #{Time.now}\n"
        page <<  "\n"

        buf = pp_debug( slug: slug, season: season,
                    indir: cache_dir )

        page << buf
        puts page

        outpath =  "#{convert_dir}/#{season.to_path}_#{slug}-debug.txt"

        ## write_text( outpath, page )
        ## puts "  written to >#{outpath}<"
      end
    end
else
