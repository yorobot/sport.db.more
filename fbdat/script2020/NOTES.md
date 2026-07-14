# Notes


- [ ] webget - better report error - show requested url!!!!

´´´
sleep 8 sec(s)...
!! ERROR - 400 :
#<Net::HTTPBadRequest 400  readbody=true>
{"message"=>
  "Parameter 'competitionId' is expected to be either an integer in a specified range or a competition code.",
 "errorCode"=>400}
´´´



- [ ] fix Brazil 2020 !!!! - use season (and start_year) NOT year for convert!!!!

- [ ] add time!!! to datasets - why? why not?


- [ ] check Brazil 2020 !!! - schedule now runs into 2021 - fix season!!!!

´´´
2020/21 (Aug 9 - Feb 24) - 20 clubs, 380 matches, 247 goals
  match status: {"FINISHED"=>104, "POSTPONED"=>4, "SCHEDULED"=>272}

 The competition was originally scheduled to begin on 3 May
 and end on 6 December, however due to the COVID-19 pandemic
 the tournament was rescheduled, starting on 8 August 2020 and
ending on 24 February 2021.
´´´


- [ ] check champions league - add country code to team/club names - why? why not?

´´´
Qualifying,Qual. Round 1,,Wed Aug 19 2020,FC Sheriff Tiraspol,2-0,1-0,CS Fola Esch
Qualifying,Qual. Round 1,,Wed Aug 19 2020,Floriana FC,0-2,0-0,FC CFR 1907 Cluj
Qualifying,Qual. Round 1,,Fri Aug 21 2020,KÍ,3-0 (*),,ŠK Slovan Bratislava,awarded
Qualifying,Qual. Round 2,,Tue Aug 25 2020,PAOK FC,3-1,3-1,Beşiktaş JK
Qualifying,Qual. Round 2,,Tue Aug 25 2020,KF Tirana,0-1,0-0,FK Crvena Zvezda
Qualifying,Qual. Round 2,,Wed Aug 26 2020,AZ,1-1,0-0,FC Viktoria Plzeň,3-1
...
´´´


- [ ] todo - handle champs (int'l club competition with stages) e.g.


´´´
2018/19 (Jun 26 - Jun 1) - 0 clubs, 0 matches, 0 goals
{:all=>
  {:duration=>{"EXTRA_TIME"=>4, "REGULAR"=>212},
   :stage=>
    {"PRELIMINARY_SEMI_FINALS"=>2,
     "PRELIMINARY_FINAL"=>1,
     "1ST_QUALIFYING_ROUND"=>32,
     "2ND_QUALIFYING_ROUND"=>24,
     "3RD_QUALIFYING_ROUND"=>20,
     "PLAY_OFF_ROUND"=>12,
     "GROUP_STAGE"=>96,
     "ROUND_OF_16"=>16,
     "QUARTER_FINALS"=>8,
     "SEMI_FINALS"=>4,
     "FINAL"=>1},
   :status=>{"FINISHED"=>216},
   :group=>
    {"Preliminary Semi-finals"=>2,
     "Preliminary Final"=>1,
     nil=>116,
     "Group B"=>12,
     "Group A"=>12,
     "Group C"=>12,
     "Group D"=>12,
     "Group E"=>12,
     "Group F"=>12,
     "Group G"=>12,
     "Group H"=>12,
     "Final"=>1},
   :matches=>216,
   :goals=>577},
 :regular=>
  {:duration=>{}, :stage=>{}, :status=>{}, :group=>{}, :matches=>0, :goals=>0}}

{:all=>
  {:duration=>{"REGULAR"=>198, "PENALTY_SHOOTOUT"=>3, "EXTRA_TIME"=>2},
   :stage=>
    {"PRELIMINARY_SEMI_FINALS"=>2,
     "PRELIMINARY_FINAL"=>1,
     "1ST_QUALIFYING_ROUND"=>32,
     "2ND_QUALIFYING_ROUND"=>24,
     "3RD_QUALIFYING_ROUND"=>20,
     "PLAY_OFF_ROUND"=>12,
     "GROUP_STAGE"=>96,
     "ROUND_OF_16"=>16},
   :status=>{"FINISHED"=>199, "SCHEDULED"=>4},
   :group=>
    {"Preliminary Semi-finals"=>2,
     "Preliminary Final"=>1,
     nil=>104,
     "Group F"=>12,
     "Group G"=>12,
     "Group E"=>12,
     "Group H"=>12,
     "Group A"=>12,
     "Group B"=>12,
     "Group C"=>12,
     "Group D"=>12},
   :matches=>203,
   :goals=>584},
 :regular=>
  {:duration=>{}, :stage=>{}, :status=>{}, :group=>{}, :matches=>0, :goals=>0}}
´´´


