############
# to run use:
#    $ ruby up/check_seasons.rb


## todos:
##  - [ ] use all-in-one check dataset (clubs+seasons etc.)


require_relative  'helper'


require_relative 'datasets'



pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"


def check( league:, season: )

  season = Season( season )
  league_code = Footballdata::LEAGUES[league.downcase]

  year = season.start_year

  root = "#{Webcache.root}/api.football-data.org"
  path         = "#{root}/v4~~competitions~~#{league_code}~~matches-I-season~#{year}.json"
  path_teams   = "#{root}/v4~~competitions~~#{league_code}~~teams-I-season~#{year}.json"

  data         = read_json( path )
  data_teams   = read_json( path_teams )

=begin
 "resultSet": {
    "count": 306,
    "first": "2020-09-18",
    "last": "2021-05-22",
    "played": 306
=end

  ## build a (reverse) team lookup by name
  print "    #{league} #{season} - "
  print "#{data_teams['teams'].size} teams, "
  print "#{data['resultSet']['played']} / #{data['resultSet']['count']} matches, "

  start_date = data['matches'][0]['season']['startDate']
  first_date = data['resultSet']['first']

  print "start: #{start_date}, "

  end_date  = data['matches'][0]['season']['endDate']
  last_date = data['resultSet']['last'] 

  print "end: #{end_date}"
  print "\n"

  if start_date != first_date
    puts "  !! season start date <> first date (in results) - #{first_date}"
  end
  if end_date != last_date
    puts "  !! season end date <> last date (in results) - #{last_date}"
  end
end # method check


## ==>  uefa.cl 2022 - 79 teams
##      uefa.cl 2023 - 32 teams

## ==>  copa.l 2023 - 47 teams
##      copa.l 2024 - 47 teams


=begin
DATASETS = [
           ['uefa.cl',    %w[2020 2021 2022 2023]],
           ['copa.l', %w[2023 2024]],
           ['eng.1', %w[2020 2021 2022 2023]],
           ['eng.2', %w[2020 2021 2022 2023]],
           ['de.1', %w[2020 2021 2022 2023]],
           ]

pp DATASETS
=end

DATASETS_EXTRA = [
             ['uefa.cl',  %w[2023/24 2022/23 2021/22 2020/21]],
             ['copa.l',   %w[2024 2023]],

             ['euro',  %w[2024 2021]],
             ['world', %w[2022]],
]


datasets = DATASETS_TOP + DATASETS_MORE + DATASETS_EXTRA






datasets.each do |dataset|
  league  = dataset[0]
  seasons = dataset[1] 
  puts
  puts "==> #{league} - #{seasons.size} season(s)"
  seasons.each do |season|
    check( league: league, season: season )
  end
end

puts "bye"

