# Debug Notes


```
wc 2026:
"MatchStatus"=>{1=>104},
 "ResultType"=>{0=>104},
 "Leg"=>{nil=>104},
 "IsHomeMatch"=>{nil=>104},
 "TeamType"=>{1=>126},
 "AgeType"=>{7=>126},
 "FootballType"=>{0=>126}}


add asserts for MatchStatus && TeamType
##     use a  opt_club flag - why? why not?
##         or better use a first_teamtype
##              and make sure all other match - cannot mix'n'match!!!

- [ ] use   MatchStatus 0 for complete?
         && MatchStatus 1 for future?

- [ ] use    TeamType  0 for club
          && TeamType  1 for national_team

- resulttype  0 - to be done
              1 - 90min,
              2 - aet, win on pens,
              3 - aet


wc 1930:
"MatchStatus"=>{0=>18},
 "ResultType"=>{1=>18},
 "Leg"=>{nil=>18},
 "IsHomeMatch"=>{nil=>18},
 "TeamType"=>{1=>36},
 "AgeType"=>{7=>36},
 "FootballType"=>{0=>36}}

wc 2018:
stats:{"MatchStatus"=>{0=>64}, "ResultType"=>{1=>59, 2=>4, 3=>1}}

wc 2022:
{"MatchStatus"=>{0=>64},
 "ResultType"=>{1=>59, 2=>5},
 "Leg"=>{nil=>64},
 "IsHomeMatch"=>{nil=>64},
 "TeamType"=>{1=>128},
 "AgeType"=>{7=>128},
 "FootballType"=>{0=>128}}

cwc 2023:
stats:{"MatchStatus"=>{0=>7}, "ResultType"=>{1=>7}}



cwc 2025:
  - data error   pachuca vs salzburg => resulttype 0!!
"MatchStatus"=>{0=>63},
 "ResultType"=>{1=>59, 0=>1, 3=>3},
 "Leg"=>{nil=>63},
 "IsHomeMatch"=>{nil=>63},
 "TeamType"=>{0=>126},
 "AgeType"=>{7=>126},
 "FootballType"=>{0=>126}}



 ---

- [ ] add support for __END__ to csv parser!!!

__END__

## pp  Fifa._idSeason_by_year!( name: 'at', season: '2025-26' )
pp  Fifa._idSeason_by_year!( name: 'at', season: '2020-21' )

[]
[{"league"=>"at", "seasons"=>"2020/21"},
 {"league"=>"__END__", "seasons"=>nil},
 {"league"=>"pp  Fifa._idSeason_by_year!( name: 'at'", "seasons"=>"season: '2020-21' )"}]

 ```