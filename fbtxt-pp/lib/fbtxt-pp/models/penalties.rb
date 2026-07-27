

class Penalty
  def self.build( h )

    new( name:   h['name'],
         scored: h['scored'],   ## true|false  for now only
         score:  h['score'],
         team:   h['team']     ## 1|2
         )
  end


  attr_reader :name,
              :scored, :score, :team

  def initialize( name:,
                  scored:, score:,
                  team:  )
    @name     = name
    @scored   = scored
    @score    = score   ## maybe allow empty score - why? why not?

    @team     = team
  end

  def scored?() @scored; end

end # class Penalty
