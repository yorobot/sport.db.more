#### todo/check: move MODS and SCORE_ERRORS out-of-lib
##               and into config or such - why? why not?


module Worldfootball


######
# "global" helpers
def self.norm_team( team )
   ## clean team name and asciify (e.g. ’->' )
   team = team.sub( '(old)', '' ).strip
   team = team.gsub( '’', "'" )     ## e.g. Hawke’s Bay United FC

   ## Criciúma - SC     =>     Criciúma - SC
   ## Bahia - BA        =>     Bahia - BA
   ##  remove inline dash ( - ) with single space
   team = team.gsub( /[ ]+[-][ ]+/, ' ' )


   ##   todo:
   ##  replace (A)  with II
   ##    Austria Wien (A)   =>   Austria Wien (A)
   ##   others too?  - move to mods instead of generic rule - why? why not?
   team = team.sub( /[ ]+\(A\)/, ' II' )

   team
end



MODS = {}

=begin
MODS = {
 'at' => {
    ## AT 1
    'SC Magna Wiener Neustadt' => 'SC Wiener Neustadt', # in 2010/11
    'KSV Superfund'            => 'Kapfenberger SV',    # in 2010/11
    'Kapfenberger SV 1919'     => 'Kapfenberger SV',    # in 2011/12
    'FC Trenkwalder Admira'    => 'FC Admira Wacker',    # in 2011/12
    ## AT 2
    'Austria Wien (A)'         => 'Young Violets',  # in 2019/20
    'FC Wacker Innsbruck (A)'  => 'FC Wacker Innsbruck II',   # in 2018/19
    ## AT CUP
    'Rapid Wien (A)'           => 'Rapid Wien II',  # in 2011/12
    'Sturm Graz (A)'           => 'Sturm Graz II',
    'Kapfenberger SV 1919 (A)' => 'Kapfenberger SV II',
    'SV Grödig (A)'            => 'SV Grödig II',
    'RB Salzburg (A)'          => 'RB Salzburg II',
    'SR WGFM Donaufeld'        => 'SR Donaufeld Wien',
    'FC Trenkwalder Admira (A)' => 'FC Admira Wacker II',
    ## AT 3.O (Regionalliga Ost)
    'FC Admira Wacker (A)'     => 'FC Admira Wacker II',  # in 2020/21
  },
 'nz' => {
    ## NZ 1
   'Wellington Phoenix (R)' => 'Wellington Phoenix Reserves',
  },
}
=end


## fix/patch known score format errors in at/de cups
##   new convention
##   for a fix require league, date, and team1 & team2 for now!!!!
##    - do NOT use some "generic" fix / patch!!!!
##
## old de/at patches/fixes:
##  '0-1 (0-0, 0-0, 0-0) n.V.' => '0-1 (0-0, 0-0) n.V.',       # too long
##  '2-1 (1-1, 1-1, 1-0) n.V.' => '2-1 (1-1, 1-1) n.V.',
##  '4-2 (0-0, 0-0) i.E.'      => '4-2 (0-0, 0-0, 0-0) i.E.',  # too short


SCORE_ERRORS = {
  'ro.1' => {
    ## 2013/14
    '2013-07-29' => [ 'FC Brașov', 'Săgeata Năvodari', ['1-1 (0-0, 0-1)', '1-1 (0-0)']],
  },
  'gr.1' => {
    ## 2010/11
    '2010-11-24' => [ 'Ergotelis',    'Olympiakos Piräus', ['0-2 (0-0, 0-0, 0-0)', '0-2 (0-0)']],
    '2010-11-28' => [ 'Panserraikos', 'Aris Saloniki',     ['1-0 (1-0, 0-0, 0-0)', '1-0 (1-0)']],
  },
  'at.cup' => {
     ## 2023/24
     '2023-07-22' => [ 'SV Leobendorf', 'SV Horn', ['3-2 (2-0, 2-2, 3-2) n.V.', '3-2 (2-0, 2-2) n.V.']],
  },
}


end # module Worldfootball
