

def build_goal( h )

    ## split into minute
    ##  and offset (stoppage/injury time)
    ##  e.g. 90'+11'

     minute  = h['minute']
     offset  = h['offset']
     owngoal = h['og']   # true|false
     penalty = h['pen']  # true|false


    rec = {
             name:     h['name'],
             minute:    minute,
          }

     rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)
     rec[ :og]     = owngoal  if owngoal
     rec[ :pen]    = penalty  if penalty

     rec
end


def build_goals( recs  )
    recs = recs.map  { |h| build_goal( h ) }

=begin
    ## sort by minutes
    ##  may not be sorted

    recs = recs.sort do |l,r|
                 res = l[:minute] <=> r[:minute]
                 res = (l[:offset]||0) <=> (r[:offset]||0)  if res == 0 &&
                                                              (l[:minute] == 45 ||
                                                               l[:minute] == 90 ||
                                                               l[:minute] == 105 ||  ## check - if possible stoppage in 1st half extra-time??
                                                               l[:minute] == 120)
                 res
           end
=end
    recs
end
