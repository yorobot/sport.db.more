require 'cocos'
require 'alphabets'


require_relative 'gen/base'

##
## 336 countries, territories & friends


### collect nati teams stats
###    number of matches, and years
###     first date, last date,


repo_dir = "/sports/more/international_results"



recs = read_csv( "./former_names.csv")
puts "  #{recs.size} record(s)"
## pp recs

recs_by_country = {}
recs.each do  |rec|
    by_country = recs_by_country[rec['current']] ||= []
    by_country << rec
end


##
##  read our own list of top-level/major tournaments
recs = read_csv( "./tournaments.csv" )
puts "  #{recs.size} tournament record(s)"

## lookup by names
TOP_TOURNAMENTS = recs.map { |rec| rec['name'] }




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
                                 tournaments: {}
                              }

        stat[:count] += 1
        stat[:years] << date.year         if !stat[:years].include?( date.year)

        stat_tour = stat[:tournaments][tournament] ||= { name: tournament,
                                                         years: [],
                                                         count: 0    ### match count
                                                       }
        stat_tour[:count] += 1
        stat_tour[:years] << date.year     if !stat_tour[:years].include?( date.year)
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
        print "    " + h[:tournaments].keys[0] +  " to " + h[:tournaments].keys[-1]
        print "\n"
    end
  end


  puts "   #{stats.size} record(s)"
end



def _linkify_tour( tournament, year: )

   slug    = slugify( tournament )
   ##  note - add/file "minor" tournaments under "more"
   path =  if TOP_TOURNAMENTS.include?( tournament )
               "#{slug}/#{year}_#{slug}.txt"
           else
               "more/#{slug}/#{year}_#{slug}.txt"
           end
end

def linkify_tour_years( tournament, years: )
   years.map do |year|
          link = _linkify_tour( tournament, year: year )
          "[#{year}](#{link})"
   end
end




def build_stats( stats, history: )
  puts "   #{stats.size} record(s)"


  buf = String.new
  buf << "# Teams (By First Appearance/Year)\n"
  buf << "\n"


  stats.keys.sort.each_with_index do |name,i|
     buf << " · \n"  if i != 0

     h = stats[name]

     tooltip = "#{h[:count]} match(es) in #{h[:tournaments].size} tournament(s)"

     ## note - use quick slugify_markdownstyle!!
     slug = slugify_markdown( name )

     buf << %Q{[#{name}](##{slug} "#{tooltip}")}
  end
  buf << "\n\n"




  stats.each_with_index do |(name,h),i|
    buf << "## #{name}\n"

    if h[:years].size == 1
       buf << "#{h[:years][0]}   - #{h[:years].size} year"
    else
       buf << "#{h[:years][0]} to #{h[:years][-1]}  - #{h[:years].size} years"
    end
    buf << "<br>\n"

    if history[name]
        renames = history[name]
        buf << "also known as "
        renames.each_with_index do |rec,i|
           buf << "**#{rec['former']}**"
           buf << " (#{rec['start_date']} - #{rec['end_date']}) => "
        end
        buf << "**#{name}**"
        buf << "<br>\n"
    end


    buf << "<details><summary>"
    buf << "#{h[:count]} match(es) in #{h[:tournaments].size} tournament(s)"
    buf << "</summary>\n\n"

    h[:tournaments].each_with_index do |(_, tour),j|
        buf << "- #{tour[:name]} "
        year_count  = tour[:years].size
        match_count = tour[:count]
        buf <<  if j == 0
                      "(#{year_count} #{year_count == 1 ? 'year' : 'years'}/" +
                       "#{match_count} #{match_count == 1 ? 'match' : 'matches'})"
                else
                      "(#{year_count}/#{match_count})"
                end

         if year_count <= 12
            buf << " " + linkify_tour_years(tour[:name], years: tour[:years]).join( ' ' )
         else
            buf << " " + linkify_tour_years(tour[:name], years: tour[:years][0,3]).join( ' ' ) +
                   " ... " + linkify_tour_years(tour[:name], years: tour[:years][-3,3]).join( ' ' )
         end

        buf << "\n"
    end

    buf << "\n</details>\n\n"
  end

  buf
end


pp_stats( stats )



buf = build_stats( stats, history: recs_by_country )


## write both
outdir = "./tmp"
write_text( "#{outdir}/TEAMS.md", buf )

outdir = "/sports/openfootball/internationals"
write_text( "#{outdir}/TEAMS.md", buf )


puts "bye"
