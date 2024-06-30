

module Worldfootball
################################
# add more helpers
#  move upstream for (re)use - why? why not?

## todo/check: what to do: if league is both included and excluded?
##   include forces include? or exclude has the last word? - why? why not?
##  Excludes match before includes,
##   meaning that something that has been excluded cannot be included again

## todo - find "proper/classic" timezone ("winter time")

##  Brasilia - Distrito Federal, Brasil  (GMT-3)  -- summer time?
##  Ciudad de México, CDMX, México       (GMT-5)  -- summer time?
##  Londres, Reino Unido (GMT+1)
##   Madrid -- ?
##   Lisboa -- ?
##   Moskow -- ?
##
## todo/check - quick fix timezone offsets for leagues for now
##   - find something better - why? why not?
## note: assume time is in GMT+1
OFFSETS = {
  'eng.1' => -1,
  'eng.2' => -1,
  'eng.3' => -1,
  'eng.4' => -1,
  'eng.5' => -1,

  'es.1'  => -1,
  'es.2'  => -1,

  'pt.1'  => -1,
  'pt.2'  => -1,

  'br.1'  => -5,
  'mx.1'  => -7,
}



class Job     ## todo/check: use a module (NOT a class) - why? why not?
def self.download( datasets )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "downloading [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      Worldfootball.schedule( league: league,
                              season: season )
    end
  end
end

def self.convert( datasets )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "converting [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      Worldfootball.convert( league: league,
                             season: season,
                             offset: OFFSETS[ league ] )
    end
  end
end
end  # class Job

end # module Worldfootball

