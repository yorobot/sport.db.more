
##
## help - yes, you can.
##    if you have any more info about the fifa types,
##    please tell and help fill-in the details.



MATCH_STATUS = {
  0 => 'FIN',     # finished
  1 => 'SCHED',   # scheduled  (with or without time - see timed flag)
  2 => 'LIVE',

  ## ???

  7 => 'POSTPONED',  # postponed

  9 => 'AWD',    #  awarded !!!
                 #    check if 9/0   is possibly cancelled/annulled (if no score)
                 #             9/12 (AWD 3-0 or such)

}


##
## "MatchStatus"=>9,  cancelled!!!!
##
##  "ResultType"=>12,
##  21:30  CD Independiente Medellín (COL) v CR Flamengo (BRA)        [cancelled]
##

##
## Result: Al Duhail awarded a 3–0 walkover victory.
## Reason: Auckland City FC withdrew from the tournament
## due to strict COVID-19 pandemic quarantine and isolation measures
##  enforced by New Zealand authorities.

##
## check 2  is only win on pens!!!
##   might be WITHOUT extra time e.g. copa liber.
##  [28/142]  0-FIN    3rd Round   Sporting Cristal | SCL (PER) v Carabobo FC | CRB (VEN)
##                 (2-AET_WIN_ON_PENS)  score: [1, 2] pen: [3, 2] agg: [2, 2]
##   and others!!!
##
##   how to check if  extra time was played?? (use period??)

  # resultType
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR



RESULT_TYPE = {
  0 => 'NO',
  1 => 'REGULAR',
  ## note - cannot tell if
  ##          win on penalties
  ##    is  after extra-time!!!
  ##      used many times in copa libertadores
  ##       check gold cup too
  2 => 'AET_WIN_ON_PENS',  ## or REG_WIN_ON_PENS or AGG_WIN_ON_PENS !!!!!!
  3 => 'AET',
  ##
  ## note - agg - used for 1st & 2nd leg
  4 => 'REGULAR/AGG',  ##  aggregate (1st/2nd leg) - regular
  5 => 'AET/AGG',      ##   aggregate  - after extra-time
  ## e.g.
  ## 2nd LegFeb 25, 2026 Juventus 3–2 (AET) Galatasaray
  ##
  8 => 'AET/GG',   ## after extra-time/golden goal !!!

  12 => 'AWD',  ## AWARDED
}


GOAL_TYPE = {
     1 => 'PENALTY',
     2 => 'REGULAR',
     3 => 'OWN_GOAL',
}


PERIOD_TYPE = {
##   "MatchMinute": "0'",  "1'",  "45'+2'",
  3   => '1ST_HALF',
##  "MatchMinute": "46'", "90'+2'",
  5   => '2ND_HALF',
##  "MatchMinute": "91'",  "105'+2'",
  7   => 'EXTRA_TIME_1ST_HALF',
##   "MatchMinute": "106'", "120'+2'",
  9   => 'EXTRA_TIME_2ND_HALF',
##   "MatchMinute": "120'",  "121'",  "122'",  "123'",
 11  =>  'PENALTY_SHOOTOUT',
##     "MatchMinute": "127'", "130'",
  10  => 'MATCH_END'
}

=begin
"MatchMinute": "1'",
    "Period": 0,  !!!!
 "MatchMinute": "91'",
   "Period": 0,   !!!
=end


EVENT_TYPE = {
  0  => 'Goal!',          ## e.g.  DI MARÍA (Argentina) scores!!
  1  =>  'Assist',        ## e.g. Assisted by MAC ALLISTER.
  2  => 'Yellow card',      ## e.g. FERNÁNDEZ (Argentina) is booked by the referee.
  3  =>  'Red card',         ## e.g. Zinedine ZIDANE (France) is sent off

  5 =>  'Substitution',    ## e.g. ACUÑA (in) comes off the bench to replace DI MARÍA (out) (Argentina)
  6 => 'Penalty Awarded',
  7 =>  'Start Time',      ## e.g. The referee signals the start of the first period.
  8 =>  'End Time',        ## e.g. 'The referee brings the first period to an end.

  12 => 'Attempt at Goal',

  15 => 'Offside',
  16 => 'Corner',
  18 => 'Foul',
  19 =>  'Coin Toss',

  23 => 'Dropped Ball',
  24 => 'Throw In',
  25 => 'Clearance',
  26 => 'Match end',
  27 => 'Aerial Duel',

  41 => 'Penalty Goal',
  46 => 'Penalty missed',  ## David TREZEGUET (France) rattles the crossbar from the spot!
  51 => 'Penalty missed',  ## JULIO CESAR (Brazil) hits the post from the spot!
  60 => 'Penalty missed',  ## COMAN (France) sees his penalty saved by the goalkeeper.
  65 => 'Penalty missed',  ## TCHOUAMENI (France) misses from the penalty spot!
                           ## Michel PLATINI (France) misses from the penalty spot!

}



=begin

note - matchStatus  for 12-AWD should also be 9-AWD!!!

resultType 12
  The Clausura 2022 match between Querétaro and Atlas on March 5, 2022,
  was officially suspended in the 62nd minute
   and later recorded as a 3–0 victory for Atlas
       : Atlas was leading 1–0 at the time of suspension.
           Forfeit Victory: Atlas was officially awarded a 3–0 walkover win.


             0 =>  no result / not played yet
              1 => regular (90 mins)
              2 => aet (120 mins), win on pens
              3 => aet (120 mins)

              8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

              4 =>    aggregate  leg 1/2 ?? e.g.
                    "AggregateHomeTeamScore": 2,
                    "AggregateAwayTeamScore": 4,
=end
