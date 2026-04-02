require_relative '../helper'




def collect_comps( matches, 
                   stats: Hash.new(0)  ) 

   matches.each do |m|
       stats[m['IdCompetition']] += 1
   end

   stats
end



start_date = Date.new( 2019, 1, 1 )
date = start_date

total_stats = Hash.new(0)

loop do

  from = "#{date.strftime('%Y-%m-%d')}T00:00:00Z"
  to   = "#{date.strftime('%Y-%m-%d')}T23:59:59Z"

  print "==> %03d" % date.yday 
  print "  #{from} - #{to} "
  
  outpath = "./matchday/#{date.year}/#{'%03d' % date.yday}_#{date.strftime('%Y-%m-%d')}.json"
  data = read_json( outpath )
  data = data['Results']
  print " -- #{data.size} match(es)\n"
  
   collect_comps( data, stats: total_stats )

   date += 1

   break      if date >= Date.new( 2026, 3, 30 )
end


puts
puts "total:"
pp total_stats


total_stats.each_with_index do |(idCompetition, count),i|
  outpath = "./competitions/#{idCompetition}.json"
 
  ## note - skip "weirdo" / invalid idCompetitions
  ##       used FCWC_MCQ in ???
  next if ['FCWC_MCQ'].include?( idCompetition )

  
  puts "==> [#{i+1}/#{total_stats.size}] ..."

  url = Fifa::Metal.competition_url( idCompetition: idCompetition )   
  fetch_json_if( url, outpath )
end


puts "bye"