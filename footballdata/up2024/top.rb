require_relative 'helper'   ## (shared) boot helper



SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"




########
# helper
#   normalize team names
  def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)

     ## todo/fix
     ##    if no time  (assume 0:00 for now)

      res =   l.date <=> r.date
      res =   (l.time ? l.time : '0:00') <=> (r.time ? r.time : '0:00')    if res == 0
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "   normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       if match.team1 != team1.name
          stat = stats[ match.team1 ] ||= Hash.new(0)
          stat[ team1.name ] += 1
       end   

       if match.team2 != team2.name
          stat = stats[ match.team2 ] ||= Hash.new(0)
          stat[ team2.name ] += 1
       end
   
       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
   
    if stats.size > 0
      pp stats
    end

    print "norm OK\n"

    matches
  end




DATASETS = [
 # ['eng.2',   %w[2023/24 2022/23 2021/22 2020/21]],
 ['nl.1', %w[2023/24 2022/23 2021/22 2020/21]],
 ['pt.1', %w[2023/24 2022/23 2021/22 2020/21]],
 ['br.1', %w[2024 2023 2022 2021 2020]],
]


=begin
DATASETS = [
  ['eng.1',   %w[2023/24]],

  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],
]
=end

pp DATASETS


repos  = find_repos( DATASETS )
pp repos


OPTS = {
   # push: true
}


## always pull before push!! (use fast_forward)
git_fast_forward_if_clean( repos )  if OPTS[:push]


outdir = if OPTS[:push]
             "/sports/openfootball"
         else
             "./tmp"
         end

source_dir = '../../../stage'


datasets = DATASETS
datasets.each_with_index do |(league_key, seasons),i|
 
  league = Writer::LEAGUES[ league_key ]
 
  seasons.each_with_index do |season,j|
    season = Season( season )   ## convert to Season obj

    lang     = league[:lang] || 'en'
    path     = league[:path]
  
    ## note: basename && name might be dynamic, that is, procs!!! (pass in season)
    basename =  league[:basename]
    basename =  basename.call( season )  if basename.is_a?(Proc)
    name     =  league[:name] 
    name     =  name.call( season )      if name.is_a?(Proc)
  
    matches = SportDb::CsvMatchParser.read( 
                 "#{source_dir}/#{season.to_path}/#{league_key}.csv" )

    puts "==> [#{i+1}/#{datasets.size}]  #{name} #{season.key} [#{j+1}/#{seasons.size}]  -  #{matches.size} match(es)..."

    # puts
    # pp matches[0]
    # puts
    # pp matches[-1]
             
    matches = normalize( matches, league: league_key )
           
    outpath = "#{outdir}/#{path}/#{season.to_path}/#{basename}.txt"
    puts "   writing to #{outpath}"
    puts "      name: #{name} #{season.key}"
    puts "      lang: #{lang}"
    SportDb::TxtMatchWriter.write( outpath, 
                                   matches,
                                   name: "#{name} #{season.key}",
                                   lang:  lang ) 
  end
end



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
git_push_if_changes( repos )    if OPTS[:push]


puts "bye"

