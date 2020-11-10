# football-sources - get football data via web pages or web api (json) calls


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/football-sources](https://rubygems.org/gems/football-sources)
* rdoc  :: [rubydoc.info/gems/football-sources](http://rubydoc.info/gems/football-sources)
* forum :: [groups.google.com/group/opensport](https://groups.google.com/group/opensport)


## Usage



### `football-data.org` - ur src for machine readable football data

Daniel's dev-friendly football API
offers a free to use plan
for 12 leagues (API key sign-up and use required).
See [`football-data.org` »](https://www.football-data.org)


**Step 0 - Setup Secrets**

Set the API key / token in the env(ironement).
Example:

```
set FOOTBALLDATA=1234567890abcdef1234567890abcdef
```


**Step 1 - Download Match Schedules**

Download the match schedules (in json) via api calls
to your (local) web cache (in `~/.cache`).
Note: The free trier has a 10 request/minute limit,
thus, sleep/wait 10 secs after every request
(should result in ~6 requests/minute).


``` ruby
require 'football/sources'


#############
## download up (ongoing) 2020 or 2020/21 seasons

Webget.config.sleep  = 10

Footballdata.schedule( league: 'eng.1', season: '2020/21' )
Footballdata.schedule( league: 'eng.2', season: '2020/21' )

Footballdata.schedule( league: 'de.1', season: '2020/21' )
Footballdata.schedule( league: 'es.1', season: '2020/21' )

Footballdata.schedule( league: 'fr.1', season: '2020/21' )
Footballdata.schedule( league: 'it.1', season: '2020/21' )

Footballdata.schedule( league: 'nl.1', season: '2020/21' )
Footballdata.schedule( league: 'pt.1', season: '2020/21' )

Footballdata.schedule( league: 'cl',   season: '2020/21' )

# note: Brasileirão - season is a calendar year (NOT an academic year)
Footballdata.schedule( league: 'br.1', season: '2020' )
```

Note: You can find all downloaded match schedules
in your (local) web cache (in `~/.cache/api.football-data.org`) as pretty printed json documents.




**Step 2 - Convert (Cached) Match Schedules to Records**

Convert the (cached) match schedules
in JSON to the one-line, one-record
"standard" [Football.CSV format](https://github.com/footballcsv). Example.

``` ruby
require 'football/sources'

['eng.1', 'eng.2',
 'de.1',
 'es.1',
 'fr.1',
 'it.1',
 'nl.1',
 'pt.1',
 'cl',
].each do |league|
  Footballdata.convert( league: league, season: '2020/21' )
end

Footballdata.convert( league: 'br.1', season: '2020' )
```

Note: By default all datasets get written into the `./o`
directory.  Use `Footballdata.config.convert.out_dir`
to change the output directory.

The English Premier League (`eng.1`) results in `./o/2020-21/eng.1.csv`:

```
Matchday,Date,Team 1,FT,HT,Team 2,Comments
1,Sun Sep 13 2020,Manchester City FC,(*),,Aston Villa FC,postponed
1,Sun Sep 13 2020,Burnley FC,(*),,Manchester United FC,postponed
1,Sat Sep 12 2020,Fulham FC,0-3,0-1,Arsenal FC,
1,Sat Sep 12 2020,Crystal Palace FC,1-0,1-0,Southampton FC,
1,Sat Sep 12 2020,Liverpool FC,4-3,3-2,Leeds United FC,
1,Sat Sep 12 2020,West Ham United FC,0-2,0-0,Newcastle United FC,
1,Sun Sep 13 2020,West Bromwich Albion FC,0-3,0-0,Leicester City FC,
1,Sun Sep 13 2020,Tottenham Hotspur FC,0-1,0-0,Everton FC,
1,Mon Sep 14 2020,Sheffield United FC,0-2,0-2,Wolverhampton Wanderers FC,
1,Mon Sep 14 2020,Brighton & Hove Albion FC,1-3,0-1,Chelsea FC,
2,Sat Sep 19 2020,Everton FC,5-2,2-1,West Bromwich Albion FC,
2,Sat Sep 19 2020,Leeds United FC,4-3,2-1,Fulham FC,
2,Sat Sep 19 2020,Manchester United FC,1-3,0-1,Crystal Palace FC,
2,Sat Sep 19 2020,Arsenal FC,2-1,1-1,West Ham United FC,
2,Sun Sep 20 2020,Southampton FC,2-5,1-1,Tottenham Hotspur FC,
2,Sun Sep 20 2020,Newcastle United FC,0-3,0-2,Brighton & Hove Albion FC,
2,Sun Sep 20 2020,Chelsea FC,0-2,0-0,Liverpool FC,
2,Sun Sep 20 2020,Leicester City FC,4-2,1-1,Burnley FC,
2,Mon Sep 21 2020,Aston Villa FC,1-0,0-0,Sheffield United FC,
2,Mon Sep 21 2020,Wolverhampton Wanderers FC,1-3,0-2,Manchester City FC,
...
```

Or the Brasileirão (`br.1`) in  `./o/2020/br.1.csv`:

```
Matchday,Date,Team 1,FT,HT,Team 2,Comments
1,Sat Aug 8 2020,Fortaleza EC,0-2,0-2,CA Paranaense,
1,Sat Aug 8 2020,Coritiba FBC,0-1,0-0,SC Internacional,
1,Sun Aug 9 2020,SC Recife,3-2,3-1,Ceará SC,
1,Sun Aug 9 2020,Santos FC,1-1,0-0,RB Bragantino,
1,Sun Aug 9 2020,CR Flamengo,0-1,0-1,CA Mineiro,
1,Sun Aug 9 2020,Goiás EC,(*),,São Paulo FC,postponed
1,Sun Aug 9 2020,Grêmio FBPA,1-0,1-0,Fluminense FC,
1,Sun Aug 9 2020,SE Palmeiras,(*),,CR Vasco da Gama,postponed
2,Wed Aug 12 2020,CA Mineiro,3-2,0-2,SC Corinthians Paulista,
2,Wed Aug 12 2020,CA Paranaense,2-1,1-1,Goiás EC,
2,Wed Aug 12 2020,RB Bragantino,1-1,1-0,Botafogo FR,
2,Wed Aug 12 2020,AC Goianiense,3-0,2-0,CR Flamengo,
2,Wed Aug 12 2020,EC Bahia,1-0,1-0,Coritiba FBC,
2,Thu Aug 13 2020,Fluminense FC,1-1,1-1,SE Palmeiras,
2,Thu Aug 13 2020,Ceará SC,1-1,1-0,Grêmio FBPA,
2,Thu Aug 13 2020,São Paulo FC,1-0,1-0,Fortaleza EC,
2,Thu Aug 13 2020,SC Internacional,2-0,0-0,Santos FC,
2,Thu Aug 13 2020,CR Vasco da Gama,2-0,2-0,SC Recife,
...
```



That's it for now. More sources upcoming.

## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `football-sources` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
