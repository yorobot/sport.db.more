$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )

require 'uefa'



#
##
#   fix upstreaim!!!!  - season/formats!!
##  def academic_year?() !calenar_year?; end
## Did you mean?  calendar_year?



Webcache.root = '/sports/cache'

Webget.config.sleep = 1  # delay in sec(s)



urls = []
## champions league
urls += %w[
  https://www.uefa.com/uefachampionsleague/clubs/
  https://www.uefa.com/uefachampionsleague/history/clubs/
]
urls +=  (Season('1956/57')..Season('2023/24')).map do |season|
                    Uefa.teams_champ_url( season: season )
               end.reverse

## europa league
urls += %w[
  https://www.uefa.com/uefaeuropaleague/clubs/
  https://www.uefa.com/uefaeuropaleague/history/clubs/
]
urls +=  (Season('1971/72')..Season('2023/24')).map do |season|
                   Uefa.teams_europa_url( season: season )
               end.reverse

## conference league
urls += %w[
   https://www.uefa.com/uefaconferenceleague/clubs/
   https://www.uefa.com/uefaconferenceleague/history/clubs/
]
urls +=  (Season('2021/22')..Season('2023/24')).map do |season|
                    Uefa.teams_conf_url( season: season )
               end.reverse

pp urls


urls.each do |url|
  if Webcache.cached?( url )
    puts "  OK  #{url}"
  else
    Webget.page( url )
  end
end


puts "bye"

