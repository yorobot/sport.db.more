
# Notes 

## Todos

```
- [ ]  add a name check  with regex  - and warn if no match and log to errors.txt !!!

- [ ] collect all (club) teams and  (stadiums) venues by country

- [ ] maybe move utc parse machinery
         to cocos (for easier reuse) - why? why not?
```



## Notes on API-Football 

see https://www.api-football.com/documentation-v3



score notes:

-  there's no support for legs (leg 1 of 2, leg 2 of 2) 
    and aggregate scores
-  for now it is impossible to check if extra time was used for penalties score
-  some penalty scores are missing for matches with aet results (that are draws in cups)
- for walkout (w/o) - not specified what team was absent

-  looks like matches that are awarded are not really marked/tagged as such
   e.g. have regular score  (maybe 3-0)



rounds in friendlies
- what is the meaning of Friendlies 1, Friendlies 2, Friendlies 3
  is it the tier e.g. tier 1/2/3 or something else?



### Fixture (Match) Status

see <https://www.api-football.com/documentation-v3#tag/Fixtures/operation/get-fixtures>


supported match status for now include:

- SHORT 	LONG	TYPE	DESCRIPTION
- FT	Match Finished	 Finished	-- Finished in the regular time
- AET	Match Finished	 Finished	-- Finished after extra time without going to the penalty shootout
- PEN	Match Finished	  Finished	 -- Finished after the penalty shootout

note -  for now it is NOT possible for PEN to see if extra time was used or not;
           elapsed time always set to 120 (even though no extra time);
           extra time set to 0-0 (but that might be real score in extratime)

more:

- PST	Match Postponed	  Postponed	 -- Postponed to another day, once the new date and time is known the status will change to Not Started
- CANC	Match Cancelled	  Cancelled	  -- Cancelled, match will not be played
- WO	WalkOver	      Not Played  -- Victory by forfeit or absence of competitor



```
Available fixtures status

SHORT	LONG	TYPE	DESCRIPTION
TBD	Time To Be Defined	Scheduled	Scheduled but date and time are not known
NS	Not Started	Scheduled	
1H	First Half, Kick Off	In Play	First half in play
HT	Halftime	In Play	Finished in the regular time
2H	Second Half, 2nd Half Started	In Play	Second half in play
ET	Extra Time	In Play	Extra time in play
BT	Break Time	In Play	Break during extra time
P	Penalty In Progress	In Play	Penaly played after extra time
SUSP	Match Suspended	In Play	Suspended by referee's decision, may be rescheduled another day
INT	Match Interrupted	In Play	Interrupted by referee's decision, should resume in a few minutes


ABD	Match Abandoned	Abandoned	Abandoned for various reasons (Bad Weather, Safety, Floodlights, Playing Staff Or Referees), Can be rescheduled or not, it depends on the competition
AWD	Technical Loss	Not Played	
LIVE	In Progress	In Play	Used in very rare cases. It indicates a fixture in progress but the data indicating the half-time or elapsed time are not available
```

