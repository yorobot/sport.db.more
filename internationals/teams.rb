require 'cocos'


##
## 336 countries, territories & friends


### collect nati teams stats
###    number of matches, and years
###     first date, last date,


repo_dir = "/sports/more/international_results"



stats = {  }

recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
#=> 49329 record(s)
pp recs[0]



recs.each do |rec|
    date       = Date.strptime( rec['date'], '%Y-%m-%d')
    tournament = rec['tournament']

    [rec['home_team'],
     rec['away_team']].each do |team|

       stat = stats[team] ||= {  name:  team,
                                 years: [],
                                 count: 0,   ### match count
                                 tournaments: [],
                                 start_date: nil,
                                 end_date:   nil
                              }

        stat[:count] += 1
        stat[:years] << date.year         if !stat[:years].include?( date.year)
        stat[:tournaments] << tournament  if !stat[:tournaments].include?( tournament )

        stat[:start_date] = date    if stat[:start_date].nil? || date < stat[:start_date]
        stat[:end_date]   = date    if stat[:end_date].nil? || date > stat[:end_date]
    end
end

##
## pp stats

def pp_stats( stats )
  puts "   #{stats.size} record(s)"

  stats.each_with_index do |(name,h),i|
    puts "==="
    print " #{name}"
    if h[:years].size == 1
       print "   #{h[:years][0]}   - #{h[:years].size} year"
    else
       print "   #{h[:years][0]} to #{h[:years][-1]}  - #{h[:years].size} years"
    end
    print "\n"
    puts "        #{h[:count]} match(es) in #{h[:tournaments].size} tournament(s) incl."

    if h[:tournaments].size < 10
        pp h[:tournaments]
    else
        print "    " + h[:tournaments][0] +  " to " + h[:tournaments][-1]
        print "\n"
    end
  end


  puts "   #{stats.size} record(s)"
end




pp_stats( stats )


puts "bye"
