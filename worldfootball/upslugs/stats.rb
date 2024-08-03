##########
#  to run use:
#   $ ruby upslugs/stats.rb


##
#  generate slug stats


require_relative 'helper'



def calc_stats( slug )
 
   page = Worldfootball::Page::Schedule.from_cache( slug )

  ###
  ### todo/fix -   skip if file exists
  ##                  add overwrite/update/force option - why? why not?

   ## add more stats
   ##  dates: first, last !!!
   ##
   ## add league key e.g. eng.1, es.1 etc, - why? why not?

   matches = page.matches
   teams   = page.teams
   rounds  = page.rounds

   first = '9999-99-99'
   last  = '0000-00-00'
   matches.each do |m|
     if m[:date]
         first = m[:date ]  if m[:date] < first
         last  = m[:date]   if m[:date] > last
     end
   end


   data = { 'title' => page.title.sub('» Spielplan', '').strip,
                     ## add season (text) - why? why not?
                     'match_count' => matches.size,
                     'team_count'  =>  teams.size,
                     'round_count' => rounds.size,  
                     'dates' => { 'first' => first, 
                                  'last' =>  last }
           }
         
  data
end # method calc_stats




paths = Dir.glob( './slugs/**/*.csv' )
paths[0,5].each_with_index do |path,i|
  basename = File.basename( path, File.extname( path ))

  league = basename

  puts "==> [#{i+1}/#{paths.size}]  #{league}"
  recs = read_csv( path )
  puts "  #{recs.size} record(s)"

  stats_rows = []

  recs.each_with_index do |rec,i|
    slug = rec['slug']
    puts "#{league} [#{i+1}/#{recs.size}] >#{slug}<"
    
     stats = calc_stats( slug )

     ### assert 
     ## season_text is same as end of page title - why? why not?
     slug_text = rec['season']
     if !stats['title'].end_with?( slug_text )
        puts "  !! ASSERT - page title differs from season (selection) text"
        pp stats['title']
        pp slug_text
        exit 1
     end

     ## note - all values MUST be strings (thus, convert nums to str)
     stats_rows << [
                   stats['match_count'].to_s,
                   stats['team_count'].to_s,
                   stats['round_count'].to_s,
                   stats['dates']['first'],
                   stats['dates']['last'],
                   stats['title'],
                   slug
                 ]
  end


  headers = ['matches', 'teams', 'rounds',
             'date_first', 'date_last',
             'title', 'slug',
            ]
  pp stats_rows

  write_csv( "./slugs.stats/#{basename}.csv" , 
               stats_rows, 
               headers: headers )
end


puts "bye"


