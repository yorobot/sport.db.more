# Notes



double check for more (*) awared, cancelled, and such!!!


!! check for 2020/21 in it.1
  1,Sat Sep 19 2020,Hellas Verona FC,3-0 (*),,AS Roma,awarded


!! ERROR: unsupported match status >IN_PLAY< - sorry:
"utcDate"=>"2024-05-20T16:30:00Z",
"status"=>"IN_PLAY",
"matchday"=>37,

note - IN_PLAY (same as playing now!!! LIVE)
##  retry when match ended!!!!

!! ERROR: unsupported match status >PAUSED< - sorry:
## - why paused??
{"area"=>{"id"=>2114, "name"=>"Italy", "code"=>"ITA", "flag"=>"https://crests.football-data.org/784.svg"},
 "utcDate"=>"2024-05-20T18:45:00Z",
 "status"=>"PAUSED",
 "matchday"=>37,



====  es.1 2023/24  =============
  match stati: {"FINISHED"=>370, "TIMED"=>10}
====  it.1 2023/24  =============
  match stati: {"FINISHED"=>370, "TIMED"=>10}
====  it.1 2020/21  =============
  match stati: {"FINISHED"=>379, "AWARDED"=>1}
====  fr.1 2021/22  =============
  match stati: {"FINISHED"=>380, "CANCELLED"=>2}

```



double check uefa.cl

```
2020/21

   178/178 matches
     status (2): FINISHED (176) · AWARDED (2)
     duration (3): REGULAR (170) · EXTRA_TIME (4) · PENALTY_SHOOTOUT (4)
     stage (11): PRELIMINARY_SEMI_FINALS (2) · PRELIMINARY_FINAL (1) · 1ST_QUALIFYING_ROUND (17) · 2ND_QUALIFYING_ROUND (13) · 3RD_QUALIFYING_ROUND (8) · PLAY_OFF_ROUND (12) · GROUP_STAGE (96) · ROUND_OF_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (13): Preliminary Semi-finals (2) · Preliminary Final (1) · 1st Qualifying Round (17) · 2nd Qualifying Round (13) · 3rd Qualifying Round (8) · Group F (12) · Group G (12) · Group E (12) · Group H (12) · Group A (12) · Group B (12) · Group C (12) · Group D (12)

 !!! note - group incl. NON GROUPS e.g.
 Preliminary Semi-finals (2) · Preliminary Final (1) · 1st Qualifying Round (17) · 2nd Qualifying Round (13) · 3rd Qualifying Round (8)


2021/22

   218/218 matches
     status (1): FINISHED (218)
     duration (3): REGULAR (211) · EXTRA_TIME (6) · PENALTY_SHOOTOUT (1)
     stage (10): PRELIMINARY_ROUND (3) · QUALIFICATION_ROUND_1 (32) · QUALIFICATION_ROUND_2 (26) · QUALIFICATION_ROUND_3 (20) · PLAY_OFF_ROUND (12) · GROUP_STAGE (96) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (8): GROUP_F (12) · GROUP_G (12) · GROUP_E (12) · GROUP_H (12) · GROUP_C (12) · GROUP_D (12) · GROUP_A (12) · GROUP_B (12)

2022/23

   214/214 matches
     status (1): FINISHED (214)
     duration (3): REGULAR (203) · EXTRA_TIME (8) · PENALTY_SHOOTOUT (3)
     stage (10): PRELIMINARY_ROUND (3) · QUALIFICATION_ROUND_1 (30) · QUALIFICATION_ROUND_2 (24) · QUALIFICATION_ROUND_3 (20) · PLAYOFF_ROUND_1 (12) · GROUP_STAGE (96) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (8): GROUP_E (12) · GROUP_G (12) · GROUP_F (12) · GROUP_H (12) · GROUP_A (12) · GROUP_D (12) · GROUP_B (12) · GROUP_C (12)

2023/24

   125/125 matches
     status (1): FINISHED (125)
     duration (2): REGULAR (122) · PENALTY_SHOOTOUT (3)
     stage (5): GROUP_STAGE (96) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (8): GROUP_F (12) · GROUP_G (12) · GROUP_E (12) · GROUP_H (12) · GROUP_C (12) · GROUP_A (12) · GROUP_B (12) · GROUP_D (12)

2024/25

   0/189 matches
     status (2): TIMED (144) · SCHEDULED (45)
     duration (1): REGULAR (189)
     stage (6): LEAGUE_STAGE (144) · PLAYOFFS (16) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (0):
```

double check copa.l

```
2021
  155/155 matches
     status (1): FINISHED (155)
     duration (3): REGULAR (152) · PENALTY_SHOOTOUT (2) · EXTRA_TIME (1)
     stage (6): QUALIFICATION (30) · GROUP_STAGE (96) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (0):

 !! note - groups missing for GROUP STAGE!!!

2022
   155/155 matches
     status (1): FINISHED (155)
     duration (2): REGULAR (149) · PENALTY_SHOOTOUT (6)
     stage (13): QUALIFICATION_ROUND_1 (6) · QUALIFICATION_ROUND_2 (16) · QUALIFICATION_ROUND_3 (8) · ROUND_1 (16) · ROUND_2 (16) · ROUND_3 (16) · ROUND_4 (16) · ROUND_5 (16) · ROUND_6 (16) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (8): GROUP_B (12) · GROUP_G (12) · GROUP_E (12) · GROUP_H (12) · GROUP_C (12) · GROUP_D (12) · GROUP_A (12) · GROUP_F (12)

2023
155/155 matches
     status (1): FINISHED (155)
     duration (3): REGULAR (149) · PENALTY_SHOOTOUT (5) · EXTRA_TIME (1)
     stage (8): ROUND_1 (6) · ROUND_2 (16) · ROUND_3 (8) · GROUP_STAGE (96) · LAST_16 (16) · QUARTER_FINALS (8) · SEMI_FINALS (4) · FINAL (1)
     group (8): GROUP_D (12) · GROUP_E (12) · GROUP_G (12) · GROUP_B (12) · GROUP_H (12) · GROUP_A (12) · GROUP_C (12) · GROUP_F (12)

2024
141/142 matches
     status (2): FINISHED (141) · IN_PLAY (1)
     duration (2): REGULAR (141) · PENALTY_SHOOTOUT (1)
     stage (5): ROUND_1 (6) · ROUND_2 (16) · ROUND_3 (8) · GROUP_STAGE (96) · LAST_16 (16)
     group (8): GROUP_B (12) · GROUP_E (12) · GROUP_C (12) · GROUP_H (12) · GROUP_D (12) · GROUP_A (12) · GROUP_F (12) · GROUP_G (12)
```


double check br.1


```
2020
 380/380 matches
     status (1): FINISHED (380)
     duration (1): REGULAR (380)
     stage (1): REGULAR_SEASON (380)
     group (1): Regular Season (380)
```


note - fbdat - old (broken) format for br.1 2020 and copa.l 2021
   and uefa.cl 2020/21



```
eng.2  - championship includes playoff e.g.
            add later how???
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping FINAL

!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping FINAL

!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
```

