

module Fbgen


class Job     ## todo/check: use a module (NOT a class) - why? why not?
  ## note - source expected module/class e.g. Footballdata/Worldfootball e.g.    
def self.download( datasets, source: )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "downloading [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      source.schedule( league: league,
                       season: season )
    end
  end
end

def self.convert( datasets, source: )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "converting [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      source.convert( league: league,
                      season: season )
    end
  end
end
end  # class Job


## change download? to cache - true/false - why? why not?   
##  change push: to sync - true/false - why? why not?
def self.process( datasets,
                     source:,
                     download: false,
                     push:     false )

  Job.download( datasets, source: source )   if download

  ## always pull before push!! (use fast_forward)
  gh = SportDb::GitHubSync.new( datasets )
  gh.git_fast_forward_if_clean    if push


  Job.convert( datasets, source: source )

  if push
    Writer.config.out_dir = SportDb::GitHubSync.root   # e.g. "/sports/openfootball"
  else
    ##  fix/fix - use default - do not (re)set here - why? why not?
    Writer.config.out_dir = './tmp'
  end

  Writer::Job.write( datasets,
                     source: source.config.convert.out_dir )

  ## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
  gh.git_push_if_changes     if push
end  

end  # module Fbgen