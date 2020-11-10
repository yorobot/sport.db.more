module Footballdata

class Stat      ## rename to match stat or something why? why not?
  def initialize
    @data = {}
  end

  def [](key) @data[ key ]; end

  def update( match )
     ## keep track of some statistics
     stat = @data[:all] ||= { stage:    Hash.new( 0 ),
                              duration: Hash.new( 0 ),
                              status:   Hash.new( 0 ),
                              group:    Hash.new( 0 ),
                              matchday: Hash.new( 0 ),

                              matches:  0,
                              goals:    0,
                            }

     stat[:stage][ match['stage'] ]   += 1
     stat[:group][ match['group'] ]  += 1
     stat[:status][ match['status'] ]  += 1
     stat[:matchday][ match['matchday'] ]  += 1

     score = match['score']

     stat[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR

     stat[:matches] += 1
     stat[:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
     stat[:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']


     stage_key = match['stage'].downcase.to_sym  # e.g. :regular_season
     stat = @data[ stage_key ] ||= { duration: Hash.new( 0 ),
                                     status:   Hash.new( 0 ),
                                     group:    Hash.new( 0 ),
                                     matchday: Hash.new( 0 ),

                                     matches:  0,
                                     goals:    0,
                                  }
     stat[:group][ match['group'] ]  += 1
     stat[:status][ match['status'] ]  += 1
     stat[:matchday][ match['matchday'] ]  += 1

     stat[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR

     stat[:matches] += 1
     stat[:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
     stat[:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']
  end
end  # class Stat
end  # module Footballdata



