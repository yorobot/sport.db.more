require_relative 'helper'


url = Footballdata::Metal.competitions_url
pp url
#=> "http://api.football-data.org/v4/competitions"

# url for all competitions
# url = "http://api.football-data.org/v4/competitions-all" 

data = Webcache.read_json( url )
pp data
  
comps = data['competitions']


comps.each do |rec|
    print "==> "
    print "#{rec['area']['name']} (#{rec['area']['code']}) - "
    print "#{rec['name']} (#{rec['code']}) -- "
    print "#{rec['plan']} #{rec['type']}, "
    print "#{rec['numberOfAvailableSeasons']} season(s)"
    print "\n"

    print "     #{rec['currentSeason']['startDate']} - #{rec['currentSeason']['endDate']} "  
    print "@ #{rec['currentSeason']['currentMatchday']}"
    print "\n"
end


puts "  #{comps.size} competition(s)"


puts "bye"


__END__

club leagues 

==> England (ENG) - Premier League (PL) -- TIER_ONE LEAGUE, 126 season(s)
     2024-08-16 - 2025-05-25 @ 1
==> England (ENG) - Championship (ELC) -- TIER_ONE LEAGUE, 8 season(s)
     2024-08-09 - 2025-05-03 @ 1
==> France (FRA) - Ligue 1 (FL1) -- TIER_ONE LEAGUE, 81 season(s)
     2024-08-18 - 2025-05-18 @ 1
==> Germany (DEU) - Bundesliga (BL1) -- TIER_ONE LEAGUE, 61 season(s)
     2023-08-18 - 2024-05-18 @ 34
==> Italy (ITA) - Serie A (SA) -- TIER_ONE LEAGUE, 92 season(s)
     2023-08-19 - 2024-06-02 @ 38
==> Netherlands (NLD) - Eredivisie (DED) -- TIER_ONE LEAGUE, 69 season(s)
     2024-08-09 - 2025-05-18 @ 1
==> Portugal (POR) - Primeira Liga (PPL) -- TIER_ONE LEAGUE, 75 season(s)
     2023-08-13 - 2024-05-19 @ 34
==> Spain (ESP) - Primera Division (PD) -- TIER_ONE LEAGUE, 94 season(s)
     2024-08-18 - 2025-05-25 @ 1

==> Brazil (BRA) - Campeonato Brasileiro Série A (BSA) -- TIER_ONE LEAGUE, 8 season(s)
     2024-04-13 - 2024-12-08 @ 13


club int'l cups
==> Europe (EUR) - UEFA Champions League (CL) -- TIER_ONE CUP, 44 season(s)
     2023-09-19 - 2024-06-01 @ 6
==> South America (SAM) - Copa Libertadores (CLI) -- TIER_ONE CUP, 4 season(s)
     2024-02-07 - 2024-05-31 @ 6

national teams
==> Europe (EUR) - European Championship (EC) -- TIER_ONE CUP, 17 season(s)
     2024-06-14 - 2024-07-14 @ 4
==> World (INT) - FIFA World Cup (WC) -- TIER_ONE CUP, 22 season(s)
     2022-11-20 - 2022-12-18 @ 8
