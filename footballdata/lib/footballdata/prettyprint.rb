module Footballdata


def self.assert( cond, msg )
  if cond
    # do nothing
  else
    puts "!!! assert failed - #{msg}"
    exit 1
  end
end

def self.fmt_competition( rec )
   buf = String.new

   buf << "==> "
   buf << "#{rec['competition']['name']} (#{rec['competition']['code']}) -- "
   buf << "#{rec['area']['name']} (#{rec['area']['code']}) "
   buf << "#{rec['competition']['type']} "
   buf << "#{rec['season']['startDate']} - #{rec['season']['endDate']} "
   buf << "@ #{rec['season']['currentMatchday']}"
   buf << "\n"

   buf
end

def self.fmt_match( rec )
   buf = String.new

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

     buf << '%-10s' % status
     buf << utc.strftime( '%a %b %d %Y %H:%M')
     buf << ' '
     # pp rec['utcDate']

     team1 = rec['homeTeam']['name'] ?
                  "#{rec['homeTeam']['name']} (#{rec['homeTeam']['tla']})" : '?'
     team2 = rec['awayTeam']['name'] ?
                  "#{rec['awayTeam']['name']} (#{rec['awayTeam']['tla']})" : '?'
     buf << '%22s' % team1
     buf << " - "
     buf << '%-22s' % team2
     buf << "   "

     stage = rec['stage']
     group = rec['group']

     buf << "#{rec['matchday']} - #{stage} "
     buf << "/ #{group}  "  if group
     buf << "\n"

     buf << "  "
     buf << '%-20s' % rec['score']['duration']
     buf << ' '*24

     duration = rec['score']['duration']
     assert( %w[REGULAR
                EXTRA_TIME
                PENALTY_SHOOTOUT
               ].include?( duration ), "unknown duration - #{duration}" )


     ft, ht, et, pen = convert_score( rec['score'] )
     score = String.new
     if !pen.empty?
       if et.empty? ### south american-style (no extra time)
         score << "#{pen} pen. "
         score << "(#{ft}, #{ht})"
       else
         score << "#{pen} pen. "
         score << "#{et} a.e.t. "
         score << "(#{ft}, #{ht})"
      end
     elsif !et.empty?
       score << "#{et} a.e.t. "
       score << "(#{ft}, #{ht})"
     else
       score << "#{ft} (#{ht})"
     end

     buf << score
     buf << "\n"
     buf
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

    print fmt_match( rec )

    ## track stats
    status = rec['status']
    stats['status'][status] += 1

    stage = rec['stage']
    stats['stage'][stage] += 1

     group = rec['group']
     stats['group'][group] += 1  if group

     duration = rec['score']['duration']
     stats['duration'][duration] += 1
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