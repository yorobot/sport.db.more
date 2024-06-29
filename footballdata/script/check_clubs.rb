##
#
# todos / ideas
#  - [ ]  check for shortname if same as canonical (do NOT report)
#
# -  [ ] check for shortnames too (if present/match)


require 'cocos'

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'footballdata' 



pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"

Webcache.root = '../../../cache'  ### c:\sports\cache

TEAMS = {}

def check( league:, year: )
  root = "#{Webcache.root}/api.football-data.org"
  path         = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  path_teams   = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~teams-I-season~#{year}.json"

  data         = read_json( path )
  data_teams   = read_json( path_teams )

  ## build a (reverse) team lookup by name
  puts "==>  #{league} #{year} - #{data_teams['teams'].size} teams"

  teams_by_name = data_teams['teams'].reduce( {} ) do |h,rec|
     h[ rec['name'] ] = rec
     h
  end

  pp teams_by_name.keys


  matches = data[ 'matches']
  matches.each do |m|

    [m['homeTeam']['name'],
     m['awayTeam']['name']].each do |team|

      ## skip if name nil  
      if team.nil?
        puts "  skipping empty team (no name) in match"
        next
      end

       team_hash = teams_by_name[ team ]
       if team_hash.nil?
          puts "!! error - no team by name record found for >#{team}< in match:"
          pp m
          exit 1
       end

       rec = TEAMS[ team ] ||= { count: 0,
                                 short:   team_hash['shortName'],
                                 country: team_hash['area']['name'],
                                 address: team_hash['address'],
                               }
       rec[ :count ] += 1
    end # each team

  end # each match

end # method check


## ==>  uefa.cl 2022 - 79 teams
##      uefa.cl 2023 - 32 teams

## ==>  copa.l 2023 - 47 teams
##      copa.l 2024 - 47 teams



DATASETS = [
           ['uefa.cl',    %w[2020 2021 2022 2023]],
           ['copa.l', %w[2023 2024]],
           ['eng.1', %w[2020 2021 2022 2023]],
           ['eng.2', %w[2020 2021 2022 2023]],
           ['de.1', %w[2020 2021 2022 2023]],
           ]

pp DATASETS


DATASETS.each do |dataset|
  basename = dataset[0]
  dataset[1].each do |year|
    check( league: basename, year: year )
  end
end

pp TEAMS



$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

CatalogDb::Metal.tables


puts
puts "==> #{TEAMS.keys.size} teams"


#######################
# check and normalize team names

TEAMS.each_with_index do |(team_name, team_hash),i|

   country_name = team_hash[ :country ]
  

   country = SportDb::Import.world.countries.find( country_name )
   if country.nil?
     puts "!! ERROR: no mapping found for country >#{country_name}<:"
     pp team_name
     pp team_hash
     exit 1
   end


   ## note - use lookup with country required
   club = SportDb::Import.catalog.clubs.find_by( 
                                  name:    team_name,
                                  country: country )
   if club.nil?
    puts "!! ERROR: no mapping found for club >#{team_name}, #{country.name}<:"
    pp team_hash
    ## exit 1
   else
    if team_name != club.name
       ## check for short name matching club name??
       if team_hash[:short] == club.name
         puts "    #{i+1} -   #{team_name} | >>#{team_hash[:short]}<<, #{team_hash[:country]}"    
       else
         puts " != #{i+1} -   #{team_name} | #{team_hash[:short]}  =>  #{club.name}, #{country.name}"  
         puts "             @ #{team_hash[:address]} > #{team_hash[:country]}"
       end
    else
      ## todo - cleanup country name equals check
      if team_hash[:country] != club.country.name
         print " !! "
      else
         print "    "
      end
      print "#{i+1} -   >>#{team_name}<< | #{team_hash[:short]}"
      if team_hash[:country] != club.country.name
        print ", #{team_hash[:country]} != #{club.country.name}"      
      else
        print ", #{team_hash[:country]}"
      end    
      print "\n"
    end 
   end
end

puts "bye"

