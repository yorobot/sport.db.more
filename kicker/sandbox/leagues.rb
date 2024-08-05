


## note - season format is
##           2024-25
##           2023-24
##            etc.
##           check for 1999-00 ??
##   yes - 1999-00

# https://www.kicker.de/bundesliga-oesterreich/teams/2023-24/
# https://www.kicker.de/bundesliga-oesterreich/teams/2024-25/


BASE_URL = 'https://www.kicker.de'


LEAGUES = {
    'at.1'   => 'bundesliga-oesterreich/teams/{season}',
    'at.2'   =>  '2-liga-oesterreich/teams/{season}',
    'at.3.o'  =>  'regionalliga-ost-oesterreich/teams/{season}',
    'at.cup' =>  'oefb-cup/teams/{season}',

    'de.1'   => 'bundesliga/teams/{season}',
    'de.2'   => '2-bundesliga/teams/{season}',
    'de.3'     => '3-liga/teams/{season}', 
    'de.4.bayern' => 'regionalliga-bayern/teams/{season}',
    'de.cup' => 'dfb-pokal/teams/{season}',

    'ch.1'   => 'super-league-schweiz/teams/{season}',
    'ch.2'   => 'challenge-league/teams/{season}',
    'ch.cup' =>  'schweizer-cup/teams/{season}',

    'be.1'   =>  'division-1a/teams/{season}',
    'nl.1'   =>  'eredivisie/teams/{season}',

     'tr.1'   =>  'sueper-lig/teams/{season}',

     'eng.1' =>  'premier-league/teams/{season}',
     'es.1'  =>  'la-liga/teams/{season}',
     'it.1'  =>  'serie-a/teams/{season}',
     'fr.1'  =>  'ligue-1/teams/{season}',


     'uefa.cl'   => 'champions-league/teams/{season}',
     'uefa.el'   => 'europa-league/teams/{season}',
     'uefa.conf' => 'europa-conference-league/teams/{season}',

     'mx.1'  =>  'liga-mx/teams/{season}',
}
