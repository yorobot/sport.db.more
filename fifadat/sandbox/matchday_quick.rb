require_relative '../helper'



year = 1930
date = Date.new( year, 1, 1 )
loop do

  from = "#{date.strftime('%Y-%m-%d')}T00:00:00Z"
  to   = "#{date.strftime('%Y-%m-%d')}T23:59:59Z"

  print "==> %03d" % date.yday 
  print "  #{from} - #{to} "
  
  
  outpath = "./matchday/#{date.year}/#{'%03d' % date.yday}_#{date.strftime('%Y-%m-%d')}.json"
  data = read_json( outpath )
  data = data['Results']
  print " -- #{data.size} match(es)\n"

   date += 1

   break      if date >= Date.new( year+1, 1, 1 )
end


puts "bye"