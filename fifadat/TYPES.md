
### Enums / Types

```
 MatchStatus
              0 =>  complete ??
              1 =>  future  / not played yet
              ??  =>  ??

- `MatchStatus` enum → string:
`0=finished`,
`1=notStarted`,
`3=live`; unknown codes → `"unknown:<n>"`.

MatchStatus — This int value represents the match status at the current moment. There are seven known values for MatchStatus viz.,
0 - ‘full time’             => FINISHED
1 - ‘match yet to start’    => SCHEDULED
3 - ‘match live’            => LIVE
4 - ‘abandoned’
7 - ‘postponed’
8 - ‘cancelled’
12  -  ‘lineups’   - what is lineups??
source: https://medium.com/@jalispran/fifa-2018-wc-football-api-988123774279

matchStatus = 1			->			match yet to start
matchStatus = 3			->			match live
matchStatus = 4 		->			abandoned
matchStatus = 7			->			postponed
matchStatus = 8			->			cancelled
matchStatus = 12		->			lineups
matchStatus = 0			->			full time
period = 4				->			half time
period = 6 				->			extra time
period = 8				->			extra half time
period = 11				-> 			penalty shootouts
period = 10				->			full time

match-lineup	->			matchStatus = 12 and length of 'Players' array in of EVENTS URL > 11 for HomeTeam and AwayTeam
match-fulltime	->			matchStatus = 0 / 4 / 8


note -  Only MatchStatus is not sufficient to find the current state of the match. You need another variable known as Period. This int has five known values viz.,

 4 - ‘half time’
 6 - ‘extra time’
 8, - ‘extra half time’
 10 - ‘full time’
 11 - ‘penalty shootouts’

So end of the match is detected as — if(MatchStatus == 0 && Period == 10)


- [ ] try to decipher period values
         3  - 1st half    (1'-45' or 45'+7')  -- 0' possible!!
         5  - 2nd half    (46'-90' or 90'+5')
         7  - extra time  (91'-105' or 105'+1')
         9  - 2nd half extra time (106'-120' or 120'+1')
         11 - penalty shoot-out  (121'-)


         0  - ??    91'
         4  - ??     45'+1'
         8  - ??   105' or 106'




---
match period:

ai suggests:  This field is much easier because FIFA uses it consistently.

Value	Meaning
0	Before kickoff
1	1st Half
2	Half-time
3	2nd Half
4	End of Normal Time

5	ET 1st Half
6	ET Half-time
7	ET 2nd Half
8	End of Extra Time

9	Penalty Shootout
10	End of Penalties

Some feeds expose this as strings instead
(1H, HALF, 2H, END-REG,
 ET 1H, HALF-ET, ET 2H, END-ET,
 PENS, END-PENS
).







 ResultType
              0 =>  no result / not played yet
              1 => regular (90 mins)
              2 => aet (120 mins), win on pens
              3 => aet (120 mins)

              8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

              4 =>    aggregate  leg 1/2 ?? e.g.
                    "AggregateHomeTeamScore": 2,
                    "AggregateAwayTeamScore": 4,


---
0	No result yet	Not Played / Pending
1	Regular time (90')	FT
2	Won on penalties	AET + Pens
3	Won after extra time (120')	AET

4	Walkover / Awarded*                	WO / Awarded
5	Awarded / Administrative decision*  	Awarded
6	Cancelled / Abandoned*	             Cancelled
7	Forfeit*	                         Forfeit
8	Void*	                              Void
---

---
guess by google ai
0: Normal Result (The match finished normally in regular time)
1: After Extra Time (The match required extra time to find a winner)
2: Penalty Shootout (The match was decided by penalties)
3: Technical Loss / Forfeit (One team forfeited or was disqualified, resulting in an automatic loss—usually 3-0)
4: Postponed (The match has been delayed to a later date)
5: Cancelled (The match will not be played at all)
6: Abandoned (The match started but was stopped midway due to weather, crowd trouble, etc.)


0: Not Played Yet / None
1: Regular Result (Settled within the standard 90 minutes)
2: After Extra Time (Settled during 30 mins extra time)
3: Penalty Shootout (Settled via penalties)
4: Technical Loss / Forfeit (Standard 3-0 walkover decision)
5: Draw by Lot (Rare coin toss / drawing of lots)
6: Golden Goal (Older tournament formats)
7: Silver Goal (Older tournament formats)



---



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


---
check alternate sources / wrappers:

- (v4) https://github.com/chrispickford/fifa-public-api-mcp/blob/master/README.md
- (v1) https://github.com/jalispran/fifa-2018