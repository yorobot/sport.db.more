# (JSON) APIs (JSON)

Try some football (JSON) APIs for the worldcup & friends


## Unofficial FIFA

<https://api.fifa.com/api/v3/calendar/matches?count=100&idSeason=255711>


FIFA World Cup 2026  

<https://api.fifa.com/api/v3/calendar/matches?count=500&idSeason=285023&language=en>

<https://api.fifa.com/api/v3/stages?idSeason=285023&language=en>



 match data via fifa api
brazil 2014
see <https://www.fifa.com/en/match-centre?date=2014-06-12>
uruguay 1930 
see <https://www.fifa.com/en/match-centre?date=1930-07-13>


docu via <https://givevoicetofootball.github.io/api/>



```
To get ALL seasons for a FIFA Tournament (for example FU20 Women’s World Cup):
API_ROOT/seasons/search?name=FIFA%20U-20%20Women%20World%20Cup

To get the details of a specific season:
API_ROOT/seasons/278491

To get ALL Stages of the season:
API_ROOT/stages?idSeason=278491&idCompetition=108

To get all the Squad of the season:
API_ROOT/teams/squads/all/108/278491

To retrieve all players:
API_ROOT/players/seasons/278491?count=1000

To retrieve all coaches:
API_ROOT/coaches/season/278491

To get ALL matches:
API_ROOT/calendar/matches?idSeason=278491&idCompetition=108&count=100

To get matches for a specific stage:
API_ROOT/calendar/matches?idSeason=278491&idCompetition=108&idStage=278493

To get the standings for a Stage:
API_ROOT/calendar/108/278491/278493/Standing

To get the standings for a specific Group:
API_ROOT/calendar/108/278491/278493/Standing?idGroup=278497

To get the line-ups of a Match:
API_ROOT/live/football/108/278491/278493/300424860?language=en-GB

To get the timeline (live events) of a Match:
API_ROOT/timelines/108/278491/278493/300424860?language=en-GB

To get the Season stats:
API_ROOT/topseasonplayerstatistics/season/278491/topscorers

API_ROOT/topseasonteamstatistics/season/278491/topscorers

To get Team or Player stats:
API_ROOT/seasonstatistics/season/278491/team/1888591

API_ROOT/seasonstatistics/season/278491/team/1888591/players

```

seasons search by "world cup"
 128 result(s)
 
a43ylo3ozw62lw2qcnv3hlqfo 2y0bs9z3jy1tvxkbgey8ac9p0 -- FIFA Club World Cup Play-In 2025
289085 17 -- FIFA World Cup 2030™
289087 17 -- FIFA World Cup 2034™
286466 107 -- FIFA Club World Cup Morocco 2022™
289120 103 -- FIFA Women’s World Cup Brazil 2027™
289175 10005 -- FIFA Club World Cup 2025™
288439 106 -- FIFA Futsal World Cup Uzbekistan 2024™
291833 FCWC_MCQ -- FIFA Club World Cup 2025™ Play-in
292977 516 -- FIFA U-17 Women's World Cup Morocco 2026™
288910 500 -- FIFA Beach Soccer World Cup Seychelles 2025™
292937 102 -- FIFA U-17 World Cup Qatar 2026™
287535 500 -- FIFA Beach Soccer World Cup UAE 2024 Dubai™
291518 108 -- FIFA U-20 Women’s World Cup Poland 2026™
288226 108 -- FIFA U-20 Women’s World Cup Colombia 2024™
284700 104 -- FIFA U-20 World Cup Argentina 2023™
284715 102 -- FIFA U-17 World Cup Indonesia 2023™
290025 104 -- FIFA U-20 World Cup Chile 2025™
50 17 -- 1978 FIFA World Cup Argentina™
288301 520 -- FIFA World Cup 26™ Concacaf Qualifiers
21 17 -- 1962 FIFA World Cup Chile™
5 17 -- 1938 FIFA World Cup France™
76 17 -- 1990 FIFA World Cup Italy™
255711 17 -- FIFA World Cup Qatar 2022™
68 17 -- 1986 FIFA World Cup Mexico™
288319 520 -- FIFA World Cup 26™ OFC Qualifiers
15 17 -- 1958 FIFA World Cup Sweden™
59 17 -- 1982 FIFA World Cup Spain™
84 17 -- 1994 FIFA World Cup USA™
1013 17 -- 1998 FIFA World Cup France™
7 17 -- 1950 FIFA World Cup Brazil™
287833 107 -- FIFA Club World Cup Saudi Arabia 2023™
288263 520 -- FIFA World Cup 26™ AFC Qualifiers
26 17 -- 1966 FIFA World Cup England™
289795 10007 -- FIFA Futsal Women's World Cup Philippines 2025™
39 17 -- 1974 FIFA World Cup Germany™
3 17 -- 1934 FIFA World Cup Italy™
9 17 -- 1954 FIFA World Cup Switzerland™
288315 520 -- FIFA World Cup 26™ CONMEBOL Qualifiers
285023 17 -- FIFA World Cup 2026™
4735 107 -- FIFA Club World Championship Toyota Cup Japan 2005™
249414 102 -- FIFA U-17 World Cup Korea 2007™
278513 103 -- FIFA Women's World Cup France 2019™
285345 107 -- FIFA Club World Cup UAE 2021™
250695 107 -- FIFA Club World Cup Japan 2008™
286158 520 -- FIFA World Cup Qatar 2022™ Qualifiers
1 17 -- 1930 FIFA World Cup Uruguay™
254645 17 -- 2018 FIFA World Cup Russia™
32 17 -- 1970 FIFA World Cup Mexico™
259689 107 -- FIFA Club World Cup Morocco 2014™
251164 17 -- 2014 FIFA World Cup Brazil™
9741 17 -- 2006 FIFA World Cup Germany™
288329 520 -- FIFA World Cup 26™ UEFA Qualifiers
266030 103 -- FIFA Women's World Cup Canada 2015™
275916 102 -- FIFA U-17 World Cup India 2017™
275724 107 -- FIFA Club World Cup Japan 2015™
4644 103 -- FIFA Women's World Cup USA 1999™
252901 107 -- FIFA Club World Cup UAE 2009™
288282 520 -- FIFA World Cup 26™ CAF Qualifiers
249400 104 -- FIFA U-20 World Cup Canada 2007™
250123 106 -- FIFA Futsal World Cup Brazil 2008™
276100 107 -- FIFA Club World Cup Japan 2016™
252879 500 -- FIFA Beach Soccer World Cup Dubai 2009™
10232 103 -- FIFA Women's World Cup China 2007™
255627 104 -- FIFA U-20 World Cup Colombia 2011™
273811 500 -- FIFA Beach Soccer World Cup Portugal 2015™
281971 104 -- FIFA U-20 World Cup Poland 2019™
259221 104 -- FIFA U-20 World Cup Turkey 2013™
276136 107 -- FIFA Club World Cup UAE 2018™
281969 102 -- FIFA U-17 World Cup Brazil 2019™
283878 107 -- FIFA Club World Cup Qatar 2019™
255709 102 -- FIFA U-17 World Cup Mexico 2011™
259665 107 -- FIFA Club World Cup Morocco 2013™
249926 107 -- FIFA Club World Cup Japan 2007™
285011 500 -- FIFA Beach Soccer World Cup Russia 2021™
270352 102 -- FIFA U-17 World Cup Chile 2015™
284690 107 -- FIFA Club World Cup Qatar 2020™
3373 103 -- FIFA Women's World Cup China PR 1991™
249715 17 -- 2010 FIFA World Cup South Africa™
291725 521 -- FIFA Women's World Cup 2027™ AFC Qualifiers
254476 107 -- FIFA Club World Cup UAE 2010™
258492 107 -- FIFA Club World Cup Japan 2012™
276118 107 -- FIFA Club World Cup UAE 2017™
251195 500 -- FIFA Beach Soccer World Cup Marseille 2008™
292287 521 -- FIFA Women's World Cup 2027™ CONMEBOL Qualifiers
292616 520 -- FIFA World Cup 2026™ Play-Off Tournament
251475 103 -- FIFA Women's World Cup Germany 2011™
255905 106 -- FIFA Futsal World Cup Thailand 2012™
259249 102 -- FIFA U-17 World Cup UAE 2013™
275471 106 -- FIFA Futsal World Cup Colombia 2016™
4395 17 -- 2002 FIFA World Cup Korea/Japan™
251792 104 -- FIFA U-20 World Cup Egypt 2009™
292297 521 -- FIFA Women's World Cup 2027™ Concacaf Qualifiers
290907 521 -- FIFA Women's World Cup 2027™ CAF Qualifiers
259277 500 -- FIFA Beach Soccer World Cup Tahiti 2013™
276973 500 -- FIFA Beach Soccer World Cup Bahamas 2017™
283062 106 -- FIFA Futsal World Cup Lithuania 2021™
6929 103 -- FIFA Women's World Cup USA 2003™
4654 103 -- FIFA Women's World Cup Sweden 1995™
292273 521 -- FIFA Women's World Cup 2027™ OFC Qualifiers
257425 107 -- FIFA Club World Cup Japan 2011™
248388 107 -- FIFA Club World Cup Japan 2006™
282442 500 -- FIFA Beach Soccer World Cup Paraguay 2019™
251806 102 -- FIFA U-17 World Cup Nigeria 2009™
292312 521 -- FIFA Women's World Cup 2027™ UEFA Qualifiers
290333 516 -- FIFA U-17 Women's World Cup Morocco 2025™
258151 516 -- FIFA U-17 Women's World Cup Azerbaijan 2012™
248211 500 -- FIFA Beach Soccer World Cup Rio de Janeiro 2006™
275945 104 -- FIFA U-20 World Cup Korea Republic 2017™
253557 516 -- FIFA U-17 Women's World Cup Trinidad & Tobago 2010™
290184 102 -- FIFA U-17 World Cup Qatar 2025™
249934 516 -- FIFA U-17 Women's World Cup New Zealand 2008™
10057 500 -- FIFA Beach Soccer World Cup Rio de Janeiro 2005™
255567 500 -- FIFA Beach Soccer World Cup Ravenna/Italy 2011™
283693 516 -- FIFA U-17 Women's World Cup India 2022™
278491 108 -- FIFA U-20 Women's World Cup France 2018™
275983 108 -- FIFA U-20 Women's World Cup Papua New Guinea 2016™
264468 108 -- FIFA U-20 Women's World Cup Canada 2014™
258153 108 -- FIFA U-20 Women's World Cup Japan 2012™
275894 516 -- FIFA U-17 Women's World Cup Jordan 2016™
264466 516 -- FIFA U-17 Women's World Cup Costa Rica 2014™
270380 104 -- FIFA U-20 World Cup New Zealand 2015™
285026 103 -- FIFA Women’s World Cup Australia & New Zealand 2023™
288898 516 -- FIFA U-17 Women's World Cup Dominican Republic 2024™
250255 108 -- FIFA U-20 Women's World Cup Chile 2008™
278110 516 -- FIFA U-17 Women's World Cup Uruguay 2018™
253535 108 -- FIFA U-20 Women's World Cup Germany 2010™
249915 500 -- FIFA Beach Soccer World Cup Rio de Janeiro 2007™
283933 108 -- FIFA U-20 Women’s World Cup Costa Rica 2022™





