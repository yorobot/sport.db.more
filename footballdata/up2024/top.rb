require_relative 'helper'   ## (shared) boot helper

$LOAD_PATH.unshift( '../lib' )
require 'footballdata'



SportDb::Import.config.catalog_path = '../../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
CatalogDb::Metal.tables


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
 
    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "   normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       league: league )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       league: league )

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



require_relative 'config'   ## shared config (prepare+top)


datasets = DATASETS_MORE + DATASETS_TOP
# datasets = DATASETS_TOP
pp datasets


repos  = find_repos( datasets )
pp repos



OPTS = {
   push: true
}


## always pull before push!! (use fast_forward)
git_fast_forward_if_clean( repos )  if OPTS[:push]


outdir = if OPTS[:push]
             "/sports/openfootball"
         else
             "./tmp"
         end


source_dir = Footballdata.config.convert.out_dir
         

datasets.each_with_index do |(league_key, seasons),i|
 
  league = Writer::LEAGUES[ league_key ]
 
  seasons.each_with_index do |season,j|
    season = Season( season )   ## convert to Season obj

    lang     =  'en'  ## always use english !!!!
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

