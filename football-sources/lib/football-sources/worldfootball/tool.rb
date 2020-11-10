

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




class Tool
  def initialize( includes: nil,
                  excludes: nil )
    ## quick fix: move/handle empty array upstream!!!!
    includes = nil   if includes.is_a?(Array) && includes.empty?

    @includes = includes
    @excludes = excludes
  end



  def download( datasets )
    datasets.each do |dataset|
      league   = dataset[0]
      seasons  = dataset[1]

      with_filter( league ) do
        seasons.each do |season|
          puts "downloading #{league} #{season}..."

          Worldfootball.schedule( league: league,
                                  season: season )
        end
      end
    end
  end

  def convert( datasets )
    datasets.each do |dataset|
      league   = dataset[0]
      seasons  = dataset[1]

      with_filter( league ) do
        seasons.each do |season|
           Worldfootball.convert( league: league,
                                  season: season,
                                  offset: OFFSETS[ league ] )
        end
      end
    end
  end


#########################################
# more helpers
  def with_filter( league, &blk )
    return  if @excludes && @excludes.find { |q| league.start_with?( q.downcase ) }
    return  if @includes && @includes.find { |q| league.start_with?( q.downcase ) }.nil?
    blk.call()
  end

end # class Tool
end # module Worldfootball


