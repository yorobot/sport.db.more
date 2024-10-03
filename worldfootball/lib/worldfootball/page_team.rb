
module Worldfootball
  class Page

class Team < Page  ## note: use nested class for now - why? why not?

  def self.from_cache( slug )
    url  = Metal.team_url( slug )
    html = Webcache.read( url )
    new( html )
  end




######
## helpers

end # class Team

  end # class Page
end # module Worldfootball
