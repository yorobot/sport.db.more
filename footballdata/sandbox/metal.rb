###
#  to run use:
#   $ ruby sandbox/metal.rb

require_relative 'helper'


##
##
 ## data = Footballdata::Metal::matches( 'BL1', 2025, )
 ## pp data


 headers = {
  'X-Unfold-Lineups'  =>  'true',
  'X-Unfold-Bookings' =>  'true',
  'X-Unfold-Subs'     =>  'true',
  'X-Unfold-Goals'    =>  'true',
}

## try match id
 matchId = 540710

## data = Footballdata::Metal.match( matchId, headers: headers )
## pp data


## data = Footballdata::Metal::matches( 'CL', 2025, headers: headers )
## pp data

matchId = 552096
## data = Footballdata::Metal.match( matchId, headers: headers )
## pp data


data = Footballdata::Metal::teams( 'CLI', 2024 )
data = Footballdata::Metal::matches( 'CLI', 2024, headers: headers )
pp data


## data = Footballdata::Metal::matches( 'WC', 2026, headers: headers )
## pp data


## data = Footballdata::Metal::teams( 'CL', 2025 )
## pp data

## data = Footballdata::Metal::teams( 'WC', 2026 )
## pp data

puts "bye"




__END__


note -   score is "weird"
  - fullTime is agg PLUS penalties
  - regTime is "classic" fullTime

 "stage"=>"FINAL",
 "matchday"=>nil,
 "group"=>nil,
 "homeTeam"=>
  {"name"=>"Paris Saint-Germain FC",
   "shortName"=>"PSG",
   "tla"=>"PSG",
 "awayTeam"=>
  {"name"=>"Arsenal FC",
   "shortName"=>"Arsenal",
   "tla"=>"ARS",
 "score"=>
  {"winner"=>"HOME_TEAM",
   "duration"=>"PENALTY_SHOOTOUT",
   "fullTime"=>{"home"=>5, "away"=>4},
   "halfTime"=>{"home"=>0, "away"=>1},
   "regularTime"=>{"home"=>1, "away"=>1},
   "extraTime"=>{"home"=>0, "away"=>0},
   "penalties"=>{"home"=>4, "away"=>3}},
"venue"=>nil,

Extra Time / Penalty Shootout
In case of knockout matches you have to pay attention to the score/duration attribute.
 It defaults to REGULAR but also accepts EXTRA_TIME and PENALTY_SHOOTOUT as value.
 It indicates when the match ended (e.g. match status FINISHED,
 score/duration EXTRA_TIME ⇒ 120 minutes, no penalties) -
 or, when the match is still running - it’s kind of an additional status of the match.


The optional score/extraTime, score/penalties nodes will appear and
will be set to 0 as soon as duration is EXTRA_TIME and
count up (only) the goals scored within extratime.
PENALTY_SHOOTOUT works equivalent and score/penalties will only contain the goals
within the penalty shootout.


So after a match you can either say "the match ended in penalty shootout"
(taking the scores of the score/penalties) or
"the match ended after a penalty shootout" (taking the fullTime score).
At least in german we have that distinction and sport websites
use it interchangeably. I personally prefer the latter.


Since v4 there is also the score/regularTime attribute which holds
the goals scored after 90 minutes in case you want to display that as well.