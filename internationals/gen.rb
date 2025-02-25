require 'cocos'
require 'alphabets'


# root_dir = "/sports/openfootball/internationals"
root_dir = "./o"


repo_dir = "/sports/more/international_results"


def slugify( str )
   str = unaccent( str )   
   ## replace space with underscore
   str = str.gsub( ' ', '_' )
   str = str.downcase
   ## remove all BUT a-z, 0-9, _-
   str = str.gsub( /[^a-z0-9_-]/, '' )
   str 
end



## build index for shootouts
recs = read_csv( "#{repo_dir}/shootouts.csv ")
puts "  #{recs.size} record(s)"
pp recs[0]

shootouts = {}    ## index by date/home_team/away_team
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    shootouts[key] = rec
end


recs = read_csv( "#{repo_dir}/goalscorers.csv ")
puts "  #{recs.size} record(s)"
pp recs[0]

goals = {}
recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
    by_match = goals[key] ||= []
    by_match <<  rec
end




recs = read_csv( "#{repo_dir}/results.csv" )
puts "  #{recs.size} record(s)"
pp recs[0]

recs_by_year = {}   ## and tournament


recs.each do |rec|
   date = Date.strptime( rec['date'], '%Y-%m-%d')  
 
   ## tournament plus year
   title = "#{} #{date.year}"

   by_year = recs_by_year[date.year] ||= {}
   matches = by_year[rec['tournament']] ||= []

   matches << rec
end



def _build_goal( rec )

    if rec['scorer'].nil? || rec['scorer'].empty?
        puts "!! WARN - (goals) scorer empty:"
        pp rec
        rec['scorer'] = 'N.N.'    ## note - use N.N. NOT ?? for n/a
        ## raise ArgumentError, "scorer empty"
    end

    if  rec['minute'].nil? || rec['minute'].empty?
        puts "!! WARN - (goals) minute empty:"
        pp rec
        ## use '??'
        rec['minute'] = '??'
        ## raise ArgumentError, "minute empty"
    end

    buf = String.new
    buf << rec['scorer']
    buf << " #{rec['minute']}'"
    buf << " (o.g.)"   if rec['own_goal'] == 'TRUE'
    buf << " (pen.)"   if rec['penalty'] == 'TRUE'
    buf
end

def build_goals( recs )
  ## split into goals1 and goals2
    #  date,home_team,away_team,team,scorer,minute,own_goal,penalty

    goals1 = []
    goals2 = []
    recs.each do |rec|
        if rec['home_team'] == rec['team']
            goals1 << rec
        elsif rec['away_team'] == rec['team']
            goals2 << rec
        else
            pp rec
            raise ArgumentError, "unknown team for match"
        end
    end


    buf = String.new
    if goals1.size == 0
        buf << "     -; "
        buf << goals2.map {|rec| _build_goal(rec) }.join(' ')
        buf << "\n"
    else    ## split over two lines - why? why not?
        buf << "     "
        buf << goals1.map {|rec| _build_goal(rec) }.join(' ')
        if goals2.size == 0
            buf << "\n"
        else
          buf << ";\n"
          buf << "     "
          buf << goals2.map {|rec| _build_goal(rec) }.join(' ')
          buf << "\n"
        end
    end
    
    buf
end


def calc_stats( matches )
  stats = {  'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }

  matches.each do |rec|
      date = Date.strptime( rec['date'], '%Y-%m-%d' )
          
       stats['date']['start_date'] ||= date
       stats['date']['end_date']   ||= date

       stats['date']['start_date'] = date  if date < stats['date']['start_date']
       stats['date']['end_date']   = date  if date > stats['date']['end_date']
      

     [rec['home_team'], rec['away_team']].each do |team|
        stats['teams'][ team ] += 1   
     end
  end

  stats
end





recs_by_year.each do |year, tournaments|
    tournaments.each do |tournament, matches|

       buf = String.new
       buf << "= #{tournament} #{year}\n"

       ## add stats if more than one match 
       if matches.size > 1
         stats = calc_stats( matches )

         buf << "\n"
         buf << "# Date       "
         start_date = stats['date']['start_date']
         end_date   = stats['date']['end_date']
         if start_date.year != end_date.year
           buf << "#{start_date.strftime('%a %b/%-d %Y')} - #{end_date.strftime('%a %b/%-d %Y')}"
         else
           buf << "#{start_date.strftime('%a %b/%-d')} - #{end_date.strftime('%a %b/%-d %Y')}"
         end
         buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
         buf << "\n"
       
         buf << "# Teams      #{stats['teams'].size}\n"
         buf << "# Matches    #{matches.size}\n"
       end

       buf << "\n"

       last_date = nil
       matches.each do |rec|
         match = "#{rec['home_team']} - #{rec['away_team']}"
         score = "#{rec['home_score']}-#{rec['away_score']}"
     
         geo   = "#{rec['city']}, #{rec['country']}"
         # if neutral  add (*) to geo
         #  geo   += " (*)"  if rec['neutral'] == 'TRUE'     
     
         date = Date.strptime( rec['date'], '%Y-%m-%d')  
         buf <<  "[#{date.strftime('%a %b %-d')}]\n"   if date != last_date
         buf << "  #{match}  #{score}   @ #{geo}"

         ## check for win on penalities
         key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
         shootout = shootouts[key]
         if shootout
            buf << "   [#{shootout['winner']} wins on penalties]"
         end
         buf << "\n"


         goal_recs = goals[key]
         if goal_recs
            buf << build_goals( goal_recs )
         end

         last_date = date
       end
       buf << "\n"

       slug = slugify( tournament)
       path = "#{root_dir}/#{slug}/#{year}_#{slug}.txt"
       write_text( path, buf )
    end  # each tournament
end   # each year



puts "bye"



###
##  generate INDEX.md
##     generate index by year
##    year
##       tournaments (matches)     #  teams, from to)