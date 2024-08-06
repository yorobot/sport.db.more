$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )

require 'uefa'

Webcache.root = '/sports/cache'



=begin
Teams | UEFA Champions League 2024/25 | UEFA.com
Teams | History | UEFA Champions League | UEFA.com
Season 2022/23 Clubs | UEFA Champions League 2022/23 | UEFA.com
Season 1956/57 Clubs | UEFA Champions League 1956/57 | UEFA.com
=end

urls = []
## champions league
urls += [
  ['champs_2024-25', 'https://www.uefa.com/uefachampionsleague/clubs/'],
  ['champs_all',     'https://www.uefa.com/uefachampionsleague/history/clubs/'],
]
urls += (Season('1956/57')..Season('2023/24')).map do |season|
              ["champs_#{season.to_path}", Uefa.teams_champ_url( season: season )]
         end.reverse

## europa league
urls += [
  ['europa_2024-25', 'https://www.uefa.com/uefaeuropaleague/clubs/'],
  ['europa_all',     'https://www.uefa.com/uefaeuropaleague/history/clubs/'],
]
urls +=  (Season('1971/72')..Season('2023/24')).map do |season|
                  ["europa_#{season.to_path}", Uefa.teams_europa_url( season: season )]
               end.reverse

## conference league
urls += [
  ['conf_2024-25',   'https://www.uefa.com/uefaconferenceleague/clubs/'],
  ['conf_all',       'https://www.uefa.com/uefaconferenceleague/history/clubs/'],
]
urls +=  (Season('2021/22')..Season('2023/24')).map do |season|
                   ["conf_#{season.to_path}", Uefa.teams_conf_url( season: season )]
               end.reverse



urls.each do |basename, url|

  page = Uefa::Page::Teams.read_cache( url )


  puts
  puts page.title
  puts
  teams =  page.teams
  pp teams
  puts "  #{teams.size} team(s)"


  ## outpath = "./tmp/#{basename}_(#{teams.size}).csv"
  outpath = "../../clubs.sandbox/uefa/#{basename}_(#{teams.size}).csv"

  rows = teams.map {|rec|  [ rec[:names].join(' | '),
                             rec[:code].gsub( /[()]/, '' )
                           ]}

  headers = ['names', 'code']
  write_csv( outpath, rows, headers: headers )
end


puts "bye"