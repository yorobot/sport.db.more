require_relative '../helper'


###
## fetch matches by day

start_time = Time.now

year = 2021
date = Date.new( year, 1, 1 )


## check 2024-03-16

count = 500   ## note - 500 is max

loop do

  from = "#{date.strftime('%Y-%m-%d')}T00:00:00Z"
  to   = "#{date.strftime('%Y-%m-%d')}T23:59:59Z"

  print "==> %03d" % date.yday 
  print "  #{from} - #{to} "
  print "\n"
  
  outpath = "./matchday/#{date.year}/#{'%03d' % date.yday}_#{date.strftime('%Y-%m-%d')}.json"
  data = fetch_json_if( Fifa.search_matches_url( from: from, to: to, count: count), 
                        outpath )

   ## note - returns nil for now if CACHE HIT (that is, not downloaded)                     
   if data
      puts "  #{data['Results'].size} match(es)"

      if data['Results'].size == count   ## max. count  - more matches available
         puts "!! max count #{count} hit - do continuation"
        
         ## do a quick hack continuation
         ##         {"ContinuationToken": 
         ##  "W3siY29tcG9zaXRlVG9rZW4iOnsidG9rZW4iOm51bGwsInJhbmdlIjp7Im1pbiI6IiIsIm1heCI6IjA1QzFERkZGRkZGRkZDIn19LCJvcmRlckJ5SXRlbXMiOlt7Iml0ZW0iOiIyMDI0LTAzLTE2VDIzOjAwOjAwWiJ9XSwicmlkIjoiV2FrN0FQLVZ6eG9VUlFFQUFBQUFBQT09Iiwic2tpcENvdW50IjoxLCJmaWx0ZXIiOiJ0cnVlIn1d",
         ##  "ContinuationHash": "1973123800",

         url_cont = Fifa.search_matches_url( from: from, to: to, 
                                             count: count )
                                          
         ## (i) add continuationHash !!                                    
         url_cont += "&continuationhash=#{data['ContinuationHash']}"
         ## (ii) pluas continuationToken in headers !!                                   
         headers = {
             'x-mdp-continuation-token' => data['ContinuationToken'],
          }
                  
         data_cont = fetch_json( url_cont, outpath, 
                                 headers: headers )

         puts "  #{data_cont['Results'].size} match(es)"

         if data_cont['Results'].size == count   ## max. count  - more matches available
            puts "!! max count #{count} hit again"
            exit 1
         end   
      
         ## concat
         data_cont['Results'] = data['Results']+data_cont['Results']
         write_json_v2( outpath, data_cont )
      end
   end

   date += 1

   break      if date >= Date.new( year+1, 1, 1 )
end



end_time = Time.now
diff_in_secs = end_time - start_time

puts "diff_time:"
puts "   done in %d:%d min(s)" % [diff_in_secs/60, diff_in_secs%60]


puts "bye"