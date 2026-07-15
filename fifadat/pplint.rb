require_relative './lib/fifadat'


cache_dir = '/sports/cache.fifadat'


datafiles =  Dir.glob( "#{cache_dir}/**/**_matches.json" )
pp datafiles
puts "  #{datafiles.size} datafile(s)"


datafiles.each_with_index do |path,i|
  puts "==> reading #{i+1}/#{datafiles.size} #{path}..."
  data = read_json_v2( path )

  buf, stats, errors =  pp_debug( data )

   puts
   puts buf
   puts

   ## print some stats
   puts " MatchStatus: #{stats['MatchStatus'].inspect}, "+
        "TimeDefined: #{stats['TimeDefined'].inspect}"
   puts " ResultType: #{stats['ResultType'].inspect}"

   if errors.size > 0
      puts "!! #{errors.size} error(s):"
      pp errors
   end
end



puts "bye"