
require_relative 'helper'


## try status api call
## pp ApiFootball::Metal.status


## pp ApiFootball::Metal.leagues
## pp ApiFootball::Metal.venues

=begin
 "league": {
        "id": 218,
        "name": "Bundesliga",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/218.png"
      },
      "country": {
        "name": "Austria",
        "code": "AT",
        "flag": "https://media.api-sports.io/flags/at.svg"
      },
     
=end
## e.g. 2024/25 => 2024 (MUST use start year of season)
AT1 = 218 

# pp ApiFootball::Metal.fixtures( league: AT1, season: 2023 )

=begin
"league": {
    "id": 2,
    "name": "UEFA Champions League",
    "type": "Cup",
    "logo": "https://media.api-sports.io/football/leagues/2.png"
  },
  "country": {
    "name": "World",
=end

## Free plans do not have access to this season, try from 2021 to 2023
## CL = 2
## pp ApiFootball::Metal.fixtures( league: CL, season: 2023 )

=begin
        "id": 13,
        "name": "CONMEBOL Libertadores",
        "type": "Cup",
        "logo": "https://media.api-sports.io/football/leagues/13.png"
      },
      "country": {
        "name": "World",
=end

##
## "Free plans do not have access to this season, try from 2021 to 2023."}

# LIBERTADORES = 13
# pp ApiFootball::Metal.fixtures( league: LIBERTADORES, season: 2023 )

## Free plans do not have access to this season, try from 2021 to 2023.

=begin
        "id": 262,
        "name": "Liga MX",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/262.png"
      },
      "country": {
        "name": "Mexico",
        "code": "MX",

=end

# MX1 = 262
# pp ApiFootball::Metal.fixtures( league: MX1, season: 2023 )

=begin
       "id": 144,
        "name": "Jupiler Pro League",
        "type": "League",
        "logo": "https://media.api-sports.io/football/leagues/144.png"
      },
      "country": {
        "name": "Belgium",
=end
## BE1 = 144
## pp ApiFootball::Metal.fixtures( league: BE1, season: 2023 )

## pp ApiFootball.fixtures( league: 'world', season: '2022' )


def build_score( data )
=begin
"score"=>
     {"halftime"=>{"home"=>0, "away"=>0},
      "fulltime"=>{"home"=>1, "away"=>0},
      "extratime"=>{"home"=>nil, "away"=>nil},
      "penalty"=>{"home"=>nil, "away"=>nil}}}]}
=end
 
     ht = [data['halftime']['home'],
           data['halftime']['away']
          ]
     ft = [data['fulltime']['home'],
           data['fulltime']['away']
          ]
     et = [data['extratime']['home'],
           data['extratime']['away']
          ]
     pen = [data['penalty']['home'],
            data['penalty']['away']
           ]


##
##  pass in status and check elapsed e.g. 90 or 120???

     if pen[0] && pen[1]
         buf = "#{pen[0]}-#{pen[1]} pen "

         if et[0] && et[1]
           buf << "(#{et[0]+ft[0]}-#{et[1]+ft[1]}, #{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         else  ## no extra time
           buf << "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
         end
         buf
     elsif et[0] && et[1]
         "#{et[0]+ft[0]}-#{et[1]+ft[1]} aet " +
         "(#{ft[0]}-#{ft[1]}, #{ht[0]}-#{ht[1]})"
     else 
         "#{ft[0]}-#{ft[1]} (#{ht[0]}-#{ht[1]})"
     end 
end


=begin
### parse time utc time
###     
"timezone": "UTC",
        "date": "2023-06-18T18:45:00+00:00",
        "timestamp": 1687113900,
=end



def pp_fixtures( data )

## assert fixture status
##      plus league and year always same etc.


  res = data['response']
  puts "  #{res.size} record(s)"


  last_round = nil

  res.each do |rec|

      round      = rec['league']['round']

      if last_round != round
        ## puts ">> #{round}"
        puts "» #{round}"
      end

    

      team1_name = rec['teams']['home']['name']
      team2_name = rec['teams']['away']['name']
      print "     #{team1_name} v #{team2_name}"

      score =  build_score( rec['score'] )
      print "  #{score}"


      if rec['fixture']['venue']
        ## note - venue_name/city MAY incl. comma!!

        venue_name = rec['fixture']['venue']['name']
        venue_city = rec['fixture']['venue']['city']
        print "   @ #{venue_name} › #{venue_city}"
      else
        print " !!! no venue found"
      end
      
      print "\n"

      last_round = round
  end

  puts "  #{res.size} record(s)"
end



## fixtures = ApiFootball.fixtures( league: 'uefa.nl', season: '2022' )
## fixtures = ApiFootball.fixtures( league: 'southamerica', season: '2021' )
## fixtures = ApiFootball.fixtures( league: 'world', season: '2022' )


## fixtures = ApiFootball.fixtures( league: 'copa.l', season: '2023' )
## fixtures = ApiFootball.fixtures( league: 'copa.s', season: '2023' )

## fixtures = ApiFootball.fixtures( league: 'at.1', season: '2023/24' )
## fixtures = ApiFootball.fixtures( league: 'at.2', season: '2023/24' )

## fixtures = ApiFootball.fixtures( league: 'at.cup', season: '2023/24' )
## fixtures = ApiFootball.fixtures( league: 'mx.1', season: '2023' )

## fixtures = ApiFootball.fixtures( league: 'mls', season: '2023' )
## fixtures = ApiFootball.fixtures( league: 'be.1', season: '2023/24' )

## fixtures = ApiFootball.fixtures( league: 'eng.1', season: '2023/24' )
fixtures = ApiFootball.fixtures( league: 'eng.fa.cup', season: '2023/24' )



pp fixtures


pp_fixtures( fixtures )


puts "bye"



__END__

name with  /   remove surrounding spaces?
  Silz / Mötz                 =>  Silz/Mötz 
  Oberwart / Rotenturm        =>  Oberwart/Rotenturm
  Wallern / Marienkirchen

name with -   remove surround spaces?
   FavAC - Platz      =>    FavAC-Platz
   U.N.A.M. - Pumas   =>    U.N.A.M.-Pumas


## check in mls   mls cup round 1  - first matches have no dates (or only scheduled?)
##                                 because of best of three series or such?

## check fa cup  - first rounds no halftime scores???
##   e.g.  Dereham Town v Walsham Le Willows  4-1 (-) ...


note - extra time is score of extra time ONLY!!
       AND fulltime is 90min

goals - is  after extra time

"goals"=>
     {"home"=>3, "away"=>3},
"score"=>
     {"halftime"=>{"home"=>2, "away"=>0},
      "fulltime"=>{"home"=>2, "away"=>2},
      "extratime"=>{"home"=>1, "away"=>1},
      "penalty"=>{"home"=>4, "away"=>2}}}]}

"goals"=>
     {"home"=>2, "away"=>2},
"score"=>
     {"halftime"=>{"home"=>0, "away"=>1},
      "fulltime"=>{"home"=>2, "away"=>2},
      "extratime"=>{"home"=>0, "away"=>0},
      "penalty"=>{"home"=>3, "away"=>4}}},
