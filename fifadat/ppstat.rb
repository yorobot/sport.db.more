require_relative './lib/fifadat'


cache_dir = '/sports/cache.fifadat'


datafiles =  Dir.glob( "#{cache_dir}/**/**_matches.json" )
pp datafiles
puts "  #{datafiles.size} datafile(s)"


datafiles.each_with_index do |path,i|
  puts "==> reading #{i+1}/#{datafiles.size} #{path}..."
  data = read_json_v2( path )

  matches = data['Results']
  matches.each do |m|
    matchStatus = m['MatchStatus']
    resultType  = m['ResultType']

    if ![0,1].include?(matchStatus) ||
       ![0,1,2,3,4,5].include?(resultType)
       buf = pp_match( m, season: true )   ### use format: 'long' or such?
       puts buf
    end
  end
end



puts "bye"