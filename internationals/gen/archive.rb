
##
## find a better name -  Matchbook? or such - why? why not?
class Archive


def initialize( history: nil )
  @matches = {}    ## key/index by date/team1/team2
  @by_year = {}    ## lookup by year AND tournament

  @name_history  =   if history
                       NameHistoryLookup.new( history )
                     else
                       nil
                     end
end

def matches_by_year() @by_year; end



def add_matches( recs )
  puts "  #{recs.size} match record(s)"
  pp recs[0]


  recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"

    ## note - convert date string to date obj
    date = Date.strptime( rec['date'], '%Y-%m-%d')
    rec['date'] = date

    if @name_history
       home_team =  rec['home_team']
       away_team =  rec['away_team']

       home_team = @name_history.historic_name_by_date( home_team, date: date )
       away_team = @name_history.historic_name_by_date( away_team, date: date )

       rec['home_team'] = home_team
       rec['away_team'] = away_team
    end



    if @matches.has_key?( key )
        puts "!! WARN - duplicate matches (date/team1/team2):"
        pp @matches[key]
        pp rec

        ## quick hack - turn into array for weirdo (duplicate) records
        @matches[key] = [@matches[key]]    if @matches[key].is_a?( Hash )
        @matches[key]  << rec
    else
      @matches[key] = rec
    end

    ## index/group by year AND tournament too
     by_year = @by_year[ date.year] ||= {}
     matches = by_year[rec['tournament']] ||= []
     ## note - auto-add original ord(er) number
     rec['ord'] = (matches.size+1)
     matches << rec
  end
end



def add_shootouts( recs )
  puts "  #{recs.size} shootout record(s)"
  pp recs[0]

  recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"

    match = @matches[ key ]

    if match
      if @name_history
         winner =  rec['winner']
         winner  = @name_history.historic_name_by_date( winner, date: match['date'] )
         rec['winner'] = winner
      end

      ## add shootout record as (nested )"sub" record
      ##   remove date/home_team/away_team - why? why not?
      match['shootout'] = rec
    else
        puts "!! WARN - no match (date/team1/team2) found for shootout record:"
        pp rec
    end
  end
end



def add_goalscorers( recs )
  puts "  #{recs.size} goalscorer record(s)"
  pp recs[0]

  ## step 1 - fold/collect all goals for one match into an array
  matches = {}
  recs.each do |rec|
     key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"
     by_match = matches[key] ||= []
     ##   remove date/home_team/away_team - why? why not?
     by_match <<  rec
  end

  ## step 2 - add goals
  matches.each do |key,goals|
    match = @matches[ key ]

    if match
      ## add goal records as (nested )"sub" record
      match['goals'] = goals
    else
        puts "!! WARN - no match (date/team1/team2) found for goal records:"
        pp goals
    end
  end
end


def add_stages( recs )
  puts "  #{recs.size} stages record(s)"
  pp recs[0]

  recs.each do |rec|
    key = "#{rec['date']}/#{rec['home_team']}/#{rec['away_team']}"

    match = @matches[key]

    if match
      ## add stage as record as (nested )"sub" record
      ##   remove date/home_team/away_team - why? why not?
      match['stage'] = rec
    else
        puts "!! WARN - no match (date/team1/team2) found for stage record:"
        pp rec
    end
  end


  ##
  ## try sort by stage (groups only)
  @by_year.each do |year, tournaments|
    tournaments.each do |tournament, matches|
        tournaments[tournament] = matches.sort do |l,r|
                lstage =   (l['stage']||{}) ['stage']
                rstage =   (r['stage']||{}) ['stage']

                if (lstage && rstage) &&
                   (lstage.include?('Group') && rstage.include?('Group'))
                    res = lstage <=> rstage
                    res = l['date'] <=> r['date']   if res == 0
                    res
                else ## keep as is
                    l['ord'] <=> r['ord']
                end
        end
    end
  end
end


end  # class Archive
