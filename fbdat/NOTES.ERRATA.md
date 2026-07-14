# Errata Notes


fix penalties score in cl 2024/25 (in fbdat)???

- Duration is wrong ?!    - ignore?? and use if present extraTime and penalties???


```
"score": {g
        "winner": "AWAY_TEAM",
        "duration": "REGULAR",
        "fullTime": {
          "home": 1,
          "away": 4
        },
        "halfTime": {
          "home": 0,
          "away": 1
        },
        "regularTime": {
          "home": 0,
          "away": 1
        },
        "extraTime": {
          "home": 0,
          "away": 0
        },
        "penalties": {
          "home": 0,
          "away": 0
        }
      },

-- or

   "score": {
        "winner": "AWAY_TEAM",
        "duration": "REGULAR",
        "fullTime": {
          "home": 2,
          "away": 4
        },
        "halfTime": {
          "home": 1,
          "away": 0
        },
        "regularTime": {
          "home": 1,
          "away": 0
        },
        "extraTime": {
          "home": 0,
          "away": 0
        },
        "penalties": {
          "home": 0,
          "away": 0
        }
   

yes, in Season 2023/24 uses penalty_shootout .g.

    "score": {
        "winner": "HOME_TEAM",
        "duration": "PENALTY_SHOOTOUT",
        "fullTime": {
          "home": 5,
          "away": 2
        },
        "halfTime": {
          "home": 1,
          "away": 0
        },
        "regularTime": {
          "home": 1,
          "away": 0
        },
        "extraTime": {
          "home": 0,
          "away": 0
        },
        "penalties": {
          "home": 4,
          "away": 2
        }
```