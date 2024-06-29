##
## todo:
##  - [ ] use all-in-one check dataset (clubs+seasons etc.)

require 'cocos'

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'footballdata' 



pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"

Webcache.root = '../../../cache'  ### c:\sports\cache

SEASONS = {}

def check( league:, year: )
  root = "#{Webcache.root}/api.football-data.org"
  path         = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  path_teams   = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~teams-I-season~#{year}.json"

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
  print "==>  #{league} #{year} - "
  print "#{data_teams['teams'].size} teams, "
  print "#{data['resultSet']['played']} / #{data['resultSet']['count']} matches, "
  print "start: #{data['matches'][0]['season']['startDate']} "
  print "#{data['resultSet']['first']}, "
  print "end: #{data['matches'][0]['season']['endDate']} "
  print "#{data['resultSet']['last']} "
  print "\n"
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




puts "bye"

