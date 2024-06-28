require_relative 'helper'


# url = Footballdata::Metal.competition_matches_url( 'EC', 2024 )
url = Footballdata::Metal.competition_matches_url( 'EC', 2021 )
pp url
#=> "http://api.football-data.org/v4/competitions/EC/matches?season=2024"


data = Webcache.read_json( url )
pp data

def pp_matches( data )

  print "==> #{data['competition']['name']} - "
  print "#{data['resultSet']['played']}/#{data['resultSet']['count']} matches, "
  print "#{data['resultSet']['first']} - #{data['resultSet']['last']}"
  print "\n"

  data['matches'].each do |rec|

     print '%-10s' % rec['status']
     print "#{rec['utcDate']} "

     team1 = rec['homeTeam']['name'] ?
                  "#{rec['homeTeam']['name']} (#{rec['homeTeam']['tla']})" : '?'
     team2 = rec['awayTeam']['name'] ?
                  "#{rec['awayTeam']['name']} (#{rec['awayTeam']['tla']})" : '?'     
     print '%22s' % team1
     print " - "
     print '%-22s' % team2
     print "   "
     print "#{rec['matchday']} - #{rec['stage']} "
     print "/ #{rec['group']}  "  if rec['group']
     print "\n"

     print "  "
     print '%-20s' % rec['score']['duration']
     print ' '*24
     
     score = String.new 


     if rec['score']['duration'] == 'PENALTY_SHOOTOUT'
        score << "#{rec['score']['penalties']['home']}-#{rec['score']['penalties']['away']} pen. "
        score << "#{rec['score']['regularTime']['home']+rec['score']['extraTime']['home']}"
        score << "-"
        score << "#{rec['score']['regularTime']['away']+rec['score']['extraTime']['away']}"
        score << " a.e.t. "
        score << "(#{rec['score']['regularTime']['home']}-#{rec['score']['regularTime']['away']},"
        score << "#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"
     elsif  rec['score']['duration'] == 'EXTRA_TIME'
          score << "#{rec['score']['regularTime']['home']+rec['score']['extraTime']['home']}"
          score << "-"
          score << "#{rec['score']['regularTime']['away']+rec['score']['extraTime']['away']}"
          score << " a.e.t. "
          score << "(#{rec['score']['regularTime']['home']}-#{rec['score']['regularTime']['away']},"
          score << "#{rec['score']['halfTime']['home']}-#{rec['score']['halfTime']['away']})"          
     elsif  rec['score']['duration'] == 'REGULAR'
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
end


pp_matches( data )

puts "bye"

