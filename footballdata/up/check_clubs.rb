############
# to run use:
#    $ ruby up/check_clubs.rb


#
# todos / ideas
#  - [ ]  check for shortname if same as canonical (do NOT report)
#
# -  [ ] check for shortnames too (if present/match)


require_relative  'helper'


pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"




TEAMS = {}


def check( league:, season: )
  root = "#{Webcache.root}/api.football-data.org"

  season = Season( season )
  league_code = Footballdata::LEAGUES[league.downcase]
  year = season.start_year

  path         = "#{root}/v4~~competitions~~#{league_code}~~matches-I-season~#{year}.json"
  path_teams   = "#{root}/v4~~competitions~~#{league_code}~~teams-I-season~#{year}.json"

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
           ['uefa.cl',    %w[2020/21 2021/22 2022/23 2023/24]],
           ['copa.l', %w[2023 2024]],
           ['eng.1', %w[2020/21 2021/22 2022/23 2023/24]],
           ['eng.2', %w[2020/21 2021/22 2022/23 2023/24]],
           ['de.1', %w[2020/21 2021/22 2022/23 2023/24]],
           ]

pp DATASETS


DATASETS.each do |dataset|
  league  = dataset[0]
  seasons = dataset[1]
  seasons.each do |season|
    check( league: league, season: season )
  end
end

pp TEAMS

puts
puts "==> #{TEAMS.keys.size} teams"





#######################
# check and normalize team names

TEAMS.each_with_index do |(team_name, team_hash),i|

   country_name = team_hash[ :country ]
  
   country = Country.find_by( name: country_name )
   if country.nil?
     puts "!! ERROR: no mapping found for country >#{country_name}<:"
     pp team_name
     pp team_hash
     exit 1
   end

   ## note - use lookup with country required
   club = Club.find_by( name:    team_name,
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

