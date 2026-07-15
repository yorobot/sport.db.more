
##
## help - yes, you can.
##    if you have any more info about the fifa types,
##    please tell and help fill-in the details.



MATCH_STATUS = {
  0 => 'FIN',     # finished
  1 => 'SCHED',   # scheduled
  2 => 'LIVE',

  ## ???

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
