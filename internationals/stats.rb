require 'cocos'



repo_dir = "/sports/more/international_results"



stats = { 'team'       => Hash.new(0),
          'country'    => Hash.new(0),
          'tournament' => Hash.new(0) }

recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
pp recs[0]


recs.each do |rec|
    stats['team'][rec['home_team']] += 1
    stats['team'][rec['away_team']] += 1
    
    stats['country'][rec['country']] += 1
    stats['tournament'][rec['tournament']] += 1
end

pp stats

puts "bye"