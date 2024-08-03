##########
#  to run use:
#   $ ruby upslugs/export.rb


##
#  export slug pages to json


require_relative 'helper'



def export( slug, league: )
 
    ## note - use league (code/key) as directory
    path = "/sports/cache.wfb.slugs/#{league}/#{slug}.json"

  ## check if cached
   if File.exist?( path )
      puts "  OK  #{slug}  -  cache"
      return
   end

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


   data = {  page: { title: page.title.sub('» Spielplan', '').strip,
                     slug: slug,
                     ## add season (text) - why? why not?
                     match_count: matches.size,
                     team_count:  teams.size,
                     rounds_count: rounds.size,
                     dates: { first: first, 
                              last:  last }
                      },
             matches: matches,
             teams:   teams,
             rounds:  rounds,         
          }

  puts "#{slug} -- #{matches.size} match(es)"
   write_json( path, data )
end # method export




paths = Dir.glob( './slugs/**/*.csv' )
paths.each_with_index do |path,i|
  basename = File.basename( path, File.extname( path ))

  league = basename

  puts "==> [#{i+1}/#{paths.size}]  #{league}"
  recs = read_csv( path )
  puts "  #{recs.size} record(s)"

  recs.each_with_index do |rec,i|
    slug = rec['slug']
    puts "#{league} [#{i+1}/#{recs.size}] >#{slug}<"
    export( slug, league: league )
  end
end

puts "bye"
