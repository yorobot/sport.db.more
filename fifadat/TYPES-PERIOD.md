
# Type - Period

```
period = 4				->			half time
period = 6 				->			extra time
period = 8				->			extra half time
period = 11				-> 			penalty shootouts
period = 10				->			full time

note -  Only MatchStatus is not sufficient to find the current state of the match. You need another variable known as Period. This int has five known values viz.,

 4 - ‘half time’
 6 - ‘extra time’
 8, - ‘extra half time’
 10 - ‘full time’     -- end of match (incl. possibly extra time and/or penalty shootouts!!!)
 11 - ‘penalty shootouts’

So end of the match is detected as — if(MatchStatus == 0 && Period == 10)

 try to decipher period values
         0  - ??    91'
         1  - ??
         2  - ??

  1H      |   3  - 1st half    (1'-45' or 45'+7')  -- 0' possible!!
  HALF    |      4  - half time              --  45'+1'
  2H      |  5  - 2nd half    (46'-90' or 90'+5')
  ET      |      6  - extra time (end of reg 90 min time)
  ET-1H   |  7  - 1s half extra time  (91'-105' or 105'+1')
  ET-HALF |      8  - extra time half time   --  105' or 106'
  ET-2H   |  9  - 2nd half extra time (106'-120' or 120'+1')
  END     |      10 - "full time"  (end of match incl. possibly extra time and/or penalty shootout!!)
  PENS    | 11 - penalty shoot-out  (121'-)


Some feeds expose this as strings instead
(1H, HALF, 2H, END-REG,
 ET 1H, HALF-ET, ET 2H, END-ET,
 PENS, END-PENS
).

---
match period:

ai suggests:  This field is much easier because FIFA uses it consistently.

Value	Meaning
0	??  Before kickoff
1   ??
2   ??
3	1st Half
4	Half-time
5	2nd Half
6	End of Normal Time

7	ET 1st Half
8	ET Half-time
9	ET 2nd Half
10	End of Match  / incl.  Extra Time and/or End of Penalties
11	Penalty Shootout


```