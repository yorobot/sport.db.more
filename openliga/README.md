


## What's missing (upstream)?

the only match status is  finished: true|false, that is,
there is no cancelled, annulled, awarded, abandonded, etc.



**What else?**

weirdo "legacy" match result (duplicate entries) with kind 'Unknown' e.g.

```
!! warn - weirdo 'Unknown/Nachspielzeit' results found  in
- name="DFB Pokal 2025/2026", season="2025", shortcut="dfb"

!! warn - weirdo 'Unknown/nach 90 Minuten' results found in
- name="DFB-Pokal 2023/2024", season="2023", shortcut="dfb"
- name="DFB-Pokal 2022/23", season="2022", shortcut="dfb2022"
- name="DFB-Pokal 2021/22", season="2021", shortcut="dfb2021"
- name="DFB-Pokal 2020/21", season="2020", shortcut="dfb2020"
```


data errors:


```
name="3. Fußball-Bundesliga 2022/2023", season="2022",
!! warn - skipping match with team missing:
{"matchID"=>67822,
 "matchDateTime"=>"2023-09-09T15:30:00",
 "timeZoneID"=>nil,
 "leagueId"=>4570,
 "leagueName"=>"3. Fußball-Bundesliga 2022/2023",
 "leagueSeason"=>2022,
 "leagueShortcut"=>"bl3",
 "matchDateTimeUTC"=>"2023-09-09T13:30:00Z",
 "group"=>{"groupName"=>"4. Spieltag", "groupOrderID"=>4, "groupID"=>40156},
 "team1"=>{"teamId"=>0, "teamName"=>nil, "shortName"=>nil, "teamIconUrl"=>nil, "teamGroupName"=>nil},
 "team2"=>{"teamId"=>0, "teamName"=>nil, "shortName"=>nil, "teamIconUrl"=>nil, "teamGroupName"=>nil},
 "lastUpdateDateTime"=>"2026-05-23T14:41:39.19",
 "matchIsFinished"=>false,  ... }
```