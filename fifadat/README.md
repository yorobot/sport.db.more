# (Unofficial) Fifa (JSON) API

## Usage


### Worldcup 2026

step 1 - download / pre-fill cache with json datasets incl.
-  matches
-  stages
-  squads
-  match report (aka live & timeline if penalty shootout) for each match


```ruby
prepare( name:    'worldcup',
         seasons: ['2026'],
         outdir:  '.'     ## note - auto-adds name/slug e.g. ./worldcup
       )
```


## try debug

```
$ ruby ppdebug.rb worldcup --season=2026
```

resulting in:

```
= World Cup 2026

==> [1/104]  0    First Stage, Group A (1)   Mexico | MEX (MEX) v South Africa | RSA (RSA)  2-0 (1)
==> [2/104]  0    First Stage, Group A (2)   South Korea | KOR (KOR) v Czechia | CZE (CZE)  2-1 (1)
==> [3/104]  0    First Stage, Group B (3)   Canada | CAN (CAN) v Bosnia and Herzegovina | BIH (BIH)  1-1 (1)
==> [4/104]  0    First Stage, Group D (4)   USA | USA (USA) v Paraguay | PAR (PAR)  4-1 (1)
==> [5/104]  0    First Stage, Group B (8)   Qatar | QAT (QAT) v Switzerland | SUI (SUI)  1-1 (1)
==> [6/104]  0    First Stage, Group C (7)   Brazil | BRA (BRA) v Morocco | MAR (MAR)  1-1 (1)
==> [7/104]  0    First Stage, Group C (5)   Haiti | HAI (HAI) v Scotland | SCO (SCO)  0-1 (1)
==> [8/104]  0    First Stage, Group D (6)   Australia | AUS (AUS) v Türkiye | TUR (TUR)  2-0 (1)
==> [9/104]  0    First Stage, Group E (10)   Germany | GER (GER) v Curaçao | CUW (CUW)  7-1 (1)
==> [10/104]  0    First Stage, Group F (11)   Netherlands | NED (NED) v Japan | JPN (JPN)  2-2 (1)
==> [11/104]  0    First Stage, Group E (9)   Côte d'Ivoire | CIV (CIV) v Ecuador | ECU (ECU)  1-0 (1)
==> [12/104]  0    First Stage, Group F (12)   Sweden | SWE (SWE) v Tunisia | TUN (TUN)  5-1 (1)
==> [13/104]  0    First Stage, Group H (14)   Spain | ESP (ESP) v Cabo Verde | CPV (CPV)  0-0 (1)
==> [14/104]  0    First Stage, Group G (16)   Belgium | BEL (BEL) v Egypt | EGY (EGY)  1-1 (1)
==> [15/104]  0    First Stage, Group H (13)   Saudi Arabia | KSA (KSA) v Uruguay | URU (URU)  1-1 (1)
==> [16/104]  0    First Stage, Group G (15)   Iran | IRN (IRN) v New Zealand | NZL (NZL)  2-2 (1)
==> [17/104]  0    First Stage, Group I (17)   France | FRA (FRA) v Senegal | SEN (SEN)  3-1 (1)
==> [18/104]  0    First Stage, Group I (18)   Iraq | IRQ (IRQ) v Norway | NOR (NOR)  1-4 (1)
==> [19/104]  0    First Stage, Group J (19)   Argentina | ARG (ARG) v Algeria | ALG (ALG)  3-0 (1)
==> [20/104]  0    First Stage, Group J (20)   Austria | AUT (AUT) v Jordan | JOR (JOR)  3-1 (1)
==> [21/104]  0    First Stage, Group K (23)   Portugal | POR (POR) v Congo DR | COD (COD)  1-1 (1)
==> [22/104]  0    First Stage, Group L (22)   England | ENG (ENG) v Croatia | CRO (CRO)  4-2 (1)
==> [23/104]  0    First Stage, Group L (21)   Ghana | GHA (GHA) v Panama | PAN (PAN)  1-0 (1)
==> [24/104]  0    First Stage, Group K (24)   Uzbekistan | UZB (UZB) v Colombia | COL (COL)  1-3 (1)
==> [25/104]  0    First Stage, Group A (25)   Czechia | CZE (CZE) v South Africa | RSA (RSA)  1-1 (1)
==> [26/104]  0    First Stage, Group B (26)   Switzerland | SUI (SUI) v Bosnia and Herzegovina | BIH (BIH)  4-1 (1)
==> [27/104]  0    First Stage, Group B (27)   Canada | CAN (CAN) v Qatar | QAT (QAT)  6-0 (1)
==> [28/104]  0    First Stage, Group A (28)   Mexico | MEX (MEX) v South Korea | KOR (KOR)  1-0 (1)
==> [29/104]  0    First Stage, Group D (32)   USA | USA (USA) v Australia | AUS (AUS)  2-0 (1)
==> [30/104]  0    First Stage, Group C (30)   Scotland | SCO (SCO) v Morocco | MAR (MAR)  0-1 (1)
==> [31/104]  0    First Stage, Group C (29)   Brazil | BRA (BRA) v Haiti | HAI (HAI)  3-0 (1)
==> [32/104]  0    First Stage, Group D (31)   Türkiye | TUR (TUR) v Paraguay | PAR (PAR)  0-1 (1)
==> [33/104]  0    First Stage, Group F (35)   Netherlands | NED (NED) v Sweden | SWE (SWE)  5-1 (1)
==> [34/104]  0    First Stage, Group E (33)   Germany | GER (GER) v Côte d'Ivoire | CIV (CIV)  2-1 (1)
==> [35/104]  0    First Stage, Group E (34)   Ecuador | ECU (ECU) v Curaçao | CUW (CUW)  0-0 (1)
==> [36/104]  0    First Stage, Group F (36)   Tunisia | TUN (TUN) v Japan | JPN (JPN)  0-4 (1)
==> [37/104]  0    First Stage, Group H (38)   Spain | ESP (ESP) v Saudi Arabia | KSA (KSA)  4-0 (1)
==> [38/104]  0    First Stage, Group G (39)   Belgium | BEL (BEL) v Iran | IRN (IRN)  0-0 (1)
==> [39/104]  0    First Stage, Group H (37)   Uruguay | URU (URU) v Cabo Verde | CPV (CPV)  2-2 (1)
==> [40/104]  0    First Stage, Group G (40)   New Zealand | NZL (NZL) v Egypt | EGY (EGY)  1-3 (1)
==> [41/104]  0    First Stage, Group J (43)   Argentina | ARG (ARG) v Austria | AUT (AUT)  2-0 (1)
==> [42/104]  0    First Stage, Group I (42)   France | FRA (FRA) v Iraq | IRQ (IRQ)  3-0 (1)
==> [43/104]  0    First Stage, Group I (41)   Norway | NOR (NOR) v Senegal | SEN (SEN)  3-2 (1)
==> [44/104]  0    First Stage, Group J (44)   Jordan | JOR (JOR) v Algeria | ALG (ALG)  1-2 (1)
==> [45/104]  0    First Stage, Group K (47)   Portugal | POR (POR) v Uzbekistan | UZB (UZB)  5-0 (1)
==> [46/104]  0    First Stage, Group L (45)   England | ENG (ENG) v Ghana | GHA (GHA)  0-0 (1)
==> [47/104]  0    First Stage, Group L (46)   Panama | PAN (PAN) v Croatia | CRO (CRO)  0-1 (1)
==> [48/104]  0    First Stage, Group K (48)   Colombia | COL (COL) v Congo DR | COD (COD)  1-0 (1)
==> [49/104]  0    First Stage, Group B (52)   Bosnia and Herzegovina | BIH (BIH) v Qatar | QAT (QAT)  3-1 (1)
==> [50/104]  0    First Stage, Group B (51)   Switzerland | SUI (SUI) v Canada | CAN (CAN)  2-1 (1)
==> [51/104]  0    First Stage, Group C (50)   Morocco | MAR (MAR) v Haiti | HAI (HAI)  4-2 (1)
==> [52/104]  0    First Stage, Group C (49)   Scotland | SCO (SCO) v Brazil | BRA (BRA)  0-3 (1)
==> [53/104]  0    First Stage, Group A (54)   South Africa | RSA (RSA) v South Korea | KOR (KOR)  1-0 (1)
==> [54/104]  0    First Stage, Group A (53)   Czechia | CZE (CZE) v Mexico | MEX (MEX)  0-3 (1)
==> [55/104]  0    First Stage, Group E (55)   Curaçao | CUW (CUW) v Côte d'Ivoire | CIV (CIV)  0-2 (1)
==> [56/104]  0    First Stage, Group E (56)   Ecuador | ECU (ECU) v Germany | GER (GER)  2-1 (1)
==> [57/104]  0    First Stage, Group F (58)   Tunisia | TUN (TUN) v Netherlands | NED (NED)  1-3 (1)
==> [58/104]  0    First Stage, Group F (57)   Japan | JPN (JPN) v Sweden | SWE (SWE)  1-1 (1)
==> [59/104]  0    First Stage, Group D (60)   Paraguay | PAR (PAR) v Australia | AUS (AUS)  0-0 (1)
==> [60/104]  0    First Stage, Group D (59)   Türkiye | TUR (TUR) v USA | USA (USA)  3-2 (1)
==> [61/104]  0    First Stage, Group I (62)   Senegal | SEN (SEN) v Iraq | IRQ (IRQ)  5-0 (1)
==> [62/104]  0    First Stage, Group I (61)   Norway | NOR (NOR) v France | FRA (FRA)  1-4 (1)
==> [63/104]  0    First Stage, Group H (66)   Uruguay | URU (URU) v Spain | ESP (ESP)  0-1 (1)
==> [64/104]  0    First Stage, Group H (65)   Cabo Verde | CPV (CPV) v Saudi Arabia | KSA (KSA)  0-0 (1)
==> [65/104]  0    First Stage, Group G (64)   New Zealand | NZL (NZL) v Belgium | BEL (BEL)  1-5 (1)
==> [66/104]  0    First Stage, Group G (63)   Egypt | EGY (EGY) v Iran | IRN (IRN)  1-1 (1)
==> [67/104]  0    First Stage, Group L (67)   Panama | PAN (PAN) v England | ENG (ENG)  0-2 (1)
==> [68/104]  0    First Stage, Group L (68)   Croatia | CRO (CRO) v Ghana | GHA (GHA)  2-1 (1)
==> [69/104]  0    First Stage, Group K (72)   Congo DR | COD (COD) v Uzbekistan | UZB (UZB)  3-1 (1)
==> [70/104]  0    First Stage, Group K (71)   Colombia | COL (COL) v Portugal | POR (POR)  0-0 (1)
==> [71/104]  0    First Stage, Group J (69)   Algeria | ALG (ALG) v Austria | AUT (AUT)  3-3 (1)
==> [72/104]  0    First Stage, Group J (70)   Jordan | JOR (JOR) v Argentina | ARG (ARG)  1-3 (1)
==> [73/104]  0    Round of 32 (73)   South Africa | RSA (RSA) v Canada | CAN (CAN)  0-1 (1)
==> [74/104]  0    Round of 32 (76)   Brazil | BRA (BRA) v Japan | JPN (JPN)  2-1 (1)
==> [75/104]  0    Round of 32 (74)   Germany | GER (GER) v Paraguay | PAR (PAR)  1-1 a.e.t., 3-4 pen. (2)
==> [76/104]  0    Round of 32 (75)   Netherlands | NED (NED) v Morocco | MAR (MAR)  1-1 a.e.t., 2-3 pen. (2)
==> [77/104]  0    Round of 32 (78)   Côte d'Ivoire | CIV (CIV) v Norway | NOR (NOR)  1-2 (1)
==> [78/104]  0    Round of 32 (77)   France | FRA (FRA) v Sweden | SWE (SWE)  3-0 (1)
==> [79/104]  0    Round of 32 (79)   Mexico | MEX (MEX) v Ecuador | ECU (ECU)  2-0 (1)
==> [80/104]  0    Round of 32 (80)   England | ENG (ENG) v Congo DR | COD (COD)  2-1 (1)
==> [81/104]  0    Round of 32 (82)   Belgium | BEL (BEL) v Senegal | SEN (SEN)  3-2 a.e.t. (3)
==> [82/104]  0    Round of 32 (81)   USA | USA (USA) v Bosnia and Herzegovina | BIH (BIH)  2-0 (1)
==> [83/104]  0    Round of 32 (84)   Spain | ESP (ESP) v Austria | AUT (AUT)  3-0 (1)
==> [84/104]  0    Round of 32 (83)   Portugal | POR (POR) v Croatia | CRO (CRO)  2-1 (1)
==> [85/104]  0    Round of 32 (85)   Switzerland | SUI (SUI) v Algeria | ALG (ALG)  2-0 (1)
==> [86/104]  0    Round of 32 (88)   Australia | AUS (AUS) v Egypt | EGY (EGY)  1-1 a.e.t., 2-4 pen. (2)
==> [87/104]  0    Round of 32 (86)   Argentina | ARG (ARG) v Cabo Verde | CPV (CPV)  3-2 a.e.t. (3)
==> [88/104]  0    Round of 32 (87)   Colombia | COL (COL) v Ghana | GHA (GHA)  1-0 (1)
==> [89/104]  0    Round of 16 (90)   Canada | CAN (CAN) v Morocco | MAR (MAR)  0-3 (1)
==> [90/104]  0    Round of 16 (89)   Paraguay | PAR (PAR) v France | FRA (FRA)  0-1 (1)
==> [91/104]  0    Round of 16 (91)   Brazil | BRA (BRA) v Norway | NOR (NOR)  1-2 (1)
==> [92/104]  0    Round of 16 (92)   Mexico | MEX (MEX) v England | ENG (ENG)  2-3 (1)
==> [93/104]  0    Round of 16 (93)   Portugal | POR (POR) v Spain | ESP (ESP)  0-1 (1)
==> [94/104]  0    Round of 16 (94)   USA | USA (USA) v Belgium | BEL (BEL)  1-4 (1)
==> [95/104]  0    Round of 16 (95)   Argentina | ARG (ARG) v Egypt | EGY (EGY)  3-2 (1)
==> [96/104]  0    Round of 16 (96)   Switzerland | SUI (SUI) v Colombia | COL (COL)  0-0 a.e.t., 4-3 pen. (2)
==> [97/104]  1    Quarter-final (97)   France | FRA (FRA) v Morocco | MAR (MAR)   (0)
==> [98/104]  1    Quarter-final (98)   Spain | ESP (ESP) v Belgium | BEL (BEL)   (0)
==> [99/104]  1    Quarter-final (99)   Norway | NOR (NOR) v England | ENG (ENG)   (0)
==> [100/104]  1    Quarter-final (100)   Argentina | ARG (ARG) v Switzerland | SUI (SUI)   (0)
==> [101/104]  1    Semi-final (101)   ? | ? (?) v ? | ? (?)   (0)
==> [102/104]  1    Semi-final (102)   ? | ? (?) v ? | ? (?)   (0)
==> [103/104]  1    Play-off for third place (103)   ? | ? (?) v ? | ? (?)   (0)
==> [104/104]  1    Final (104)   ? | ? (?) v ? | ? (?)   (0)

stats:{
 "MatchStatus"=>{0=>96, 1=>8},
 "ResultType"=>{1=>90, 2=>4, 3=>2, 0=>8},
 "Leg"=>{nil=>104},
 "IsHomeMatch"=>{nil=>104},
 "MatchDay"=>{false=>104},
 "MatchNumber"=>{true=>104},
 "Attendance"=>{false=>104},
 "Weather"=>{true=>96, false=>8},
 "TeamType"=>{1=>200},
 "AgeType"=>{7=>200},
 "FootballType"=>{0=>200}
}
```


try football.txt print

```
$ ruby ppmatch.rb worldcup --season=2026
$ ruby ppmatch.rb worldcup --season=2026 --full

$ ruby ppsquads.rb worldcup --season=2026
```





### Enums / Types

```
 MatchStatus
              0 =>  complete ??
              1 =>  future  / not played yet

 ResultType
              0 =>  no result / not played yet
              1 => regular (90 mins)
              2 => aet (120 mins), win on pens
              3 => aet (120 mins)
              8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

              4 =>    aggregate  leg 1/2 ?? e.g.
                    "AggregateHomeTeamScore": 2,
                    "AggregateAwayTeamScore": 4,


 TeamType
            0 => club
            1 => nati(onal) team
 AgeType
    0 =>  ??
    1 =>   U17     U-17 World Cup / U17 National Team Friendlies
                    MLS Generation Cup U17
    2 =>   U18     U18 National Team Friendlies
                       U18 Premier League Cup
    3 =>   U19     U19 Championship Qualification
    4 =>   U20     U-20 World Cup / CONMEBOL U20

    5 =>  ??        Olympic Football Tournament / Olympics Intercontinental Play-offs /
                    AFC U23 Asian Cup

   10 =>   U15     U15 National Team Friendlies
                   MLS Generation Cup U15
   11 =>   U16     U16 National Team Friendlies
   12 =>   U21     U21 Championship / Tournoi Maurice Revello /
                      U21 National Team Friendlies
                      Premier League 2

   14 =>   ?? U23     U23 National Team Friendlies /  Asian Games

 FootballType
            0 => "classic"
            1 =>  Futsal
            2 => Beach Soccer
  Gender
            1 => m
            2 => f


```
