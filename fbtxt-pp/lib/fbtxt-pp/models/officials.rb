
###
#  officials  (referees)


class Official

  def self.build( h )
     new(
           name:        h['name'],
           country:     h['country'],
           type:        h['type']
     )
  end

  attr_reader :name, :country,
              :type

  def initialize( name:,
                  country: nil,
                  type:    nil )
     @name    = name
     @country = country
     @type    = type
  end
end  ## class Official
