
### Enums / Types

see <lib/fifadat/types.rb>  for more



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



```


---
check alternate sources / wrappers:

- (v4) https://github.com/chrispickford/fifa-public-api-mcp/blob/master/README.md
- (v1) https://github.com/jalispran/fifa-2018