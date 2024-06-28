module Footballdata


def self.assert( cond, msg )
  if cond
    # do nothing
  else
    puts "!!! assert failed - #{msg}"
    exit 1
  end
end


def self.pp_matches( data )

  ## track match status and score duration  
  stats = { 'status'    => Hash.new(0),
            'duration'  => Hash.new(0),
            'stage'     => Hash.new(0),
            'group'     => Hash.new(0),
           }

  first = Date.strptime( data['resultSet']['first'], '%Y-%m-%d' ) 
  last  = Date.strptime( data['resultSet']['last'], '%Y-%m-%d' )

  diff = (last - first).to_i  # note - returns rational number (e.g. 30/1)


  print "==> #{data['competition']['name']}, "
  print "#{first.strftime('%a %b %d %Y')} - #{last.strftime('%a %b %d %Y')}"
  print " (#{diff}d)"
  print "\n"

  data['matches'].each do |rec|

    ## -- todo - make sure / assert it's always utc - how???
    ## utc   = ## tz_utc.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
    ##  note:  DateTime.strptime  is supposed to be unaware of timezones!!!
    ##            use to parse utc
    utc = DateTime.strptime( rec['utcDate'], '%Y-%m-%dT%H:%M:%SZ' ).to_time.utc 
    assert( utc.strftime( '%Y-%m-%dT%H:%M:%SZ' ) == rec['utcDate'], 'utc time mismatch' )

    status = rec['status']
     assert( %w[SCHEDULED
                TIMED
                FINISHED
                POSTPONED
                IN_PLAY
               ].include?( status ), "unknown status - #{status}" )

     stats['status'][status] += 1  ## track status

     print '%-10s' % status
     print utc.strftime( '%a %b %d %Y %H:%M')
     print ' '
     # print "#{rec['utcDate']} "

     team1 = rec['homeTeam']['name'] ?
                  "#{rec['homeTeam']['name']} (#{rec['homeTeam']['tla']})" : '?'
     team2 = rec['awayTeam']['name'] ?
                  "#{rec['awayTeam']['name']} (#{rec['awayTeam']['tla']})" : '?'     
     print '%22s' % team1
     print " - "
     print '%-22s' % team2
     print "   "

     stage = rec['stage']
     stats['stage'][stage] += 1  ## track stage

     group = rec['group']
     stats['group'][group] += 1  if group   ## track group

     print "#{rec['matchday']} - #{stage} "
     print "/ #{group}  "  if group
     print "\n"

     print "  "
     print '%-20s' % rec['score']['duration']
     print ' '*24
     
     score = String.new 

     duration = rec['score']['duration']
     assert( %w[REGULAR
                EXTRA_TIME
                PENALTY_SHOOTOUT
               ].include?( duration ), "unknown duration - #{duration}" )

     stats['duration'][duration] += 1  ## track duration

     if duration == 'PENALTY_SHOOTOUT'
        if rec['score']['extraTime'] 
          ## quick & dirty hack - calc et via regulartime+extratime 
          score << "#{rec['score']['penalties']['home']}-#{rec['score']['penalties']['away']} pen. "
          score << "#{rec['score']['regularTime']['home']+rec['score']['extraTime']['home']}"
          score << "-"
          score << "#{rec['score']['regularTime']['away']+rec['score']['extraTime']['away']}"
          score << " a.e.t. "
          score << "(#{rec['score']['regularTime']['home']}-#{rec['score']['regularTime']['away']},"
          score << "#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"
        else  ### south american-style (no extra time)
            ## quick & dirty hacke - calc ft via fullTime-penalties
            score << "#{rec['score']['penalties']['home']}-#{rec['score']['penalties']['away']} pen. "
            score << "(#{rec['score']['fullTime']['home']-rec['score']['penalties']['home']}"
            score << "-"
            score << "#{rec['score']['fullTime']['away']-rec['score']['penalties']['away']},"
            score << "#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"  
        end
     elsif  duration == 'EXTRA_TIME'
          score << "#{rec['score']['regularTime']['home']+rec['score']['extraTime']['home']}"
          score << "-"
          score << "#{rec['score']['regularTime']['away']+rec['score']['extraTime']['away']}"
          score << " a.e.t. "
          score << "(#{rec['score']['regularTime']['home']}-#{rec['score']['regularTime']['away']},"
          score << "#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"          
     elsif  duration == 'REGULAR'
          if rec['score']['fullTime']['home'] && rec['score']['fullTime']['away']
            score << "#{rec['score']['fullTime']['home']}-#{rec['score']['fullTime']['away']} "
            score << "(#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"
          end          
     else
        raise ArgumentError, "unexpected/unknown score duration #{rec['score']['duration']}"
     end
 

     print score
     print "\n"
  end

  print "   #{data['resultSet']['played']}/#{data['resultSet']['count']} matches"
  print "\n"

  print "     status (#{stats['status'].size}): "
  print  fmt_count( stats['status'], sort: true )
  print "\n"
  print "     duration (#{stats['duration'].size}): "
  print  fmt_count( stats['duration'], sort: true )
  print "\n"
  print "     stage (#{stats['stage'].size}): "
  print   fmt_count( stats['stage'] )
  print "\n"
  print "     group (#{stats['group'].size}): "
  print   fmt_count( stats['group'] )
  print "\n"
end


def self.fmt_count( h, sort: false )
    pairs = h.to_a
    if sort
        pairs = pairs.sort do |l,r|
                               res = r[1] <=> l[1]  ## bigger number first
                               res = l[0] <=> r[0] if res == 0
                               res
                            end
    end
    pairs = pairs.map { |name,count| "#{name} (#{count})" }
    pairs.join( ' · ' )                                                                 
end


end   # module Footballdata