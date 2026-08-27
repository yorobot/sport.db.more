module Openliga




Match = Struct.new( :team1,
                    :team2,
                    :date,    # assumes Date class
                    :time,    # assumes String class (00:00)
                    :timezone,   ## use tz ?
             ###       :datetime_utc,
                    :score,
                    :round,    ## is stage/round/group
                    :city,
                    :ground,   ## use stadium (or venue?)
                    :att,     ## attendance (numberOfViewers)
                    :finished    ### todo/check - use status (is really only END or false)
                  ) do
end



end ## module Openliga
