

module Footballdata

  def self.schedule( league:, season: )
    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

    Metal.competition( LEAGUES[ league.downcase ], season.start_year )
  end

end  # module Footballdata